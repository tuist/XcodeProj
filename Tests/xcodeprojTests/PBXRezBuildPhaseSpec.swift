import Foundation
import xcodeproj
import XCTest

final class PBXRezBuildPhaseSpec: XCTestCase {
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXRezBuildPhase.isa, "PBXRezBuildPhase")
    }
}
