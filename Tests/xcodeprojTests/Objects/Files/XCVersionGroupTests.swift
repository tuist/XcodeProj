import Foundation
@testable import xcodeproj
import XCTest

extension XCVersionGroup {
    static func testData(objects: PBXObjects,
                         currentVersion: PBXFileReference? = PBXFileReference(name: "currentVersion"),
                         path: String = "path",
                         name: String? = "name",
                         sourceTree: PBXSourceTree = .group,
                         versionGroupType: String = "versionGroupType",
                         children: [PBXFileReference] = [PBXFileReference(name: "currentVersion")]) -> XCVersionGroup {
        let group = XCVersionGroup(currentVersion: currentVersion,
                                   path: path,
                                   name: name,
                                   sourceTree: sourceTree,
                                   versionGroupType: versionGroupType,
                                   children: children)
        if let currentVersion = currentVersion {
            objects.addObject(currentVersion)
        }
        children.forEach({ objects.addObject($0) })
        objects.addObject(group)
        return group
    }
}

final class XCVersionGroupTests: XCTestCase {
    func test_equals_returnTheCorrectValue_whenElementsAreTheSame() {
        let objects = PBXObjects()
        let currentVersion = PBXFileReference(name: "currentVersion")
        let children = [PBXFileReference(name: "currentVersion")]
        let a = XCVersionGroup.testData(objects: objects, currentVersion: currentVersion, children: children)
        let b = XCVersionGroup.testData(objects: objects, currentVersion: currentVersion, children: children)
        XCTAssertEqual(a, b)
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
            "reference": "reference",
        ]
    }
}
