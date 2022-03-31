import Foundation
import PathKit
import XcodeProj
import XCTest

final class PBXGroupPathSearchTests: XCTestCase {

    struct Files {
        let fileName: String
        let file1Path: Path
        let file2Path: Path
    }

    typealias PathToFileReferenceMap = [Path: PBXFileReference]

    let groupPathComponentsCount = 2

    enum Names {
        static let fileName = "theFile"
        static let sourceRoot = "src"
        static let group = "theGroup"
        static let subDir = "subDir"
    }

    var projectPath: Path!
    var sourceRoot: Path { projectPath + Names.sourceRoot }
    var groupPath: Path { sourceRoot + Names.group }
    var subDirPath: Path { groupPath + Names.subDir }

    var project: PBXProj!
    var group: PBXGroup!

    override func setUpWithError() throws {
        project = PBXProj(
            rootObject: nil,
            objectVersion: 0,
            archiveVersion: 0,
            classes: [:],
            objects: []
        )
        projectPath = try Path.uniqueTemporary()
        try (projectPath + Names.sourceRoot + Names.group + Names.subDir).mkpath()
        try createGroup()
    }

    func test_whenFilesHaveAbsoluteSourceTree_thenCanBeFound() throws {
        try checkAssertions(for: .absolute) {
            Files(
                fileName: Names.fileName,
                file1Path: groupPath + Names.fileName,
                file2Path: subDirPath + Names.fileName
            )
        }
    }

    func test_whenFilesHaveGroupSourceTree_thenCanBeFound() throws {
        try checkAssertions(for: .group) {
            Files(
                fileName: Names.fileName,
                file1Path: Path(Names.fileName),
                file2Path: Path(components: [Names.subDir, Names.fileName])
            )
        }
    }
    func test_whenFilesHaveSourceRootSourceTree_thenCanBeFound() throws {
        try checkAssertions(for: .sourceRoot) {
            Files(
                fileName: Names.fileName,
                file1Path: Path(components: [Names.sourceRoot, Names.fileName]),
                file2Path: Path(components: [Names.sourceRoot, Names.subDir, Names.fileName])
            )
        }
    }
}

private extension PBXGroupPathSearchTests {

    func createGroup() throws {
        let group = PBXGroup(
            children: [],
            sourceTree: .group,
            name: "group",
            path: Path(components: [Names.sourceRoot, Names.group]).string
        )
        let parent = PBXGroup(
            children: [group],
            sourceTree: .absolute,
            name: "parent",
            path: projectPath.string
        )
        project.add(object: parent)
        project.add(object: group)
        self.group = group
    }

    func addToGroup(
        testFiles: Files, sourceTree: PBXSourceTree, sourceRoot: Path
    ) throws -> PathToFileReferenceMap {
        try [testFiles.file1Path, testFiles.file2Path]
            .reduce([Path: PBXFileReference]()) { map, filePath in
                let file = try group.addFile(
                    at: filePath,
                    sourceTree: sourceTree,
                    sourceRoot: sourceRoot,
                    validatePresence: false
                )
                return map.merging([filePath: file]) { _, new in new }
            }
    }

    func checkAssertions(for sourceTree: PBXSourceTree, with files: () -> Files) throws {
        func assert(filePath: Path, hasReference: PBXFileReference?, line: UInt = #line) {
            let actual = group.file(with: filePath, sourceRoot: sourceRoot)
            if let expected = hasReference {
                XCTAssertEqual(actual, expected, file: #file, line: line)
            } else {
                XCTAssertNil(actual, file: #file, line: line)
            }
        }

        let files = files()
        let fileReferenceFor = try addToGroup(
            testFiles: files,
            sourceTree: sourceTree,
            sourceRoot: projectPath
        )

        assert(
            filePath: files.file1Path,
            hasReference: fileReferenceFor[files.file1Path]
        )
        assert(
            filePath: files.file2Path,
            hasReference: fileReferenceFor[files.file2Path]
        )
        assert(
            filePath: files.file2Path + "../.." + Names.fileName,
            hasReference: fileReferenceFor[files.file1Path]
        )
        assert(
            filePath: files.file1Path + "../foo/.." + Names.subDir + Names.fileName,
            hasReference: fileReferenceFor[files.file2Path]
        )
        assert(
            filePath: Path(UUID().uuidString),
            hasReference: nil
        )
    }
}
