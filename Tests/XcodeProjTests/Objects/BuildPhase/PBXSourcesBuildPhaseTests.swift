import Foundation
import XcodeProj
import XCTest

class PBXSourcesBuildPhaseTests: XCTestCase {
    func test_itHasTheCorrectIsa() {
        XCTAssertEqual(PBXSourcesBuildPhase.isa, "PBXSourcesBuildPhase")
    }
}
