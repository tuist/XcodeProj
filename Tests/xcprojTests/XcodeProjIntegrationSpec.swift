import Foundation
import XCTest
import PathKit
import xcproj

final class XcodeProjIntegrationSpec: XCTestCase {

    func test_init_throwsIfThePathIsWrong() {
        do {
            _ = try XcodeProj(path: Path("test"))
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_init_hasTheASharedData() {
        let got = projectiOS()
        XCTAssertNotNil(got?.sharedData)
    }

    func test_write() {
        testWrite(from: fixtureiOSProjectPath(),
                  initModel: { try? XcodeProj(path: $0) },
                  modify: { $0 })
    }

    func test_init_usesAnEmptyWorkspace_whenItsMissing() throws {
        let got = try projectWithoutWorkspace()
        XCTAssertEqual(got.workspace.data.children.count, 1)

        if case let XCWorkspaceDataElement.file(fileRef) = got.workspace.data.children[0] {
            XCTAssertEqual(fileRef.location.schema, "self")
        } else {
            XCTAssertTrue(false, "Expected \(XCWorkspaceDataElement.file)")
        }
    }

    func test_init_setsCorrectProjectName() {
        let proj = projectiOS()!.pbxproj
        let rootObject = proj.rootObject
        let rootProject = proj.objects.projects.getReference(rootObject)
        XCTAssertEqual(rootProject?.name, "Project")
    }

    func test_noChanges_encodesSameValue() throws {
        let pathsToProjectsToTest = [
            fixturesPath() + "iOS/BuildSettings.xcodeproj",
            fixturesPath() + "iOS/ProjectWithoutProductsGroup.xcodeproj"
        ]

        for path in pathsToProjectsToTest {
            let rawProj: String = try (path + "project.pbxproj").read()
            let proj = try XcodeProj(path: path)

            let output = proj.pbxproj.encode()

            XCTAssertEqual(output, rawProj)
        }
    }

    func test_aQuoted_encodesSameValue() throws {
        let path = fixturesPath() + "iOS/BuildSettings.xcodeproj"
        let rawProj: String = try (path + "project.pbxproj").read()

        let proj = try XcodeProj(path: path)
        let buildConfiguration = proj.pbxproj.objects.buildConfigurations.first!.value
        buildConfiguration.buildSettings["a_quoted"] = "a".quoted

        let output = proj.pbxproj.encode()

        XCTAssertEqual(output, rawProj)
    }

    // MARK: - Paths

    func test_workspacePath() {
        let path = fixturesPath() + "iOS/BuildSettings.xcodeproj"
        XCTAssertEqual(XcodeProj.workspacePath(path),
                       fixturesPath() + "iOS/BuildSettings.xcodeproj/project.xcworkspace")
    }

    func test_pbxprojPath() {
        let path = fixturesPath() + "iOS/BuildSettings.xcodeproj"
        XCTAssertEqual(XcodeProj.pbxprojPath(path),
                       fixturesPath() + "iOS/BuildSettings.xcodeproj/project.pbxproj")
    }

    func test_schemePath() {
        let path = fixturesPath() + "iOS/BuildSettings.xcodeproj"
        XCTAssertEqual(XcodeProj.schemePath(path, schemeName: "Scheme"),
                       fixturesPath() + "iOS/BuildSettings.xcodeproj/xcshareddata/xcschemes/Scheme.xcscheme")
    }

    func test_breakPointsPath() {
        let path = fixturesPath() + "iOS/BuildSettings.xcodeproj"
        XCTAssertEqual(XcodeProj.breakPointsPath(path),
                       fixturesPath() + "iOS/BuildSettings.xcodeproj/xcshareddata/xcdebugger/Breakpoints_v2.xcbkptlist")
    }

    // MARK: - File add

    func test_add_new_group() throws {
        let project = projectiOS()!.pbxproj

        let groups = project.objects.addGroup(named: "Group", to: project.rootGroup)
        let groupRef = XCTAssertNotNilAndUnwrap(groups.first)

        let group = groupRef.object
        XCTAssertEqual(group.name, "Group")
        XCTAssertEqual(group.path, "Group")

        let reference = groupRef.reference
        XCTAssertNotNil(project.rootGroup.children.index(of: reference))
        XCTAssertEqual(project.objects.groups[reference], group)
    }

    func test_add_new_group_without_folder_has_nil_path() {
        let project = projectiOS()!.pbxproj
        let groups = project.objects.addGroup(named: "Group", to: project.rootGroup, options: [.withoutFolder])
        let group = XCTAssertNotNilAndUnwrap(groups.first).object
        XCTAssertEqual(group.name, "Group")
        XCTAssertNil(group.path)
    }

    func test_add_existing_group_returns_existing_object() {
        let project = projectiOS()!.pbxproj
        let groups = project.objects.addGroup(named: "Group", to: project.rootGroup)
        let existingGroups = project.objects.addGroup(named: "Group", to: project.rootGroup)
        XCTAssertEqual(groups[0], existingGroups[0])
    }

    func test_add_nested_group() throws {
        let project = projectiOS()!
        let groups = project.pbxproj.objects.addGroup(named: "New/Group", to: project.pbxproj.rootGroup)
        let group1 = groups[0]
        let group2 = groups[1]

        XCTAssertEqual(group1.object.name, "New")
        XCTAssertEqual(group2.object.name, "Group")

        XCTAssertNotNil(project.pbxproj.rootGroup.children.index(of: group1.reference))
        XCTAssertNotNil(group1.object.children.index(of: group2.reference))

        XCTAssertEqual(project.pbxproj.objects.groups[group1.reference], group1.object)
        XCTAssertEqual(project.pbxproj.objects.groups[group2.reference], group2.object)

        let existingGroups = project.pbxproj.objects.addGroup(named: "New/Group", to: project.pbxproj.rootGroup)

        XCTAssertTrue(groups[0] == existingGroups[0])

        let newGroups = project.pbxproj.objects.addGroup(named: "New/Group1", to: project.pbxproj.rootGroup)

        XCTAssertTrue(newGroups[0] == existingGroups[0])
        XCTAssertNotNil(newGroups[0].object.children.index(of: groups[1].reference))
        XCTAssertEqual(project.pbxproj.objects.groups[newGroups[1].reference], newGroups[1].object)
    }

    func test_add_new_source_file() throws {
        let proj = projectiOS()!.pbxproj
        let filePath = fixturesPath() + "newfile.swift"
        let iOSGroup = proj.objects.group(named: "iOS", inGroup: proj.rootGroup)!
        let file = try proj.objects.addFile(at: filePath, toGroup: iOSGroup.object, sourceRoot: fixturesPath() + "iOS")

        let expectedFile = PBXFileReference(sourceTree: .group,
                                            name: "newfile.swift",
                                            explicitFileType: "sourcecode.swift",
                                            lastKnownFileType: "sourcecode.swift",
                                            path: "../../newfile.swift")

        XCTAssertEqual(proj.objects.fileReferences[file.reference], file.object)
        XCTAssertEqual(file.object, expectedFile)
        XCTAssertNotNil(iOSGroup.object.children.index(of: file.reference))

        let existingFile = try proj.objects.addFile(at: filePath, toGroup: proj.rootGroup, sourceRoot: fixturesPath() + "iOS")

        XCTAssertTrue(file == existingFile)
    }

    func test_add_new_dynamic_framework() throws {
        let proj = projectiOS()!.pbxproj
        let filePath = fixturesPath() + "dummy.framework"

        let iOSGroup = proj.objects.group(named: "iOS", inGroup: proj.rootGroup)!
        let file = try proj.objects.addFile(at: filePath,
                                            toGroup: iOSGroup.object,
                                            sourceRoot: fixtureiOSSourcePath())

        let expectedFile = PBXFileReference(sourceTree: .group,
                                            name: "dummy.framework",
                                            explicitFileType: "wrapper.framework",
                                            lastKnownFileType: "wrapper.framework",
                                            path: "../../dummy.framework")


        XCTAssertEqual(proj.objects.fileReferences[file.reference], file.object)
        XCTAssertEqual(file.object, expectedFile)
        XCTAssertNotNil(iOSGroup.object.children.index(of: file.reference))
    }

    func test_add_existing_file_returns_existing_object() throws {
        let proj = projectiOS()!.pbxproj
        let filePath = fixturesPath() + "newfile.swift"
        let iOSGroup = proj.objects.group(named: "iOS", inGroup: proj.rootGroup)!.object

        let file = try proj.objects.addFile(at: filePath, toGroup: iOSGroup, sourceRoot: fixtureiOSSourcePath())
        let existingFile = try proj.objects.addFile(at: filePath, toGroup: proj.rootGroup, sourceRoot: fixtureiOSSourcePath())
        XCTAssertTrue(file == existingFile)
    }

    func test_add_nonexisting_file_throws() {
        let proj = projectiOS()!.pbxproj
        let filePath = fixturesPath() + "nonexisting.swift"
        XCTAssertThrowsSpecificError(
            try proj.objects.addFile(at: filePath, toGroup: proj.rootGroup, sourceRoot: fixtureiOSSourcePath()),
            XCodeProjEditingError.fileNotExists(path: filePath),
            "Adding a reference to non existing file should throw an error"
        )
    }

    func test_add_new_build_file() throws {
        let proj = projectiOS()!.pbxproj
        let target = proj.objects.targets(named: "iOS").first!
        let sourcesBuildPhase = proj.objects.sourcesBuildPhase(target: target.object)!
        let filePath = fixturesPath() + "newfile.swift"
        let file = try proj.objects.addFile(at: filePath, toGroup: proj.rootGroup, sourceRoot: fixturesPath() + "iOS")

        let buildFile = proj.objects.addBuildFile(toTarget: target.object, reference: file.reference)!

        XCTAssertEqual(proj.objects.buildFiles[buildFile.reference], buildFile.object)
        XCTAssertNotNil(sourcesBuildPhase.files.index(of: buildFile.reference))

        let existingBuildFile = proj.objects.addBuildFile(toTarget: target.object, reference: file.reference)!

        XCTAssertTrue(existingBuildFile == buildFile)
    }

    func test_fullFilePath() throws {
        let sourceRoot = fixturesPath() + "iOS"
        var proj = projectiOS()!.pbxproj
        var iOSGroup = proj.objects.group(named: "iOS", inGroup: proj.rootGroup)!.object

        let rootGroupPath = proj.objects.fullPath(fileElement: proj.rootGroup, reference: proj.rootProject!.mainGroup, sourceRoot: sourceRoot)
        XCTAssertEqual(rootGroupPath, sourceRoot)

        let filePath = fixturesPath() + "newfile.swift"
        var file = try proj.objects.addFile(at: filePath, toGroup: iOSGroup, sourceTree: .group, sourceRoot: sourceRoot)
        var fullFilePath = proj.objects.fullPath(fileElement: file.object, reference: file.reference, sourceRoot: sourceRoot)

        XCTAssertEqual(file.object.path, "../../newfile.swift")
        XCTAssertEqual(fullFilePath, filePath)

        let groupWithoutFolder = proj.objects.group(named: "GroupWithoutFolder", inGroup: iOSGroup)!.object
        file = try proj.objects.addFile(at: filePath, toGroup: groupWithoutFolder, sourceTree: .group, sourceRoot: sourceRoot)
        fullFilePath = proj.objects.fullPath(fileElement: file.object, reference: file.reference, sourceRoot: sourceRoot)

        XCTAssertEqual(file.object.path, "../../newfile.swift")
        XCTAssertEqual(fullFilePath, filePath)

        proj = projectiOS()!.pbxproj
        iOSGroup = proj.objects.group(named: "iOS", inGroup: proj.rootGroup)!.object
        file = try proj.objects.addFile(at: filePath, toGroup: iOSGroup, sourceTree: .sourceRoot, sourceRoot: sourceRoot)
        fullFilePath = proj.objects.fullPath(fileElement: file.object, reference: file.reference, sourceRoot: sourceRoot)

        XCTAssertEqual(file.object.path, "../newfile.swift")
        XCTAssertEqual(fullFilePath, filePath)

        proj = projectiOS()!.pbxproj
        iOSGroup = proj.objects.group(named: "iOS", inGroup: proj.rootGroup)!.object
        file = try proj.objects.addFile(at: filePath, toGroup: iOSGroup, sourceTree: .absolute, sourceRoot: sourceRoot)
        fullFilePath = proj.objects.fullPath(fileElement: file.object, reference: file.reference, sourceRoot: sourceRoot)

        XCTAssertEqual(file.object.path, filePath.string)
        XCTAssertEqual(fullFilePath, filePath)

        let mainStoryboard = proj.objects.variantGroups.first { $0.value.name == "Main.storyboard" }!
        let mainStoryboardfullPath = proj.objects.fullPath(fileElement: mainStoryboard.value, reference: mainStoryboard.key, sourceRoot: sourceRoot)

        XCTAssertEqual(mainStoryboardfullPath, fixturesPath() + "iOS/iOS/Base.lproj/Main.storyboard")
    }

    func test_path_relativeToPath() {
        let sourceRoot = fixturesPath() + "iOS"

        var filePath = sourceRoot + "iOS/file.swift"
        XCTAssertEqual(filePath.relativeTo(sourceRoot), Path("iOS/file.swift"))
        XCTAssertEqual(sourceRoot.relativeTo(filePath), Path("../.."))
        XCTAssertEqual(filePath + Path("../.."), sourceRoot)

        filePath = sourceRoot + "file.swift"
        XCTAssertEqual(filePath.relativeTo(sourceRoot), Path("file.swift"))
        XCTAssertEqual(sourceRoot.relativeTo(filePath), Path(".."))
        XCTAssertEqual(filePath + Path(".."), sourceRoot)

        filePath = sourceRoot
        XCTAssertEqual(filePath.relativeTo(sourceRoot), Path("."))
        XCTAssertEqual(sourceRoot.relativeTo(filePath), Path("."))

        filePath = sourceRoot + "../file.swift"
        XCTAssertEqual(filePath.relativeTo(sourceRoot), Path("../file.swift"))
        XCTAssertEqual(sourceRoot.relativeTo(filePath), Path("../iOS"))
        XCTAssertEqual(filePath + Path("../iOS"), sourceRoot)

        filePath = sourceRoot + "../../file.swift"
        XCTAssertEqual(filePath.relativeTo(sourceRoot), Path("../../file.swift"))
        XCTAssertEqual(sourceRoot.relativeTo(filePath), Path("../Fixtures/iOS"))
        XCTAssertEqual(filePath + Path("../Fixtures/iOS"), sourceRoot)
    }

    // MARK: - Private

    private func fixtureWithoutWorkspaceProjectPath() -> Path {
        return fixturesPath() + "WithoutWorkspace/WithoutWorkspace.xcodeproj"
    }

    private func fixtureiOSProjectPath() -> Path {
        return fixturesPath() + "iOS/Project.xcodeproj"
    }

    private func fixtureiOSSourcePath() -> Path {
        return fixturesPath() + "iOS"
    }

    private func projectiOS() -> XcodeProj? {
        return try? XcodeProj(path: fixtureiOSProjectPath())
    }

    private func projectWithoutWorkspace() throws -> XcodeProj {
        return try XcodeProj(path: fixtureWithoutWorkspaceProjectPath())
    }
}

// This could be code generated (e.g. using sourcery)
extension XCodeProjEditingError: Equatable {

    static public func == (lhs: XCodeProjEditingError, rhs: XCodeProjEditingError) -> Bool {
        switch (lhs, rhs) {
        case (.fileNotExists(let path1), .fileNotExists(let path2)):
            return path1 == path2
        case (.groupNotFound(let group1), .groupNotFound(let group2)):
            return group1 == group2
        default:
            return false
        }
    }
}
