import Foundation
import XCTest
import xcproj

final class PBXFileElementSpec: XCTestCase {

    var subject: PBXFileElement!

    override func setUp() {
        super.setUp()
        subject = PBXFileElement(reference: "ref",
                                 sourceTree: .absolute,
                                 path: "path",
                                 name: "name")
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXFileElement.isa, "PBXFileElement")
    }

    func test_init_initializesTheFileElementWithTheRightAttributes() {
        XCTAssertEqual(subject.reference, "ref")
        XCTAssertEqual(subject.sourceTree, .absolute)
        XCTAssertEqual(subject.path, "path")
        XCTAssertEqual(subject.name, "name")
    }

    func test_equal_returnsTheCorrectValue() {
        let another = PBXFileElement(reference: "ref",
                                     sourceTree: .absolute,
                                     path: "path",
                                     name: "name")
        XCTAssertEqual(subject, another)
    }

    func test_hashValue_returnsTheReferenceHashValue() {
        XCTAssertEqual(subject.hashValue, subject.reference.hashValue)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "reference": "reference",
            "sourceTree": "absolute",
            "path": "path",
            "name": "name"
        ]
    }
}
