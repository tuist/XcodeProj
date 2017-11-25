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
    
    func test_init_usesAnEmptyWorkspace_whenItsMissing() {
        let got = projectWithoutWorkspace()
        XCTAssertNotNil(got)
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
    
    private func projectWithoutWorkspace() -> XcodeProj? {
        return try? XcodeProj(path: fixtureWithoutWorkspaceProjectPath())
    }
}
