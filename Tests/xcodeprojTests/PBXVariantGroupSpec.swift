import Foundation
import XCTest

@testable import xcodeproj

final class PBXVariantGroupSpec: XCTestCase {
    
    var subject: PBXVariantGroup!
    
    override func setUp() {
        super.setUp()
        self.subject = PBXVariantGroup(reference: "reference",
                                       children: ["child"],
                                       name: "name",
                                       sourceTree: .group)
    }
    
    func test_init_initializesTheModelWithTheCorrectAttributes() {
        XCTAssertEqual(subject.reference, "reference")
        XCTAssertEqual(subject.children, ["child"])
        XCTAssertEqual(subject.name, "name")
        XCTAssertEqual(subject.sourceTree, .group)
    }
    
    func test_init_failsIfTheChildrenIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "children")
        do {
            _ = try PBXVariantGroup(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsIfTheNameIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "name")
        do {
            _ = try PBXVariantGroup(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsIfTheSourceTreeIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "sourceTree")
        do {
            _ = try PBXVariantGroup(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsIfTheSourceTreeIsWrong() {
        var dictionary = testDictionary()
        dictionary["sourceTree"] = "asdgasdgas"
        do {
            _ = try PBXVariantGroup(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_itHasTheCorrectIsa() {
        XCTAssertEqual(subject.isa, "PBXVariantGroup")
    }
    
    func test_addingChild_returnsAVariantGroupWithTheChildAdded() {
        let newVariant = subject.adding(child: "444")
        XCTAssertTrue(newVariant.children.contains("444"))
    }
    
    func test_removingChild_returnsAVariantGroupWithTheChildRemoved() {
        let newVariant = subject.removing(child: "child")
        XCTAssertFalse(newVariant.children.contains("child"))
    }
    
    private func testDictionary() -> [String: Any] {
        return [
            "children": ["child1", "child2"],
            "name": "name",
            "sourceTree": "SDKROOT"
        ]
    }
    
}
