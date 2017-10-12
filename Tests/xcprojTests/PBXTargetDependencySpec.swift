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
