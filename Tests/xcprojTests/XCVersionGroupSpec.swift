import Foundation
import XCTest

@testable import xcproj

extension XCVersionGroup {
    static func testData(reference: String = "reference",
                  currentVersion: String = "currentVersion",
                  path: String = "path",
                  name: String? = "name",
                  sourceTree: PBXSourceTree = .group,
                  versionGroupType: String = "versionGroupType",
                  children: [String] = ["child"]) -> XCVersionGroup {
        return XCVersionGroup(reference: reference,
                              currentVersion: currentVersion,
                              path: path,
                              name: name,
                              sourceTree: sourceTree,
                              versionGroupType: versionGroupType,
                              children: children)
    }
}

final class XCVersionGroupSpec: XCTestCase {

    func test_init_initializesThePropertiesProperly() {
        let subject = XCVersionGroup.testData()
        XCTAssertEqual(subject.reference, "reference")
        XCTAssertEqual(subject.currentVersion, "currentVersion")
        XCTAssertEqual(subject.path, "path")
        XCTAssertEqual(subject.name, "name")
        XCTAssertEqual(subject.sourceTree, .group)
        XCTAssertEqual(subject.versionGroupType, "versionGroupType")
        XCTAssertEqual(subject.children, ["child"])
    }

    func test_equals_returnTheCorrectValue_whenElementsAreTheSame() {
        let a = XCVersionGroup.testData()
        let b = XCVersionGroup.testData()
        XCTAssertEqual(a, b)
    }

    func test_equals_returnsTheCorrectValue_whenElementsAreNotTheSame() {
        let a = XCVersionGroup.testData()
        let b = XCVersionGroup.testData(reference: "333")
        XCTAssertNotEqual(a, b)
    }

    func test_initFails_whenCurrentVersionIsMissing() {
        var dictionary = testData()
        dictionary.removeValue(forKey: "currentVersion")
        do {
            _ = try XCVersionGroup(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to fail but tt didn't")
        } catch {}
    }

    func test_initFails_whenPathIsMissing() {
        var dictionary = testData()
        dictionary.removeValue(forKey: "path")
        do {
            _ = try XCVersionGroup(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to fail but tt didn't")
        } catch {}
    }

    func test_initFails_whenSourceTreeIsMissing() {
        var dictionary = testData()
        dictionary.removeValue(forKey: "sourceTree")
        do {
            _ = try XCVersionGroup(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to fail but tt didn't")
        } catch {}
    }

    func test_initFails_whenVersionGroupTypeIsMissing() {
        var dictionary = testData()
        dictionary.removeValue(forKey: "versionGroupType")
        do {
            _ = try XCVersionGroup(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to fail but tt didn't")
        } catch {}
    }

    // MARK: - Private

    private func testData() -> [String: Any] {
        return [
            "currentVersion": "currentVersion",
            "path": "path",
            "name": "name",
            "sourceTree": "<group>",
            "versionGroupType": "versionGroupType",
            "children": ["child"]
        ]
    }
}
