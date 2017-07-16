import Foundation
import XCTest
import xcodeprojextensions

@testable import xcodeproj

class PBXProjWriterSpecs: XCTestCase {
    
    func test_dictionaryPlistValue_returnsTheCorrectValue() {
        let dictionary: [String: Any] = [
            "a": "b",
            "c": ["d", "e"],
            "f": [
                "g": "h"
            ]
        ]
        let plist = dictionary.plist()
        XCTAssertEqual(plist.dictionary?[CommentedString("a")], .string(CommentedString("b".quoted)))
        XCTAssertEqual(plist.dictionary?[CommentedString("c")], .array([.string(CommentedString("d".quoted)), .string(CommentedString("e".quoted))]))
        XCTAssertEqual(plist.dictionary?[CommentedString("f")], .dictionary([CommentedString("g"): .string(CommentedString("h".quoted))]))
    }
    
    func test_arrayPlistValue_returnsTheCorrectValue() {
        let array: [Any] = [
            "a",
            ["b", "c"],
            ["d": "e"]
        ]
        let plist = array.plist()
        XCTAssertEqual(plist.array?[0], .string(CommentedString("a".quoted)))
        XCTAssertEqual(plist.array?[1], .array([.string(CommentedString("b".quoted)), .string(CommentedString("c".quoted))]))
        XCTAssertEqual(plist.array?[2], .dictionary([CommentedString("d"): .string(CommentedString("e".quoted))]))
    }
    
    
}
