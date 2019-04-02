import Foundation
import PathKit
import XCTest
@testable import XcodeProj

class Dictionary_PlistValueTests: XCTestCase {
    func test_dictionaryPlistValue_returnsTheCorrectValue() {
        let dictionary: [String: Any] = [
            "a": "b",
            "c": ["d", "e"],
            "f": [
                "g": "h",
            ],
        ]
        let plist = dictionary.plist()
        XCTAssertEqual(plist.dictionary?[CommentedString("a")], .string(CommentedString("b")))
        XCTAssertEqual(plist.dictionary?[CommentedString("c")], .array([.string(CommentedString("d")), .string(CommentedString("e"))]))
        XCTAssertEqual(plist.dictionary?[CommentedString("f")], .dictionary([CommentedString("g"): .string(CommentedString("h"))]))
    }
}

class Array_PlistValueTests: XCTestCase {
    func test_arrayPlistValue_returnsTheCorrectValue() {
        let array: [Any] = [
            "a",
            ["b", "c"],
            ["d": "e"],
        ]
        let plist = array.plist()
        XCTAssertEqual(plist.array?[0], .string(CommentedString("a")))
        XCTAssertEqual(plist.array?[1], .array([.string(CommentedString("b")), .string(CommentedString("c"))]))
        XCTAssertEqual(plist.array?[2], .dictionary([CommentedString("d"): .string(CommentedString("e"))]))
    }
}
