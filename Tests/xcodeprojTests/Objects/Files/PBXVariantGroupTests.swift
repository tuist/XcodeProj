import Foundation
import xcodeproj
import XCTest

final class PBXVariantGroupTests: XCTestCase {
    func test_itHasTheCorrectIsa() {
        XCTAssertEqual(PBXVariantGroup.isa, "PBXVariantGroup")
    }
}
