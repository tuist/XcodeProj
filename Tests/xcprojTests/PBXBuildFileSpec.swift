import Foundation
import XCTest
import xcproj

final class PBXBuildFileSpec: XCTestCase {

    var subject: PBXBuildFile!

    override func setUp() {
        super.setUp()
        subject = PBXBuildFile(fileRef: "fileref",
                               settings: ["a": "b"])
    }

    func test_init_initializesTheBuildFileWithTheRightAttributes() {
        XCTAssertEqual(subject.fileRef, "fileref")
        XCTAssertEqual(subject.settings as! [String: String], ["a": "b"])
    }
    
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXBuildFile.isa, "PBXBuildFile")
    }

    func test_equal_shouldReturnTheCorrectValue() {
        let another = PBXBuildFile(fileRef: "fileref",
                                   settings: ["a": "b"])
        XCTAssertEqual(subject, another)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "fileRef": "fileRef",
            "settings": ["a": "b"]
        ]
    }
}
