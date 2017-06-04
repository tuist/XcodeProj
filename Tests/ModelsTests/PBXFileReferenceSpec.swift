import Foundation
import XCTest

@testable import Models

final class PBXFileReferenceSpec: XCTestCase {
    
    var subject: PBXFileReference!
    
    override func setUp() {
        super.setUp()
        subject = PBXFileReference(reference: "ref",
                                   sourceTree: .absolute,
                                   name: "name",
                                   fileEncoding: 1,
                                   explicitFileType: "type",
                                   lastKnownFileType: "last",
                                   path: "path")
    }
    
    func test_init_initializesTheReferenceWithTheRightAttributes() {
        XCTAssertEqual(subject.reference, "ref")
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
    
    func test_init_failsIfNameIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "name")
        do {
            _ = try PBXFileReference(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsIfSourceTreeIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "sourceTree")
        do {
            _ = try PBXFileReference(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_equal_returnsTheCorrectValue() {
        let another = PBXFileReference(reference: "ref",
                                       sourceTree: .absolute,
                                       name: "name",
                                       fileEncoding: 1,
                                       explicitFileType: "type",
                                       lastKnownFileType: "last",
                                       path: "path")
        XCTAssertEqual(subject, another)
    }
    
    func test_hashValue_returnsTheCorrectValue() {
        XCTAssertEqual(subject.hashValue, subject.reference.hashValue)
    }
    
    private func testDictionary() -> [String: Any] {
        return [
            "name": "name",
            "sourceTree": "group"
        ]
    }
}
