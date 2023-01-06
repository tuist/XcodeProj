import Foundation
import PathKit
import XCTest
@testable import XcodeProj

final class XcodeProjIntegrationTests: XCTestCase {
    func test_read_iosXcodeProj() throws {
        let subject = try XcodeProj(path: iosProjectPath)
        assert(project: subject)
    }

    func test_write_iosXcodeProj() {
        testWrite(from: iosProjectPath,
                  initModel: { try? XcodeProj(path: $0) },
                  modify: { project in
                      // XCUserData that is already in place (the removed element) should not be removed by a write
                      _ = project.userData.removeLast()
                      return project
                  },
                  assertion: { assert(project: $1) })
    }

    func test_read_write_produces_no_diff() throws {
        try testReadWriteProducesNoDiff(from: iosProjectPath,
                                        initModel: XcodeProj.init(path:))
    }

    // MARK: - Private

    private func assert(project: XcodeProj) {
        // Workspace
        XCTAssertEqual(project.workspace.data.children.count, 1)

        // Project
        XCTAssertEqual(project.pbxproj.objects.buildFiles.count, 13)

        // Shared Data
        XCTAssertNotNil(project.sharedData)
        XCTAssertEqual(project.sharedData?.schemes.count, 1)
        XCTAssertNotNil(project.sharedData?.breakpoints)
        XCTAssertNil(project.sharedData?.workspaceSettings)

        // User Data
        XCTAssertEqual(project.userData.count, 3)

        XCTAssertEqual(project.userData[0].userName, "username1")
        XCTAssertEqual(project.userData[0].schemes.count, 3)
        XCTAssertEqual(project.userData[0].breakpoints?.breakpoints.count, 2)
        XCTAssertNotNil(project.userData[0].schemeManagement)

        XCTAssertEqual(project.userData[1].userName, "username2")
        XCTAssertEqual(project.userData[1].schemes.count, 1)
        XCTAssertNil(project.userData[1].breakpoints?.breakpoints)
        XCTAssertNil(project.userData[1].schemeManagement)

        XCTAssertEqual(project.userData[2].userName, "username3")
        XCTAssertEqual(project.userData[2].schemes.count, 1)
        XCTAssertNotNil(project.userData[2].breakpoints?.breakpoints)
        XCTAssertNil(project.userData[2].schemeManagement)
    }

    private var iosProjectPath: Path {
        fixturesPath() + "iOS/Project.xcodeproj"
    }
}
