import Foundation
import XCTest
import xcproj

final class PBXNativeTargetSpec: XCTestCase {

    var subject: PBXNativeTarget!

    override func setUp() {
        super.setUp()
        subject = PBXNativeTarget(reference: "ref",
                                  buildConfigurationList: "list",
                                  buildPhases: ["phase"],
                                  buildRules: ["rule"],
                                  dependencies: ["dependency"],
                                  name: "name",
                                  productName: "productname",
                                  productReference: "productreference",
                                  productType: .application)
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXNativeTarget.isa, "PBXNativeTarget")
    }

    func test_init_initializesTheElementWithTheRightAttributes() {
        XCTAssertEqual(subject.reference, "ref")
        XCTAssertEqual(subject.buildConfigurationList, "list")
        XCTAssertEqual(subject.buildPhases, ["phase"])
        XCTAssertEqual(subject.buildRules, ["rule"])
        XCTAssertEqual(subject.dependencies, ["dependency"])
        XCTAssertEqual(subject.name, "name")
        XCTAssertEqual(subject.productName, "productname")
        XCTAssertEqual(subject.productReference, "productreference")
        XCTAssertEqual(subject.productType, .application)
    }

    func test_init_setsTheCorrectDefaultValue_whenBuildConfigurationListIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildConfigurationList")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXNativeTarget.self, from: data)
        XCTAssertEqual(subject.buildConfigurationList, "")
    }

    func test_init_setsTheCorrectDefaultValue_whenBuildPhasesIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildPhases")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXNativeTarget.self, from: data)
        XCTAssertEqual(subject.buildPhases, [])
    }

    func test_init_setsTheCorrectDefaultValue_whenBuildRulesIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildRules")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXNativeTarget.self, from: data)
        XCTAssertEqual(subject.buildRules, [])
    }

    func test_init_setsTheCorrectDefaultValue_whenDependenciesIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "dependencies")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXNativeTarget.self, from: data)
        XCTAssertEqual(subject.dependencies, [])
    }

    func test_init_setsTheCorrectDefaultValue_whenNameIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "name")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXNativeTarget.self, from: data)
        XCTAssertEqual(subject.name, "")
    }

    func test_equal_returnsTheCorrectValue() {
        let another = PBXNativeTarget(reference: "ref",
                                      buildConfigurationList: "list",
                                      buildPhases: ["phase"],
                                      buildRules: ["rule"],
                                      dependencies: ["dependency"],
                                      name: "name",
                                      productName: "productname",
                                      productReference: "productreference",
                                      productType: .application)
        XCTAssertEqual(subject, another)
    }

    func test_hashValue_returnsTheReferenceHashValue() {
        XCTAssertEqual(subject.hashValue, subject.reference.hashValue)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "buildConfigurationList": "test",
            "buildPhases": ["phase"],
            "buildRules": ["rule"],
            "dependencies": ["dependency"],
            "name": "name",
            "reference": "reference"
        ]
    }

}
