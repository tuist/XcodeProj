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
        let pbxProject = PBXProject(name: "ProjectName",
                                    buildConfigurationList: XCConfigurationList(),
                                    compatibilityVersion: "0",
                                    mainGroup: group)
        project.add(object: pbxProject)

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

        XCTAssertNotNil(childGroup?.parent)
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

    func test_addNotExistingFileWithoutValidatinPresence_throws() {
        do {
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

            // ensure it doesnt exist
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath.string) {
                try FileManager.default.removeItem(atPath: filePath.string)
            }
            try group.addFile(at: filePath, sourceRoot: sourceRoot)
            XCTFail("Should throw XcodeprojEditingError.unexistingFile")
        } catch XcodeprojEditingError.unexistingFile {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Should throw XcodeprojEditingError.unexistingFile but throws \(error)")
        }
    }

    func test_addNotExistingFileValidatinPresence_assignsParent() throws {
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
        let pbxProject = PBXProject(name: "ProjectName",
                                    buildConfigurationList: XCConfigurationList(),
                                    compatibilityVersion: "0",
                                    mainGroup: group)
        project.add(object: pbxProject)

        let filePath = try Path.uniqueTemporary() + "file"

        // ensure it doesnt exist
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath.string) {
            try FileManager.default.removeItem(atPath: filePath.string)
        }
        let file = try? group.addFile(at: filePath, sourceRoot: sourceRoot, validatePresence: false)
        XCTAssertNotNil(file?.parent)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "children": ["child"],
            "name": "name",
            "sourceTree": "absolute",
        ]
    }
}
