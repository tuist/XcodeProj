import Foundation
import XCTest
import xcproj

final class PBXFileElementSpec: XCTestCase {

    var subject: PBXFileElement!

    override func setUp() {
        super.setUp()
        subject = PBXFileElement(sourceTree: .absolute,
                                 path: "path",
                                 name: "name")
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXFileElement.isa, "PBXFileElement")
    }

    func test_init_initializesTheFileElementWithTheRightAttributes() {
        XCTAssertEqual(subject.sourceTree, .absolute)
        XCTAssertEqual(subject.path, "path")
        XCTAssertEqual(subject.name, "name")
    }

    func test_equal_returnsTheCorrectValue() {
        let another = PBXFileElement(sourceTree: .absolute,
                                     path: "path",
                                     name: "name")
        XCTAssertEqual(subject, another)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "sourceTree": "absolute",
            "path": "path",
            "name": "name"
        ]
    }
}
