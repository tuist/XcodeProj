import Foundation
import XCTest
import xcodeproj

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
    
    func test_init_failsWhenTheBuildConfigurationListIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildConfigurationList")
        do {
            _ = try PBXAggregateTarget(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "It should throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsWhenBuildPhasesIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildPhases")
        do {
            _ = try PBXAggregateTarget(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "It should throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsWhenBuildRulesIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildRules")
        do {
            _ = try PBXAggregateTarget(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "It should throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsWhenDependenciesIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "dependencies")
        do {
            _ = try PBXAggregateTarget(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "It should throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsWhenNameIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "name")
        do {
            _ = try PBXAggregateTarget(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "It should throw an error but it didn't")
        } catch {}
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
            "name": "name"
        ]
    }
}
