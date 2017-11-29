import Foundation
import XCTest
import PathKit
import xcproj

final class XCBreakpointListIntegrationSpec: XCTestCase {

    var subject: XCBreakpointList?

    override func setUp() {
        subject = try? XCBreakpointList(path: fixturePath())
    }

    func test_init_initializesTheBreakpointListCorrectly() {
        XCTAssertNotNil(subject)
        if let subject = subject {
            assert(breakpointList: subject)
        }
    }

    func test_write() {
        testWrite(from: fixturePath(),
                  initModel: { try? XCBreakpointList(path: $0) },
                  modify: { $0 },
                  assertion: { assert(breakpointList: $1) })
    }

    // MARK: - Private

    private func assert(breakpointList: XCBreakpointList) {}

    private func fixturePath() -> Path {
        return fixturesPath() + Path("iOS/Project.xcodeproj/xcshareddata/xcdebugger/Breakpoints_v2.xcbkptlist")
    }

}
