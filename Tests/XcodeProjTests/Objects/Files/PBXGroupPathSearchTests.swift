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

    let sourceRootName = "src"
    let subDirName = "subDir"
    let fileName = "theFile"

    var projectDir: Path!
    var sourceRoot: Path { projectDir + sourceRootName }
    var project: PBXProj!
    var group: PBXGroup!

    var files: Files!

    override func setUpWithError() throws {
        project = PBXProj(
            rootObject: nil,
            objectVersion: 0,
            archiveVersion: 0,
            classes: [:],
            objects: []
        )
        projectDir = try Path.uniqueTemporary()
        try (projectDir + sourceRootName + subDirName).mkpath()
        try createGroup()
        files = Files(
            fileName: fileName,
            file1Path: Path(fileName),
            file2Path: Path(components: [subDirName, fileName])
        )
    }

    func test_whenFilesHaveAbsoluteSourceTree_thenCanBeFoundByPath() throws {
        try checkAssertions(for: .absolute)
    }

    func test_whenFilesHaveGroupSourceTree_thenCanBeFoundByPath() throws {
        try checkAssertions(for: .group)
    }
    func test_whenFilesHaveSourceRootSourceTree_thenCanBeFoundByPath() throws {
        try checkAssertions(for: .sourceRoot)
    }
}

private extension PBXGroupPathSearchTests {

    func createGroup() throws {
        let group = PBXGroup(children: [], sourceTree: .group, name: "group", path: sourceRootName)
        let parent = PBXGroup(children: [group], sourceTree: .absolute, name: "parent", path: projectDir.string)
        project.add(object: parent)
        project.add(object: group)
        self.group = group
    }

    func addToGroup(testFiles: Files, sourceTree: PBXSourceTree) throws -> PathToFileReferenceMap {
        try [testFiles.file1Path, testFiles.file2Path]
            .reduce([Path: PBXFileReference]()) { map, filePath in
                let absolutePath = sourceRoot + filePath
                try Data().write(to: absolutePath.url)
                let file = try group.addFile(
                    at: absolutePath,
                    sourceTree: sourceTree,
                    sourceRoot: sourceRoot,
                    validatePresence: true
                )
                return map.merging([filePath: file]) { _, new in new }
            }
    }

    func checkAssertions(for sourceTree: PBXSourceTree, line: UInt = #line) throws {
        func assert(filePath: Path, hasReference: PBXFileReference?) {
            let actual = group.file(with: filePath, sourceRoot: sourceRoot)
            if let expected = hasReference {
                XCTAssertEqual(actual, expected, file: #file, line: line)
            } else {
                XCTAssertNil(actual, file: #file, line: line)
            }
        }

        let fileReferenceFor = try addToGroup(
            testFiles: files,
            sourceTree: sourceTree
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
            filePath: files.file2Path + "../.." + fileName,
            hasReference: fileReferenceFor[files.file1Path]
        )
        assert(
            filePath: files.file1Path + "../foo/.." + subDirName + fileName,
            hasReference: fileReferenceFor[files.file2Path]
        )
        assert(
            filePath: Path(UUID().uuidString),
            hasReference: nil
        )
    }
}
