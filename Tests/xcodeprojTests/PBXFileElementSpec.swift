import Foundation
import XCTest
import xcodeproj

final class PBXFileElementSpec: XCTestCase {

    var subject: PBXFileElement!

    override func setUp() {
        super.setUp()
        subject = PBXFileElement(sourceTree: .absolute,
                                 path: "path",
                                 name: "name",
                                 includeInIndex: false,
                                 wrapsLines: true)
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXFileElement.isa, "PBXFileElement")
    }

    func test_init_initializesTheFileElementWithTheRightAttributes() {
        XCTAssertEqual(subject.sourceTree, .absolute)
        XCTAssertEqual(subject.path, "path")
        XCTAssertEqual(subject.name, "name")
        XCTAssertEqual(subject.includeInIndex, false)
        XCTAssertEqual(subject.wrapsLines, true)
    }

    func test_equal_returnsTheCorrectValue() {
        let another = PBXFileElement(sourceTree: .absolute,
                                     path: "path",
                                     name: "name",
                                     includeInIndex: false,
                                     wrapsLines: true)
        XCTAssertEqual(subject, another)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "sourceTree": "absolute",
            "path": "path",
            "name": "name",
            "includeInIndex": "0",
            "wrapsLines": "1"
        ]
    }
}
