import Foundation
import PathKit
import Shell
import XcodeProj
import XCTest

final class PBXGroupTests: XCTestCase {
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXGroup.isa, "PBXGroup")
    }

    func test_addFile_assignParent() throws {
        let sourceRoot = Path("/")
        let project = PBXProj(
            rootObject: nil,
            objectVersion: 0,
            archiveVersion: 0,
            classes: [:],
            objects: []
        )
        let group = PBXGroup(children: [],
                             sourceTree: .group,
                             name: "group")
        project.add(object: group)
        let filePath = try Path.uniqueTemporary() + "file"
        try Data().write(to: filePath.url)
        let file = try? group.addFile(at: filePath, sourceRoot: sourceRoot)
        XCTAssertNotNil(file?.parent)
    }

    func test_addGroup_assignParent() {
        let project = PBXProj(
            rootObject: nil,
            objectVersion: 0,
            archiveVersion: 0,
            classes: [:],
            objects: []
        )
        let group = PBXGroup(children: [],
                             sourceTree: .group,
                             name: "group")
        project.add(object: group)

        let childGroup = try? group.addGroup(named: "child_group").first

        XCTAssertNotNil(childGroup??.parent)
    }

    func test_createGroupWithFile_assignParent() {
        let fileref = PBXFileReference(sourceTree: .group,
                                       fileEncoding: 1,
                                       explicitFileType: "sourcecode.swift",
                                       lastKnownFileType: nil,
                                       path: "/a/path")

        let group = PBXGroup(children: [fileref],
                             sourceTree: .group,
                             name: "group")

        XCTAssertNotNil(group.children.first?.parent)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "children": ["child"],
            "name": "name",
            "sourceTree": "absolute",
        ]
    }
}
