import Foundation
import PathKit
import XCTest
@testable import XcodeProj

final class XCUserDataTests: XCTestCase {
    func test_read_userData() throws {
        let subject = try XCUserData(path: userDataPath)
        assert(userData: subject, userName: "username1")
    }

    func test_write_userData() {
        testWrite(from: userDataPath,
                  initModel: { try? XCUserData(path: $0) },
                  modify: { userData in
                      // XCScheme's that are already in place (the removed element) should not be removed by a write
                      userData.schemes = userData.schemes.filter { $0.name != "iOS-other"}
                      return userData
                  },
                  assertion: {
                    assert(userData: $1, userName: "copy")
                  })
    }

    func test_read_write_produces_no_diff() throws {
        try testReadWriteProducesNoDiff(from: userDataPath,
                                        initModel: XCUserData.init(path:))
    }

    // MARK: - Private

    private func assert(userData: XCUserData, userName: String) {
        XCTAssertEqual(userData.userName, userName)
        XCTAssertEqual(userData.schemes.count, 3)
        XCTAssertEqual(userData.breakpoints?.breakpoints.count, 2)
        XCTAssertEqual(userData.schemeManagement?.schemeUserState?.count, 6)
    }

    private var userDataPath: Path {
        fixturesPath() + "iOS/Project.xcodeproj/xcuserdata/username1.xcuserdatad"
    }
}
