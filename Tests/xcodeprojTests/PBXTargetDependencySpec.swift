import Foundation
import XCTest

@testable import xcodeproj

final class PBXTargetDependencySpec: XCTestCase {
    
    var subject: PBXTargetDependency!
    
    override func setUp() {
        subject = PBXTargetDependency(reference: "reference",
                                      target: "target",
                                      targetProxy: "target_proxy")
    }
    
    func test_init_initializesTheTargetDependencyWithTheCorrectAttributes() {
        XCTAssertEqual(subject.reference, "reference")
        XCTAssertEqual(subject.target, "target")
        XCTAssertEqual(subject.targetProxy, "target_proxy")
    }
    
    func test_init_failsIfTheTargetIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "target")
        do {
            _ = try PBXTargetDependency(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsIfTheTargetProxyIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "targetProxy")
        do {
            _ = try PBXTargetDependency(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_hasTheCorrectIsa() {
        XCTAssertEqual(subject.isa, "PBXTargetDependency")
    }
    
    func test_equals_shouldReturnTheRightValue() {
        let one = PBXTargetDependency(reference: "reference", target: "target", targetProxy: "target_proxy")
        let another = PBXTargetDependency(reference: "reference", target: "target", targetProxy: "target_proxy")
        XCTAssertEqual(one, another)
    }
    
    func test_hashValue_returnsTheReferenceHashValue() {
        XCTAssertEqual(subject.hashValue, subject.reference.hashValue)
    }
    
    private func testDictionary() -> [String: Any] {
        return [
            "target": "target",
            "targetProxy": "targetProxy"
        ]
    }
}
