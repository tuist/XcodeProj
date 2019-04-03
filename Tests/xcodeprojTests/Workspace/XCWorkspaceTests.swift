import Foundation
import PathKit
import XcodeProj
import XCTest

final class XCWorkspaceIntegrationTests: XCTestCase {
    func test_initTheWorkspaceWithTheRightPropeties() {
        let path = fixturesPath() + "iOS/Project.xcodeproj/project.xcworkspace"
        let got = try? XCWorkspace(path: path)
        XCTAssertNotNil(got)
    }

    func test_init_returnsAWorkspaceWithTheCorrectReference() {
        XCTAssertEqual(XCWorkspace().data.children.count, 1)
        XCTAssertEqual(XCWorkspace().data.children.first, .file(.init(location: .self(""))))
    }
}
