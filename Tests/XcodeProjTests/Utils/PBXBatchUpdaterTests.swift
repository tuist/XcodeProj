import Foundation
import PathKit
import XCTest
@testable import XcodeProj

class PBXBatchUpdaterTests: XCTestCase {
    func test_addFile_useMainProjectGroup() {
        let sourceRoot = Path.temporary
        let mainGroupPath = UUID().uuidString
        let proj = fillAndCreateProj(
            sourceRoot: sourceRoot,
            mainGroupPath: mainGroupPath
        )
        let project = proj.projects.first!
        try! proj.batchUpdate(sourceRoot: sourceRoot) { updater in
            let fileName = "file.swift"
            let filePath = Path("\(sourceRoot.string)\(mainGroupPath)/\(fileName)")
            try createFile(at: filePath)
            let file = try updater.addFile(to: project, at: filePath)
            let fileFullPath = try file.fullPath(sourceRoot: sourceRoot)
            XCTAssertEqual(
                fileFullPath,
                filePath
            )
        }

        XCTAssertEqual(proj.fileReferences.count, 2)
        XCTAssertEqual(proj.groups.count, 1)
    }

    func test_addFile_withSubgroups() {
        let sourceRoot = Path.temporary
        let mainGroupPath = UUID().uuidString
        let proj = fillAndCreateProj(
            sourceRoot: sourceRoot,
            mainGroupPath: mainGroupPath
        )
        let project = proj.projects.first!
        let subgroupNames = (0 ... 5).map { _ in UUID().uuidString }
        let expectedGroupCount = 1 + subgroupNames.count
        try! proj.batchUpdate(sourceRoot: sourceRoot) { updater in
            let fileName = "file.swift"
            let subgroupPath = subgroupNames.joined(separator: "/")
            let filePath = Path("\(sourceRoot.string)\(mainGroupPath)/\(subgroupPath)/\(fileName)")
            try createFile(at: filePath)
            let file = try updater.addFile(to: project, at: filePath)
            let fileFullPath = try file.fullPath(sourceRoot: sourceRoot)
            XCTAssertEqual(
                fileFullPath,
                filePath
            )
        }

        XCTAssertEqual(proj.fileReferences.count, 2)
        XCTAssertEqual(proj.groups.count, expectedGroupCount)
    }

    func test_addFile_byFileName() {
        let sourceRoot = Path.temporary
        let mainGroupPath = UUID().uuidString
        let proj = fillAndCreateProj(
            sourceRoot: sourceRoot,
            mainGroupPath: mainGroupPath
        )
        let project = proj.projects.first!
        let mainGroup = project.mainGroup!
        try! proj.batchUpdate(sourceRoot: sourceRoot) { updater in
            let fileName = "file.swift"
            let filePath = Path("\(sourceRoot.string)\(mainGroupPath)/\(fileName)")
            try createFile(at: filePath)
            let file = try updater.addFile(to: mainGroup, fileName: fileName)
            let fileFullPath = try file.fullPath(sourceRoot: sourceRoot)
            XCTAssertEqual(
                fileFullPath,
                filePath
            )
        }

        XCTAssertEqual(proj.fileReferences.count, 2)
        XCTAssertEqual(proj.groups.count, 1)
    }

    func test_addFile_alreadyExisted() {
        let sourceRoot = Path.temporary
        let mainGroupPath = UUID().uuidString
        let proj = fillAndCreateProj(
            sourceRoot: sourceRoot,
            mainGroupPath: mainGroupPath
        )
        let project = proj.projects.first!
        let mainGroup = project.mainGroup!
        try! proj.batchUpdate(sourceRoot: sourceRoot) { updater in
            let fileName = "file.swift"
            let filePath = Path("\(sourceRoot.string)\(mainGroupPath)/\(fileName)")
            try createFile(at: filePath)
            let firstFile = try updater.addFile(to: project, at: filePath)
            let secondFile = try updater.addFile(to: mainGroup, fileName: fileName)
            let firstFileFullPath = try firstFile.fullPath(sourceRoot: sourceRoot)
            let secondFileFullPath = try secondFile.fullPath(sourceRoot: sourceRoot)
            XCTAssertEqual(
                firstFileFullPath,
                filePath
            )
            XCTAssertEqual(
                secondFileFullPath,
                filePath
            )
            XCTAssertEqual(
                firstFile,
                secondFile
            )
        }

        XCTAssertEqual(proj.fileReferences.count, 2)
        XCTAssertEqual(proj.groups.count, 1)
    }

    func test_addFile_alreadyExistedWithSubgroups() {
        let sourceRoot = Path.temporary
        let mainGroupPath = UUID().uuidString
        let proj = fillAndCreateProj(
            sourceRoot: sourceRoot,
            mainGroupPath: mainGroupPath
        )
        let project = proj.projects.first!
        let subgroupNames = (0 ... 5).map { _ in UUID().uuidString }
        let expectedGroupCount = 1 + subgroupNames.count
        try! proj.batchUpdate(sourceRoot: sourceRoot) { updater in
            let fileName = "file.swift"
            let subgroupPath = subgroupNames.joined(separator: "/")
            let filePath = Path("\(sourceRoot.string)\(mainGroupPath)/\(subgroupPath)/\(fileName)")
            try createFile(at: filePath)
            let firstFile = try updater.addFile(to: project, at: filePath)
            let parentGroup = proj.groups.first(where: { $0.path == subgroupNames.last! })!
            let secondFile = try updater.addFile(to: parentGroup, fileName: fileName)
            let firstFileFullPath = try firstFile.fullPath(sourceRoot: sourceRoot)
            let secondFileFullPath = try secondFile.fullPath(sourceRoot: sourceRoot)
            XCTAssertEqual(
                firstFileFullPath,
                filePath
            )
            XCTAssertEqual(
                secondFileFullPath,
                filePath
            )
            XCTAssertEqual(
                firstFile,
                secondFile
            )
        }

        XCTAssertEqual(proj.fileReferences.count, 2)
        XCTAssertEqual(proj.groups.count, expectedGroupCount)
    }

    private func fillAndCreateProj(sourceRoot _: Path, mainGroupPath: String) -> PBXProj {
        let proj = PBXProj.fixture()
        let fileref = PBXFileReference(sourceTree: .group,
                                       fileEncoding: 1,
                                       explicitFileType: "sourcecode.swift",
                                       lastKnownFileType: nil,
                                       path: "path")
        proj.add(object: fileref)
        let group = PBXGroup(children: [fileref],
                             sourceTree: .group,
                             name: "group",
                             path: mainGroupPath)
        proj.add(object: group)
        let project = PBXProject.fixture(mainGroup: group)
        proj.add(object: project)
        return proj
    }

    private func createFile(at filePath: Path) throws {
        let directoryURL = filePath.url.deletingLastPathComponent()
        try FileManager.default.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )
        try Data().write(to: filePath.url)
    }
}
