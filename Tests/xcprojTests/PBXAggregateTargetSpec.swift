import Foundation
import XCTest
import xcproj

final class PBXAggregateTargetSpec: XCTestCase {

    var subject: PBXAggregateTarget!

    override func setUp() {
        super.setUp()
        subject = PBXAggregateTarget(reference: "ref",
                                     buildConfigurationList: "333",
                                     buildPhases: ["build"],
                                     buildRules: ["rule"],
                                     dependencies: ["dep"],
                                     name: "name",
                                     productName: "productName",
                                     productReference: "productReference",
                                     productType: .application)
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXAggregateTarget.isa, "PBXAggregateTarget")
    }

    func test_init_initializesWithTheCorrectValues() {
        XCTAssertEqual(subject.reference, "ref")
        XCTAssertEqual(subject.buildConfigurationList, "333")
        XCTAssertEqual(subject.buildPhases, ["build"])
        XCTAssertEqual(subject.buildRules, ["rule"])
        XCTAssertEqual(subject.dependencies, ["dep"])
        XCTAssertEqual(subject.name, "name")
        XCTAssertEqual(subject.productName, "productName")
        XCTAssertEqual(subject.productReference, "productReference")
        XCTAssertEqual(subject.productType, .application)
    }

    func test_init_setsTheCorrectDefaultValue_whenBuildConfigurationListIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildConfigurationList")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXAggregateTarget.self, from: data)
        XCTAssertEqual(subject.buildConfigurationList, "")
    }
    
    func test_init_setsTheCorrectDefaultValue_whenBuildPhasesIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildPhases")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXAggregateTarget.self, from: data)
        XCTAssertTrue(subject.buildPhases.isEmpty)
    }
    
    func test_init_setsTheCorrectDefaultValue_whenBuildRulesMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildRules")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXAggregateTarget.self, from: data)
        XCTAssertTrue(subject.buildRules.isEmpty)
    }

    func test_init_setsTheCorrectDefaultValue_whenDependenciesIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "dependencies")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXAggregateTarget.self, from: data)
        XCTAssertTrue(subject.dependencies.isEmpty)
    }
    
    func test_init_setsTheCorrectDefaultValue_whenNameIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "name")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXAggregateTarget.self, from: data)
        XCTAssertEqual(subject.name, "")
    }

    func test_equal_returnsTheCorrectValue() {
        let another = PBXAggregateTarget(reference: "ref",
                                         buildConfigurationList: "333",
                                         buildPhases: ["build"],
                                         buildRules: ["rule"],
                                         dependencies: ["dep"],
                                         name: "name",
                                         productName: "productName",
                                         productReference: "productReference",
                                         productType: .application)
        XCTAssertEqual(subject, another)
    }

    func test_hashValue_returnsTheReferenceHashValue() {
        XCTAssertEqual(subject.hashValue, subject.reference.hashValue)
    }

    func testDictionary() -> [String: Any] {
        return [
            "buildConfigurationList": "buildConfigurationList",
            "buildPhases": ["phase"],
            "buildRules": ["rule"],
            "dependencies": ["dep"],
            "name": "name",
            "reference": "reference"
        ]
    }
}
