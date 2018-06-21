import Foundation
@testable import xcodeproj
import XCTest

extension XCVersionGroup {
    static func testData(currentVersion: PBXObjectReference = PBXObjectReference("currentVersion"),
                         path: String = "path",
                         name: String? = "name",
                         sourceTree: PBXSourceTree = .group,
                         versionGroupType: String = "versionGroupType",
                         children: [PBXObjectReference] = [PBXObjectReference("child")]) -> XCVersionGroup {
        return XCVersionGroup(currentVersion: currentVersion,
                              path: path,
                              name: name,
                              sourceTree: sourceTree,
                              versionGroupType: versionGroupType,
                              childrenReferences: children)
    }
}

final class XCVersionGroupSpec: XCTestCase {
    func test_equals_returnTheCorrectValue_whenElementsAreTheSame() {
        let a = XCVersionGroup.testData()
        let b = XCVersionGroup.testData()
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
