import Foundation
import PathKit
import XCTest

@testable import xcodeproj

final class WorkspaceSettingsTests: XCTestCase {
    func test_init() throws {
        let path = fixturesPath() + "WorkspaceSettings.xcsettings"
        let got = try WorkspaceSettings.at(path: path)
        XCTAssertEqual(got.buildSystem, "Original")
    }
}
