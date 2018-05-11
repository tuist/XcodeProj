import Foundation
import xcodeproj
import XCTest

class PBXSourcesBuildPhaseSpec: XCTestCase {
    func test_itHasTheCorrectIsa() {
        XCTAssertEqual(PBXSourcesBuildPhase.isa, "PBXSourcesBuildPhase")
    }
}
