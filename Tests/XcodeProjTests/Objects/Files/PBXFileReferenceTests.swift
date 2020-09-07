import Foundation
import XcodeProj
import XCTest

final class PBXFileReferenceTests: XCTestCase {
    var subject: PBXFileReference!

    override func setUp() {
        super.setUp()
        subject = PBXFileReference(sourceTree: .absolute,
                                   name: "name",
                                   fileEncoding: 1,
                                   explicitFileType: "type",
                                   lastKnownFileType: "last",
                                   path: "path")
    }

    func test_init_initializesTheReferenceWithTheRightAttributes() {
        XCTAssertEqual(subject.name, "name")
        XCTAssertEqual(subject.sourceTree, .absolute)
        XCTAssertEqual(subject.fileEncoding, 1)
        XCTAssertEqual(subject.explicitFileType, "type")
        XCTAssertEqual(subject.lastKnownFileType, "last")
        XCTAssertEqual(subject.path, "path")
    }

    func test_isa_hashTheCorrectValue() {
        XCTAssertEqual(PBXFileReference.isa, "PBXFileReference")
    }

    func test_equal_returnsTheCorrectValue() {
        let another = PBXFileReference(sourceTree: .absolute,
                                       name: "name",
                                       fileEncoding: 1,
                                       explicitFileType: "type",
                                       lastKnownFileType: "last",
                                       path: "path")
        XCTAssertEqual(subject, another)
    }

    private func testDictionary() -> [String: Any] {
        [
            "name": "name",
            "sourceTree": "group",
        ]
    }
}
