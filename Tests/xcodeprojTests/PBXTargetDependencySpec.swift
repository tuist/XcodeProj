import Foundation
import XCTest
import xcodeproj

final class PBXTargetDependencySpec: XCTestCase {

    var subject: PBXTargetDependency!

    override func setUp() {
        subject = PBXTargetDependency(name: "name",
                                      target: "target",
                                      targetProxy: "target_proxy")
    }

    func test_init_initializesTheTargetDependencyWithTheCorrectAttributes() {
        XCTAssertEqual(subject.name, "name")
        XCTAssertEqual(subject.target, "target")
        XCTAssertEqual(subject.targetProxy, "target_proxy")
    }

    func test_hasTheCorrectIsa() {
        XCTAssertEqual(PBXTargetDependency.isa, "PBXTargetDependency")
    }

    func test_equals_shouldReturnTheRightValue() {
        let one = PBXTargetDependency(name: "name", target: "target", targetProxy: "target_proxy")
        let another = PBXTargetDependency(name: "name", target: "target", targetProxy: "target_proxy")
        XCTAssertEqual(one, another)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "name": "name",
            "target": "target",
            "targetProxy": "targetProxy",
            "reference": "reference"
        ]
    }
}
