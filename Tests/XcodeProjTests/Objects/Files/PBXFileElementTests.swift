import Foundation
import PathKit
import XCTest
@testable import XcodeProj

final class PBXFileElementTests: XCTestCase {
    var subject: PBXFileElement!

    override func setUp() {
        super.setUp()
        subject = PBXFileElement(sourceTree: .absolute,
                                 path: "path",
                                 name: "name",
                                 includeInIndex: false,
                                 wrapsLines: true)
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXFileElement.isa, "PBXFileElement")
    }

    func test_init_initializesTheFileElementWithTheRightAttributes() {
        XCTAssertEqual(subject.sourceTree, .absolute)
        XCTAssertEqual(subject.path, "path")
        XCTAssertEqual(subject.name, "name")
        XCTAssertEqual(subject.includeInIndex, false)
        XCTAssertEqual(subject.wrapsLines, true)
    }

    func test_equal_returnsTheCorrectValue() {
        let another = PBXFileElement(sourceTree: .absolute,
                                     path: "path",
                                     name: "name",
                                     includeInIndex: false,
                                     wrapsLines: true)
        XCTAssertEqual(subject, another)
    }

    func test_fullPath_with_parent() throws {
        let sourceRoot = Path("/")
        let fileref = PBXFileReference(sourceTree: .group,
                                       fileEncoding: 1,
                                       explicitFileType: "sourcecode.swift",
                                       lastKnownFileType: nil,
                                       path: "/a/path")
        let group = PBXGroup(children: [fileref],
                             sourceTree: .group,
                             name: "/to/be/ignored")

        let mainGroup = PBXGroup(children: [group],
                                 sourceTree: .group,
                                 name: "/to/be/ignored")

        let project = PBXProject(name: "ProjectName",
                                 buildConfigurationList: XCConfigurationList(),
                                 compatibilityVersion: "0",
                                 mainGroup: mainGroup)

        let objects = PBXObjects(objects: [project, mainGroup, fileref, group])
        fileref.reference.objects = objects
        group.reference.objects = objects

        let fullPath = try fileref.fullPath(sourceRoot: sourceRoot)
        XCTAssertEqual(fullPath?.string, "/a/path")
        XCTAssertNotNil(group.children.first?.parent)
    }

    func test_fullPath_without_parent() throws {
        let sourceRoot = Path("/")
        let fileref = PBXFileReference(sourceTree: .group,
                                       fileEncoding: 1,
                                       explicitFileType: "sourcecode.swift",
                                       lastKnownFileType: nil,
                                       path: "/a/path")
        let group = PBXGroup(children: [fileref],
                             sourceTree: .group,
                             name: "/to/be/ignored",
                             path: "groupPath")

        let objects = PBXObjects(objects: [fileref, group])
        fileref.reference.objects = objects
        group.reference.objects = objects
        // Remove parent for fallback test
        fileref.parent = nil

        XCTAssertThrowsError(try fileref.fullPath(sourceRoot: sourceRoot)) { error in
            if case let PBXProjError.invalidGroupPath(sourceRoot, elementPath) = error {
                XCTAssertEqual(sourceRoot, "/")
                XCTAssertEqual(elementPath, "groupPath")
            } else {
                XCTAssert(false, "fullPath should fails with PBXProjError.invalidGroupPath instaed of: \(error)")
            }
        }
    }

    func test_fullPath_with_nested_groups() throws {
        let sourceRoot = Path("/")
        let fileref = PBXFileReference(sourceTree: .group,
                                       fileEncoding: 1,
                                       explicitFileType: "sourcecode.swift",
                                       lastKnownFileType: nil,
                                       path: "file/path")
        let nestedGroup = PBXGroup(children: [fileref],
                                   sourceTree: .group,
                                   path: "group/path")
        let rootGroup = PBXGroup(children: [nestedGroup],
                                 sourceTree: .group)

        let project = PBXProject(name: "ProjectName",
                                 buildConfigurationList: XCConfigurationList(),
                                 compatibilityVersion: "0",
                                 mainGroup: rootGroup)

        let objects = PBXObjects(objects: [fileref, nestedGroup, rootGroup, project])
        fileref.reference.objects = objects
        nestedGroup.reference.objects = objects

        let fullPath = try fileref.fullPath(sourceRoot: sourceRoot)
        XCTAssertEqual(fullPath?.string, "/group/path/file/path")
    }

    private func testDictionary() -> [String: Any] {
        [
            "sourceTree": "absolute",
            "path": "path",
            "name": "name",
            "includeInIndex": "0",
            "wrapsLines": "1",
        ]
    }

    func test_plistKeyAndValue_returns_dictionary_value() throws {
        let foo = PBXFileElement()
        let proj = PBXProj()
        let reference = ""
        if case .dictionary = try foo.plistKeyAndValue(proj: proj, reference: reference).value {
            // noop we’re good!
        } else {
            XCTFail("""
            The implementation of PBXFileElement.plistKeyAndValue has changed,
            which will break PBXReferenceProxy’s overriden implementation.
            This must be fixed!
            """)
        }
    }
}
