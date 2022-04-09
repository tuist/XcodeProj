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

    func test_addDependency() throws {
        let objects = PBXObjects(objects: [])

        let configurationList = XCConfigurationList.fixture()
        let mainGroup = PBXGroup.fixture()
        objects.add(object: configurationList)
        objects.add(object: mainGroup)

        let project = PBXProject(name: "Project",
                                 buildConfigurationList: configurationList,
                                 compatibilityVersion: "0",
                                 mainGroup: mainGroup)

        objects.add(object: project)
        let target = PBXAggregateTarget(name: "Target", buildConfigurationList: nil)
        let dependency = PBXAggregateTarget(name: "Dependency", buildConfigurationList: nil)
        objects.add(object: target)
        objects.add(object: dependency)
        _ = try target.addDependency(target: dependency)
        let targetDependency: PBXTargetDependency? = target.dependencyReferences.first?.getObject()

        XCTAssertEqual(targetDependency?.name, "Dependency")
        XCTAssertEqual(targetDependency?.targetReference, dependency.reference)
        let containerItemProxy: PBXContainerItemProxy? = targetDependency?.targetProxyReference?.getObject()
        XCTAssertEqual(containerItemProxy?.containerPortalReference, project.reference)
        XCTAssertEqual(containerItemProxy?.remoteGlobalID?.uuid, dependency.reference.value)
        XCTAssertEqual(containerItemProxy?.proxyType, .nativeTarget)
        XCTAssertEqual(containerItemProxy?.remoteInfo, "Dependency")
    }
}
