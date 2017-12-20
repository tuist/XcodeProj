import Foundation
import XCTest
import xcproj

final class PBXVariantGroupSpec: XCTestCase {

    var subject: PBXVariantGroup!

    override func setUp() {
        super.setUp()
        self.subject = PBXVariantGroup(reference: "reference",
                                       children: ["child"],
                                       name: "name",
                                       sourceTree: .group)
    }

    func test_init_initializesTheModelWithTheCorrectAttributes() {
        XCTAssertEqual(subject.reference, "reference")
        XCTAssertEqual(subject.children, ["child"])
        XCTAssertEqual(subject.name, "name")
        XCTAssertEqual(subject.sourceTree, .group)
    }

    func test_itHasTheCorrectIsa() {
        XCTAssertEqual(PBXVariantGroup.isa, "PBXVariantGroup")
    }

    func test_equals_returnsTheCorrectValue() {
        let one = PBXVariantGroup(reference: "reference", children: ["a"], name: "name", sourceTree: .group)
        let another = PBXVariantGroup(reference: "reference", children: ["a"], name: "name", sourceTree: .group)
        XCTAssertEqual(one, another)
    }

    func test_hashValue_returnsTheReferenceHasValue() {
        XCTAssertEqual(subject.hashValue, subject.reference.hashValue)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "children": ["child1", "child2"],
            "name": "name",
            "sourceTree": "SDKROOT",
            "reference": "reference"
        ]
    }

}
