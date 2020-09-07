import Foundation
import XCTest
@testable import XcodeProj

final class PBXNativeTargetTests: XCTestCase {
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXNativeTarget.isa, "PBXNativeTarget")
    }

    func test_init_failsWhenNameIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "name")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = XcodeprojJSONDecoder()
        do {
            _ = try decoder.decode(PBXNativeTarget.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    private func testDictionary() -> [String: Any] {
        [
            "buildConfigurationList": "test",
            "buildPhases": ["phase"],
            "buildRules": ["rule"],
            "dependencies": ["dependency"],
            "name": "name",
            "productInstallPath": "/usr/local/bin",
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
        let target = PBXNativeTarget(name: "Target", buildConfigurationList: nil)
        let dependency = PBXNativeTarget(name: "Dependency", buildConfigurationList: nil)
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
