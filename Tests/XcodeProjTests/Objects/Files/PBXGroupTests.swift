import Foundation
import PathKit
import XcodeProj
import XCTest

final class PBXGroupTests: XCTestCase {
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXGroup.isa, "PBXGroup")
    }

    func test_addFile_assignParent() throws {
        let sourceRoot = Path("/")
        let project = makeEmptyPBXProj()
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
        let project = makeEmptyPBXProj()
        let group = PBXGroup(children: [],
                             sourceTree: .group,
                             name: "group")
        project.add(object: group)

        let childGroup = try? group.addGroup(named: "child_group").first

        XCTAssertNotNil(childGroup?.parent)
    }

    func test_addVariantGroup() {
        let project = makeEmptyPBXProj()
        let group = PBXGroup(children: [],
                             sourceTree: .group,
                             name: "group")

        project.add(object: group)

        let expectedGroupNames = ["child", "variant", "group"]

        guard let childVariantGroups = try? group.addVariantGroup(named: expectedGroupNames.joined(separator: "/")) else {
            return XCTFail("Failed to create variant groups")
        }

        XCTAssertEqual(childVariantGroups.count, expectedGroupNames.count)

        childVariantGroups.enumerated().forEach { index, variantGroup in
            let parentGroup = (index == 0) ? group : childVariantGroups[index - 1]

            if index == childVariantGroups.count - 1 {
                XCTAssertTrue(variantGroup.children.isEmpty)
            } else {
                XCTAssertEqual(variantGroup.children.count, 1)
                XCTAssertEqual(variantGroup.children.first?.name, expectedGroupNames[index + 1])
            }

            XCTAssertEqual(variantGroup.sourceTree, PBXSourceTree.group)
            XCTAssertEqual(variantGroup.name, expectedGroupNames[index])

            XCTAssertEqual(variantGroup.parent, group)
            XCTAssertTrue(parentGroup.children.contains(variantGroup))
        }

        XCTAssertEqual(group.children.first?.name, expectedGroupNames.first)
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
            let project = makeEmptyPBXProj()
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
        let project = makeEmptyPBXProj()
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

    func test_addFileWithSDKRootSourceTreePath_pathIsTheSameAsAdded() throws {
        let sourceRoot = Path("/")
        let project = makeEmptyPBXProj()
        let group = PBXGroup(children: [],
                             sourceTree: .group,
                             name: "group")
        project.add(object: group)
        let pbxProject = PBXProject(name: "ProjectName",
                                    buildConfigurationList: XCConfigurationList(),
                                    compatibilityVersion: "0",
                                    mainGroup: group)
        project.add(object: pbxProject)

        let filePath = Path("usr/lib/libresolv.9.tbd")
        let file = try? group.addFile(at: filePath,
                                      sourceTree: .sdkRoot,
                                      sourceRoot: sourceRoot,
                                      validatePresence: false)

        XCTAssertEqual(file!.path!, filePath.description)
        XCTAssertEqual(file!.sourceTree, .sdkRoot)
    }

    func test_addFileWithDeveloperDirSourceTreePath_pathIsTheSameAsAdded() throws {
        let sourceRoot = Path("/")
        let project = makeEmptyPBXProj()
        let group = PBXGroup(children: [],
                             sourceTree: .group,
                             name: "group")
        project.add(object: group)
        let pbxProject = PBXProject(name: "ProjectName",
                                    buildConfigurationList: XCConfigurationList(),
                                    compatibilityVersion: "0",
                                    mainGroup: group)
        project.add(object: pbxProject)

        let filePath = Path("Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk/usr/lib/libresolv.9.tbd")
        let file = try? group.addFile(at: filePath,
                                      sourceTree: .developerDir,
                                      sourceRoot: sourceRoot,
                                      validatePresence: false)

        XCTAssertEqual(file!.path!, filePath.description)
        XCTAssertEqual(file!.sourceTree, .developerDir)
    }

    private func makeEmptyPBXProj() -> PBXProj {
        PBXProj(
            rootObject: nil,
            objectVersion: 0,
            archiveVersion: 0,
            classes: [:],
            objects: []
        )
    }

    private func testDictionary() -> [String: Any] {
        [
            "children": ["child"],
            "name": "name",
            "sourceTree": "absolute",
        ]
    }
}
