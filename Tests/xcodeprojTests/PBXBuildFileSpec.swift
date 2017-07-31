import Foundation
import XCTest
import xcodeproj

final class PBXBuildFileSpec: XCTestCase {
    
    var subject: PBXBuildFile!
    
    override func setUp() {
        super.setUp()
        subject = PBXBuildFile(reference: "ref",
                               fileRef: "fileref",
                               settings: ["a": "b"])
    }
    
    func test_init_initializesTheBuildFileWithTheRightAttributes() {
        XCTAssertEqual(subject.reference, "ref")
        XCTAssertEqual(subject.fileRef, "fileref")
        XCTAssertEqual(subject.settings as! [String: String], ["a": "b"])
    }
    
    func test_initFails_ifFileRefIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "fileRef")
        do {
            _ = try PBXBuildFile(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXBuildFile.isa, "PBXBuildFile")
    }
    
    func test_hashValue_returnsTheReferenceHashValue() {
        XCTAssertEqual(subject.hashValue, subject.reference.hashValue)
    }
    
    func test_equal_shouldReturnTheCorrectValue() {
        let another = PBXBuildFile(reference: "ref",
                                   fileRef: "fileref",
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
