import Foundation
import XCTest
@testable import XcodeProj

final class PBXAggregateTargetTests: XCTestCase {
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXAggregateTarget.isa, "PBXAggregateTarget")
    }

    func test_init_failsWhenNameIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "name")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = XcodeprojJSONDecoder()
        do {
            _ = try decoder.decode(PBXAggregateTarget.self, from: data)
            XCTAssertTrue(false, "It should throw an error but it didn't")
        } catch {}
    }

    func testDictionary() -> [String: Any] {
        [
            "buildConfigurationList": "buildConfigurationList",
            "buildPhases": ["phase"],
            "buildRules": ["rule"],
            "dependencies": ["dep"],
            "name": "name",
        ]
    }
}
