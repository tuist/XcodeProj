import Foundation
import XCTest
import PathKit
@testable import xcproj

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
            let encoder = PBXProjEncoder()
            let output = encoder.encode(proj: proj.pbxproj)
            
            XCTAssertEqual(output, rawProj)
        }
    }

    func test_aQuoted_encodesSameValue() throws {
        let path = fixturesPath() + "iOS/BuildSettings.xcodeproj"
        let rawProj: String = try (path + "project.pbxproj").read()

        let proj = try XcodeProj(path: path)
        let buildConfiguration = proj.pbxproj.objects.buildConfigurations.first!.value
        buildConfiguration.buildSettings["a_quoted"] = "a".quoted

        let encoder = PBXProjEncoder()
        let output = encoder.encode(proj: proj.pbxproj)

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
        let project = projectiOS()!
        let groups = project.pbxproj.objects.addGroup(named: "Group", to: project.pbxproj.rootGroup)
        let (reference, group) = groups[0]

        XCTAssertEqual(group.name, "Group")
        XCTAssertNotNil(project.pbxproj.rootGroup.children.index(of: reference))
        XCTAssertEqual(project.pbxproj.objects.groups[reference], group)

        let existingGroups = project.pbxproj.objects.addGroup(named: "Group", to: project.pbxproj.rootGroup)
        XCTAssertTrue(groups[0] == existingGroups[0])
    }

    func test_add_nested_group() throws {
        let project = projectiOS()!
        let groups = project.pbxproj.objects.addGroup(named: "New/Group", to: project.pbxproj.rootGroup)
        let (reference1, group1) = groups[0]
        let (reference2, group2) = groups[1]

        XCTAssertEqual(group1.name, "New")
        XCTAssertEqual(group2.name, "Group")

        XCTAssertNotNil(project.pbxproj.rootGroup.children.index(of: reference1))
        XCTAssertNotNil(group1.children.index(of: reference2))

        XCTAssertEqual(project.pbxproj.objects.groups[reference1], group1)
        XCTAssertEqual(project.pbxproj.objects.groups[reference2], group2)

        let existingGroups = project.pbxproj.objects.addGroup(named: "New/Group", to: project.pbxproj.rootGroup)

        XCTAssertTrue(groups[0] == existingGroups[0])

        let newGroups = project.pbxproj.objects.addGroup(named: "New/Group1", to: project.pbxproj.rootGroup)

        XCTAssertTrue(newGroups[0] == existingGroups[0])
        XCTAssertNotNil(newGroups[0].group.children.index(of: groups[1].reference))
        XCTAssertEqual(project.pbxproj.objects.groups[newGroups[1].reference], newGroups[1].group)
    }

    func test_add_new_file() throws {
        let proj = projectiOS()!.pbxproj
        let filePath = fixturesPath() + "newfile.swift"
        let iOSGroup = proj.objects.group(named: "iOS", inGroup: proj.rootGroup)!.group
        let file = try proj.objects.addFile(at: filePath, toGroup: iOSGroup, sourceRoot: fixturesPath() + "iOS")

        XCTAssertEqual(proj.objects.fileReferences[file.reference], file.file)
        XCTAssertEqual(file.file.name, "newfile.swift")
        XCTAssertEqual(file.file.sourceTree, PBXSourceTree.group)
        XCTAssertEqual(file.file.path, "../../newfile.swift")
        XCTAssertNotNil(iOSGroup.children.index(of: file.reference))

        let existingFile = try proj.objects.addFile(at: filePath, toGroup: proj.rootGroup, sourceRoot: fixturesPath() + "iOS")

        XCTAssertTrue(file == existingFile)
    }

    func test_add_not_a_file() throws {
        let proj = projectiOS()!.pbxproj
        do {
            _ = try proj.objects.addFile(at: fixturesPath() + "iOS/iOS", toGroup: proj.rootGroup, sourceRoot: fixturesPath() + "iOS")
            XCTFail("Adding not file path should throw error")
        } catch {}

        do {
            _ = try proj.objects.addFile(at: fixturesPath() + "iOS/iOS/newfile.swift", toGroup: proj.rootGroup, sourceRoot: fixturesPath() + "iOS")
            XCTFail("Adding not existing file should throw error")
        } catch {}
    }

    func test_add_new_build_file() throws {
        let proj = projectiOS()!.pbxproj
        let target = proj.objects.targets(named: "iOS").first!
        let sourcesBuildPhase = proj.objects.sourcesBuildPhase(target: target)!
        let filePath = fixturesPath() + "newfile.swift"
        let file = try proj.objects.addFile(at: filePath, toGroup: proj.rootGroup, sourceRoot: fixturesPath() + "iOS")

        let buildFile = proj.objects.addBuildFile(toTarget: target, reference: file.reference)!

        XCTAssertEqual(proj.objects.buildFiles[buildFile.reference], buildFile.file)
        XCTAssertNotNil(sourcesBuildPhase.files.index(of: buildFile.reference))

        let existingBuildFile = proj.objects.addBuildFile(toTarget: target, reference: file.reference)!

        XCTAssertTrue(existingBuildFile == buildFile)
    }

    func test_fullFilePath() throws {
        let sourceRoot = fixturesPath() + "iOS"
        var proj = projectiOS()!.pbxproj
        var iOSGroup = proj.objects.group(named: "iOS", inGroup: proj.rootGroup)!.group

        let rootGroupPath = proj.objects.fullPath(fileElement: proj.rootGroup, reference: proj.rootProject!.mainGroup, sourceRoot: sourceRoot)
        XCTAssertEqual(rootGroupPath, sourceRoot)

        let filePath = fixturesPath() + "newfile.swift"
        var file = try proj.objects.addFile(at: filePath, toGroup: iOSGroup, sourceTree: .group, sourceRoot: sourceRoot)
        var fullFilePath = proj.objects.fullPath(fileElement: file.file, reference: file.reference, sourceRoot: sourceRoot)

        XCTAssertEqual(file.file.path, "../../newfile.swift")
        XCTAssertEqual(fullFilePath, filePath)

        proj = projectiOS()!.pbxproj
        iOSGroup = proj.objects.group(named: "iOS", inGroup: proj.rootGroup)!.group
        file = try proj.objects.addFile(at: filePath, toGroup: iOSGroup, sourceTree: .sourceRoot, sourceRoot: sourceRoot)
        fullFilePath = proj.objects.fullPath(fileElement: file.file, reference: file.reference, sourceRoot: sourceRoot)

        XCTAssertEqual(file.file.path, "../newfile.swift")
        XCTAssertEqual(fullFilePath, filePath)

        proj = projectiOS()!.pbxproj
        iOSGroup = proj.objects.group(named: "iOS", inGroup: proj.rootGroup)!.group
        file = try proj.objects.addFile(at: filePath, toGroup: iOSGroup, sourceTree: .absolute, sourceRoot: sourceRoot)
        fullFilePath = proj.objects.fullPath(fileElement: file.file, reference: file.reference, sourceRoot: sourceRoot)

        XCTAssertEqual(file.file.path, filePath.string)
        XCTAssertEqual(fullFilePath, filePath)
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
    
    private func projectiOS() -> XcodeProj? {
        return try? XcodeProj(path: fixtureiOSProjectPath())
    }
    
    private func projectWithoutWorkspace() throws -> XcodeProj {
        return try XcodeProj(path: fixtureWithoutWorkspaceProjectPath())
    }
}
