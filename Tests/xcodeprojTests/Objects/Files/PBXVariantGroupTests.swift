import Foundation
import XcodeProj
import XCTest

final class PBXVariantGroupTests: XCTestCase {
    func test_itHasTheCorrectIsa() {
        XCTAssertEqual(PBXVariantGroup.isa, "PBXVariantGroup")
    }
}
