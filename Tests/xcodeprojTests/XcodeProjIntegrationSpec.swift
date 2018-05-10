import Basic
import Foundation
@testable import xcodeproj
import XCTest

final class XcodeProjIntegrationSpec: XCTestCase {
    func test_init_throwsIfThePathIsWrong() {
        do {
            _ = try XcodeProj(path: AbsolutePath("/test"))
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
            fixturesPath().appending(RelativePath("iOS/BuildSettings.xcodeproj")),
            fixturesPath().appending(RelativePath("iOS/ProjectWithoutProductsGroup.xcodeproj")),
        ]

        for path in pathsToProjectsToTest {
            let rawProj: String = try (path.appending(component: "project.pbxproj")).read()
            let proj = try XcodeProj(path: path)

            let output = try proj.pbxproj.encode()

            XCTAssertEqual(output, rawProj)
        }
    }

    func test_aQuoted_encodesSameValue() throws {
        let path = fixturesPath().appending(RelativePath("iOS/BuildSettings.xcodeproj"))
        let rawProj: String = try (path.appending(component: "project.pbxproj")).read()

        let proj = try XcodeProj(path: path)
        let buildConfiguration = proj.pbxproj.objects.buildConfigurations.first!.value
        buildConfiguration.buildSettings["a_quoted"] = "a".quoted

        let output = try proj.pbxproj.encode()

        XCTAssertEqual(output, rawProj)
    }

    // MARK: - Paths

    func test_workspacePath() {
        let path = fixturesPath().appending(RelativePath("iOS/BuildSettings.xcodeproj"))
        XCTAssertEqual(XcodeProj.workspacePath(path),
                       fixturesPath().appending(RelativePath("iOS/BuildSettings.xcodeproj/project.xcworkspace")))
    }

    func test_pbxprojPath() {
        let path = fixturesPath().appending(RelativePath("iOS/BuildSettings.xcodeproj"))
        XCTAssertEqual(XcodeProj.pbxprojPath(path),
                       fixturesPath().appending(RelativePath("iOS/BuildSettings.xcodeproj/project.pbxproj")))
    }

    func test_schemePath() {
        let path = fixturesPath().appending(RelativePath("iOS/BuildSettings.xcodeproj"))
        XCTAssertEqual(XcodeProj.schemePath(path, schemeName: "Scheme"),
                       fixturesPath().appending(RelativePath("iOS/BuildSettings.xcodeproj/xcshareddata/xcschemes/Scheme.xcscheme")))
    }

    func test_breakPointsPath() {
        let path = fixturesPath().appending(RelativePath("iOS/BuildSettings.xcodeproj"))
        XCTAssertEqual(XcodeProj.breakPointsPath(path),
                       fixturesPath().appending(RelativePath("iOS/BuildSettings.xcodeproj/xcshareddata/xcdebugger/Breakpoints_v2.xcbkptlist")))
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
        XCTAssertEqual(project.objects.groups.getReference(reference), group)
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

        XCTAssertEqual(project.pbxproj.objects.groups.getReference(group1.reference), group1.object)
        XCTAssertEqual(project.pbxproj.objects.groups.getReference(group2.reference), group2.object)

        let existingGroups = project.pbxproj.objects.addGroup(named: "New/Group", to: project.pbxproj.rootGroup)

        XCTAssertTrue(groups[0] == existingGroups[0])

        let newGroups = project.pbxproj.objects.addGroup(named: "New/Group1", to: project.pbxproj.rootGroup)

        XCTAssertTrue(newGroups[0] == existingGroups[0])
        XCTAssertNotNil(newGroups[0].object.children.index(of: groups[1].reference))
        XCTAssertEqual(project.pbxproj.objects.groups.getReference(newGroups[1].reference), newGroups[1].object)
    }

    func test_add_new_source_file() throws {
        let proj = projectiOS()!.pbxproj
        let filePath = fixturesPath().appending(component: "newfile.swift")
        let iOSGroup = proj.objects.group(named: "iOS", inGroup: proj.rootGroup)!
        let file = try proj.objects.addFile(at: filePath, toGroup: iOSGroup.object, sourceRoot: fixturesPath().appending(component: "iOS"))

        let expectedFile = PBXFileReference(sourceTree: .group,
                                            name: "newfile.swift",
                                            explicitFileType: "sourcecode.swift",
                                            lastKnownFileType: "sourcecode.swift",
                                            path: "../../newfile.swift")

        XCTAssertEqual(proj.objects.fileReferences.getReference(file.reference), file.object)
        XCTAssertEqual(file.object, expectedFile)
        XCTAssertNotNil(iOSGroup.object.children.index(of: file.reference))

        let existingFile = try proj.objects.addFile(at: filePath, toGroup: proj.rootGroup, sourceRoot: fixturesPath().appending(component: "iOS"))

        XCTAssertTrue(file == existingFile)
    }

    func test_add_new_dynamic_framework() throws {
        let proj = projectiOS()!.pbxproj
        let filePath = fixturesPath().appending(component: "dummy.framework")

        let iOSGroup = proj.objects.group(named: "iOS", inGroup: proj.rootGroup)!
        let file = try proj.objects.addFile(at: filePath,
                                            toGroup: iOSGroup.object,
                                            sourceRoot: fixtureiOSSourcePath())

        let expectedFile = PBXFileReference(sourceTree: .group,
                                            name: "dummy.framework",
                                            explicitFileType: "wrapper.framework",
                                            lastKnownFileType: "wrapper.framework",
                                            path: "../../dummy.framework")

        XCTAssertEqual(proj.objects.fileReferences.getReference(file.reference), file.object)
        XCTAssertEqual(file.object, expectedFile)
        XCTAssertNotNil(iOSGroup.object.children.index(of: file.reference))
    }

    func test_add_existing_file_returns_existing_object() throws {
        let proj = projectiOS()!.pbxproj
        let filePath = fixturesPath().appending(component: "newfile.swift")
        let iOSGroup = proj.objects.group(named: "iOS", inGroup: proj.rootGroup)!.object

        let file = try proj.objects.addFile(at: filePath, toGroup: iOSGroup, sourceRoot: fixtureiOSSourcePath())
        let existingFile = try proj.objects.addFile(at: filePath, toGroup: proj.rootGroup, sourceRoot: fixtureiOSSourcePath())
        XCTAssertTrue(file == existingFile)
    }

    func test_add_nonexisting_file_throws() {
        let proj = projectiOS()!.pbxproj
        let filePath = fixturesPath().appending(component: "nonexisting.swift")
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
        let filePath = fixturesPath().appending(component: "newfile.swift")
        let file = try proj.objects.addFile(at: filePath, toGroup: proj.rootGroup, sourceRoot: fixturesPath().appending(component: "iOS"))

        let buildFile = proj.objects.addBuildFile(toTarget: target.object, reference: file.reference)!

        XCTAssertEqual(proj.objects.buildFiles.getReference(buildFile.reference), buildFile.object)
        XCTAssertNotNil(sourcesBuildPhase.files.index(of: buildFile.reference))

        let existingBuildFile = proj.objects.addBuildFile(toTarget: target.object, reference: file.reference)!

        XCTAssertTrue(existingBuildFile == buildFile)
    }

    func test_fullFilePath() throws {
        let sourceRoot = fixturesPath().appending(RelativePath("iOS"))
        var proj = projectiOS()!.pbxproj
        var iOSGroup = proj.objects.group(named: "iOS", inGroup: proj.rootGroup)!.object

        let rootGroupPath = proj.objects.fullPath(fileElement: proj.rootGroup, reference: proj.rootProject!.mainGroup, sourceRoot: sourceRoot)
        XCTAssertEqual(rootGroupPath, sourceRoot)

        let filePath = fixturesPath().appending(RelativePath("newfile.swift"))
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

        XCTAssertEqual(file.object.path, filePath.asString)
        XCTAssertEqual(fullFilePath, filePath)

        let mainStoryboard = proj.objects.variantGroups.first { $0.value.name == "Main.storyboard" }!
        let mainStoryboardfullPath = proj.objects.fullPath(fileElement: mainStoryboard.value,
                                                           reference: mainStoryboard.key.value,
                                                           sourceRoot: sourceRoot)

        XCTAssertEqual(mainStoryboardfullPath, fixturesPath().appending(RelativePath("iOS/iOS/Base.lproj/Main.storyboard")))
    }

    func test_path_relativeToPath() {
        let sourceRoot = fixturesPath().appending(component: "iOS")

        var filePath = sourceRoot.appending(RelativePath("iOS/file.swift"))
        XCTAssertEqual(filePath.relative(to: sourceRoot), RelativePath("iOS/file.swift"))
        XCTAssertEqual(sourceRoot.relative(to: filePath), RelativePath("../.."))
        XCTAssertEqual(filePath.appending(RelativePath("../..")), sourceRoot)

        filePath = sourceRoot.appending(RelativePath("file.swift"))
        XCTAssertEqual(filePath.relative(to: sourceRoot), RelativePath("file.swift"))
        XCTAssertEqual(sourceRoot.relative(to: filePath), RelativePath(".."))
        XCTAssertEqual(filePath.appending(RelativePath("..")), sourceRoot)

        filePath = sourceRoot
        XCTAssertEqual(filePath.relative(to: sourceRoot), RelativePath("."))
        XCTAssertEqual(sourceRoot.relative(to: filePath), RelativePath("."))

        filePath = sourceRoot.appending(RelativePath("../file.swift"))
        XCTAssertEqual(filePath.relative(to: sourceRoot), RelativePath("../file.swift"))
        XCTAssertEqual(sourceRoot.relative(to: filePath), RelativePath("../iOS"))
        XCTAssertEqual(filePath.appending(RelativePath("../iOS")), sourceRoot)

        filePath = sourceRoot.appending(RelativePath("../../file.swift"))
        XCTAssertEqual(filePath.relative(to: sourceRoot), RelativePath("../../file.swift"))
        XCTAssertEqual(sourceRoot.relative(to: filePath), RelativePath("../Fixtures/iOS"))
        XCTAssertEqual(filePath.appending(RelativePath("../Fixtures/iOS")), sourceRoot)
    }

    // MARK: - Private

    private func fixtureWithoutWorkspaceProjectPath() -> AbsolutePath {
        return fixturesPath().appending(RelativePath("WithoutWorkspace/WithoutWorkspace.xcodeproj"))
    }

    private func fixtureiOSProjectPath() -> AbsolutePath {
        return fixturesPath().appending(RelativePath("iOS/Project.xcodeproj"))
    }

    private func fixtureiOSSourcePath() -> AbsolutePath {
        return fixturesPath().appending(RelativePath("iOS"))
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
    public static func == (lhs: XCodeProjEditingError, rhs: XCodeProjEditingError) -> Bool {
        switch (lhs, rhs) {
        case let (.fileNotExists(path1), .fileNotExists(path2)):
            return path1 == path2
        case let (.groupNotFound(group1), .groupNotFound(group2)):
            return group1 == group2
        default:
            return false
        }
    }
}
