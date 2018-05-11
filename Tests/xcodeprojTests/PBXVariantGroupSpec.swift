import Foundation
import xcodeproj
import XCTest

final class PBXVariantGroupSpec: XCTestCase {
    func test_itHasTheCorrectIsa() {
        XCTAssertEqual(PBXVariantGroup.isa, "PBXVariantGroup")
    }
}
