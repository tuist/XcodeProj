import Foundation
import xcodeproj
import XCTest

final class PBXGroupSpec: XCTestCase {
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXGroup.isa, "PBXGroup")
    }

    private func testDictionary() -> [String: Any] {
        return [
            "children": ["child"],
            "name": "name",
            "sourceTree": "absolute",
        ]
    }
}
