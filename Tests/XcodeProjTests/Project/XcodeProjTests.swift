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
                  modify: { $0 },
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
        XCTAssertEqual(project.userData.count, 2)

        XCTAssertEqual(project.userData.first?.userName, "username1")
        XCTAssertEqual(project.userData.first?.schemes.count, 2)
        XCTAssertEqual(project.userData.first?.breakpoints?.breakpoints.count, 2)
        XCTAssertNotNil(project.userData.first?.schemeManagement)

        XCTAssertEqual(project.userData.last?.userName, "username2")
        XCTAssertEqual(project.userData.last?.schemes.count, 1)
        XCTAssertNil(project.userData.last?.breakpoints?.breakpoints)
        XCTAssertNil(project.userData.last?.schemeManagement)
    }

    private var iosProjectPath: Path {
        fixturesPath() + "iOS/Project.xcodeproj"
    }
}
