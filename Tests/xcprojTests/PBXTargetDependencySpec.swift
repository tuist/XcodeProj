import Foundation
import XCTest
import xcproj

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

    func test_init_setsTheCorrectDefaultValue_whenTargetIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "target")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXTargetDependency.self, from: data)
        XCTAssertEqual(subject.target, "")
    }

    func test_init_setsTheCorrectDefaultValue_whenTargetProxyIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "targetProxy")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXTargetDependency.self, from: data)
        XCTAssertEqual(subject.targetProxy, "")
    }

    func test_hasTheCorrectIsa() {
        XCTAssertEqual(PBXTargetDependency.isa, "PBXTargetDependency")
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
            "targetProxy": "targetProxy",
            "reference": "reference"
        ]
    }
}
