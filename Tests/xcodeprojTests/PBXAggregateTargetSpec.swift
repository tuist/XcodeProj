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
    
    func test_addingBuildPhase_addsTheBuildPhaseToTheReturnedObject() {
        let got = subject.adding(buildPhase: "abcd")
        XCTAssertTrue(got.buildPhases.contains("abcd"))
    }
    
    func test_removingBuildPhase_removesTheBuildPhaseFromTheReturnedObject() {
        let got = subject.removing(buildPhase: "build")
        XCTAssertFalse(got.buildPhases.contains("build"))
    }
    
    func test_withBuildPhases_returnsATargetWithTheGivenBuildPhases() {
        let got = subject.with(buildPhases: ["a", "b"])
        XCTAssertEqual(got.buildPhases, ["a", "b"])
    }
    
    func test_addingBuildRule_addsTheBuildRuleToTheReturnedObject() {
        let got = subject.adding(buildRule: "uuu")
        XCTAssertTrue(got.buildRules.contains("uuu"))
    }
    
    func test_removingBuildRule_removesTheBuildRuleFromTheRegurnedObject() {
        let got = subject.removing(buildRule: "rule")
        XCTAssertFalse(got.buildRules.contains("rule"))
    }
    
    func test_withBuildRules_returnsATargetWithTheGivenRules() {
        let got = subject.with(buildRules: ["ruleA", "ruleB"])
        XCTAssertEqual(got.buildRules, ["ruleA", "ruleB"])
    }
    
    func test_addingDependency_returnsATargetWithTheDependencyAdded() {
        let got = subject.adding(dependency: "deppp")
        XCTAssertTrue(got.dependencies.contains("deppp"))
    }
    
    func test_removingDependency_returnsATargetWithTheDependencyRemoved() {
        let got = subject.removing(dependency: "dep")
        XCTAssertFalse(got.dependencies.contains("dep"))
    }
    
    func test_withDependencies_returnsATargetWithTheDependencies() {
        let got = subject.with(dependencies: ["a"])
        XCTAssertEqual(got.dependencies, ["a"])
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
