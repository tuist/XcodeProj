import Foundation
import XCTest

@testable import xcodeproj

class PBXProjWriterSpecs: XCTestCase {
    
    
    func test_dictionaryPBXProjPlistValue_returnsTheCorrectValue() {
        let dictionary: [String: Any] = [
            "a": "b",
            "c": ["d", "e"],
            "f": [
                "g": "h"
            ]
        ]
        let plist = dictionary.pbxProjPlistValue()
        XCTAssertEqual(plist.dictionary?[PBXProjPlistCommentedString("a")], .string(PBXProjPlistCommentedString("b")))
        XCTAssertEqual(plist.dictionary?[PBXProjPlistCommentedString("c")], .array([.string(PBXProjPlistCommentedString("d")), .string(PBXProjPlistCommentedString("e"))]))
        XCTAssertEqual(plist.dictionary?[PBXProjPlistCommentedString("f")], .dictionary([PBXProjPlistCommentedString("g"): .string(PBXProjPlistCommentedString("h"))]))
    }
    
    func test_arrayPBXProjPlistValue_returnsTheCorrectValue() {
        let array: [Any] = [
            "a",
            ["b", "c"],
            ["d": "e"]
        ]
        let plist = array.pbxProjPlistValue()
        XCTAssertEqual(plist.array?[0], .string(PBXProjPlistCommentedString("a")))
        XCTAssertEqual(plist.array?[1], .array([.string(PBXProjPlistCommentedString("b")), .string(PBXProjPlistCommentedString("c"))]))
        XCTAssertEqual(plist.array?[2], .dictionary([PBXProjPlistCommentedString("d"): .string(PBXProjPlistCommentedString("e"))]))
    }
    
    
}
