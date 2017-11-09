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
    
    func test_init_usesAnEmptyWorkspace_whenItsMissing() {
        let got = projectWithoutWorkspace()
        XCTAssertNotNil(got)
    }

    func test_init_setsCorrectProjectName() {
        let proj = projectiOS()!.pbxproj
        let rootObject = proj.rootObject
        let rootProject = proj.projects.first(where: { $0.reference == rootObject })
        XCTAssertEqual(rootProject?.name, "Project")
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
