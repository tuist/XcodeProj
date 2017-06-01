import Foundation
import XCTest

@testable import xcodeproj

final class PBXGroupSpec: XCTestCase {
    
    var subject: PBXGroup!
    
    override func setUp() {
        super.setUp()
        self.subject = PBXGroup(reference: "ref",
                                children: Set(arrayLiteral: "333"),
                                sourceTree: .group,
                                name: "name")
    }
    
    func test_init_initializesTheGroupWithTheRightProperties() {
        XCTAssertEqual(subject.reference, "ref")
        XCTAssertEqual(subject.children, Set(arrayLiteral: "333"))
        XCTAssertEqual(subject.sourceTree, .group)
        XCTAssertEqual(subject.name, "name")
    }
    
    func test_init_failsIfChildrenIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "children")
        do {
            _ = try PBXGroup(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsIfSourceTreeIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "sourceTree")
        do {
            _ = try PBXGroup(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(subject.isa, "PBXGroup")
    }
    
    func test_equals_returnsTheCorretValue() {
        let another = PBXGroup(reference: "ref",
                               children: Set(arrayLiteral: "333"),
                               sourceTree: .group,
                               name: "name")
        XCTAssertEqual(subject, another)
    }

    func test_addingChild_returnsANewGroupWithTheFileAdded() {
        let got = subject.adding(child: "444")
        XCTAssertTrue(got.children.contains("444"))
    }
    
    func test_removingChild_returnsANewGroupWithTheFileRemoved() {
        let got = subject.removing(child: "333")
        XCTAssertFalse(got.children.contains("333"))
    }
    
    func test_hashValue_returnsTheReferenceHashValue() {
        XCTAssertEqual(subject.hashValue, subject.reference.hashValue)
    }
    
    private func testDictionary() -> [String: Any] {
        return [
            "children": ["child"],
            "name": "name",
            "sourceTree": "absolute"
        ]
    }
}
