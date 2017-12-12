import Foundation
import XCTest
import xcproj

final class PBXAggregateTargetSpec: XCTestCase {

    var subject: PBXAggregateTarget!

    override func setUp() {
        super.setUp()
        subject = PBXAggregateTarget(name: "name",
                                     buildConfigurationList: "333",
                                     buildPhases: ["build"],
                                     buildRules: ["rule"],
                                     dependencies: ["dep"],
                                     productName: "productName",
                                     productReference: "productReference",
                                     productType: .application)
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXAggregateTarget.isa, "PBXAggregateTarget")
    }

    func test_init_initializesWithTheCorrectValues() {
        XCTAssertEqual(subject.buildConfigurationList, "333")
        XCTAssertEqual(subject.buildPhases, ["build"])
        XCTAssertEqual(subject.buildRules, ["rule"])
        XCTAssertEqual(subject.dependencies, ["dep"])
        XCTAssertEqual(subject.name, "name")
        XCTAssertEqual(subject.productName, "productName")
        XCTAssertEqual(subject.productReference, "productReference")
        XCTAssertEqual(subject.productType, .application)
    }

    func test_init_failsWhenNameIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "name")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXAggregateTarget.self, from: data)
            XCTAssertTrue(false, "It should throw an error but it didn't")
        } catch {}
    }

    func test_equal_returnsTheCorrectValue() {
        let another = PBXAggregateTarget(name: "name",
                                         buildConfigurationList: "333",
                                         buildPhases: ["build"],
                                         buildRules: ["rule"],
                                         dependencies: ["dep"],
                                         productName: "productName",
                                         productReference: "productReference",
                                         productType: .application)
        XCTAssertEqual(subject, another)
    }

    func testDictionary() -> [String: Any] {
        return [
            "buildConfigurationList": "buildConfigurationList",
            "buildPhases": ["phase"],
            "buildRules": ["rule"],
            "dependencies": ["dep"],
            "name": "name"
        ]
    }
}
