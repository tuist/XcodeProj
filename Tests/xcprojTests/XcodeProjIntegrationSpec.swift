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
