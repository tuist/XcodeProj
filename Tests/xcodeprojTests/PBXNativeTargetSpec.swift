import Foundation
import XCTest
import xcodeproj

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
    
    func test_init_failsWhenBuildConfigurationListIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildConfigurationList")
        do {
            _ = try PBXNativeTarget(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsWhenBuildPhasesIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildPhases")
        do {
            _ = try PBXNativeTarget(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsWhenBuildRulesIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildRules")
        do {
            _ = try PBXNativeTarget(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsWhenDependenciesIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "dependencies")
        do {
            _ = try PBXNativeTarget(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsWhenNameIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "name")
        do {
            _ = try PBXNativeTarget(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
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
            "name": "name"
        ]
    }

}
