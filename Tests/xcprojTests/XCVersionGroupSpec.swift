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

    func test_setsTheCorrectDefaultValue_whenCurrentVersionIsMissing() throws {
        var dictionary = testData()
        dictionary.removeValue(forKey: "currentVersion")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(XCVersionGroup.self, from: data)
        XCTAssertEqual(subject.currentVersion, "")
    }

    func test_setsTheCorrectDefaultValue_whenPathIsMissing() throws {
        var dictionary = testData()
        dictionary.removeValue(forKey: "path")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(XCVersionGroup.self, from: data)
        XCTAssertEqual(subject.path, "")
    }

    func test_setsTheCorrectDefaultValue_whenSourceTreeIsMissing() throws {
        var dictionary = testData()
        dictionary.removeValue(forKey: "sourceTree")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(XCVersionGroup.self, from: data)
        XCTAssertEqual(subject.sourceTree, .none)
    }
    
    func test_setsTheCorrectDefaultValue_whenVersionGroupTypeIsMissing() throws {
        var dictionary = testData()
        dictionary.removeValue(forKey: "versionGroupType")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(XCVersionGroup.self, from: data)
        XCTAssertEqual(subject.versionGroupType, "")
    }

    // MARK: - Private

    private func testData() -> [String: Any] {
        return [
            "currentVersion": "currentVersion",
            "path": "path",
            "name": "name",
            "sourceTree": "<group>",
            "versionGroupType": "versionGroupType",
            "children": ["child"],
            "reference": "reference"
        ]
    }
}
