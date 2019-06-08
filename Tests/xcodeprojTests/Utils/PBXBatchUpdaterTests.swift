import Foundation
import PathKit
import XCTest
@testable import XcodeProj

class PBXBatchUpdaterTests: XCTestCase {
    var tmpDir: Path!

    override func setUp() {
        super.setUp()
        tmpDir = try! Path.uniqueTemporary()
    }

    override func tearDown() {
        try! tmpDir.delete()
    }

    func test_addFile_useMainProjectGroup() throws {
        // Given: The project is created
        let proj = fillAndCreateProj(path: tmpDir.string)
        let project = proj.projects.first!

        // Given: A file exists
        let filePath = tmpDir + "file.swift"
        try createFile(at: filePath)

        // When
        try proj.batchUpdate(sourceRoot: tmpDir) {
            let file = $0.addFile(to: project, at: filePath)
            let fileFullPath = file.fullPath(sourceRoot: tmpDir)

            XCTAssertEqual(fileFullPath, filePath)
        }

        // Then
        XCTAssertEqual(proj.fileReferences.count, 2)
        XCTAssertEqual(proj.groups.count, 1)
    }

    func test_addFile_withSubgroups() {
        // Given: The project is created
        let proj = fillAndCreateProj(path: tmpDir.string)

        let project = proj.projects.first!
        let subgroupNames = (0 ... 5).map { _ in UUID().uuidString }
        let expectedGroupCount = 1 + subgroupNames.count

        try! proj.batchUpdate(sourceRoot: tmpDir) { updater in
            // When: A file is added
            let fileName = "file.swift"
            let subgroupPath = subgroupNames.joined(separator: "/")
            let filePath = tmpDir + subgroupPath + fileName
            try createFile(at: filePath)

            let file = updater.addFile(to: project, at: filePath)
            let fileFullPath = file.fullPath(sourceRoot: tmpDir)

            // Then: The paths are the same
            XCTAssertEqual(fileFullPath, filePath)
        }

        // Then
        XCTAssertEqual(proj.fileReferences.count, 2)
        XCTAssertEqual(proj.groups.count, expectedGroupCount)
    }

    func test_addFile_byFileName() {
        // Given: The project is created
        let proj = fillAndCreateProj(path: tmpDir.string)
        let project = proj.projects.first!
        let mainGroup = project.mainGroup!

        try! proj.batchUpdate(sourceRoot: tmpDir) { updater in
            // When: A file is added
            let fileName = "file.swift"
            let filePath = tmpDir + fileName
            try createFile(at: filePath)
            let file = updater.addFile(to: mainGroup, fileName: fileName)
            let fileFullPath = file.fullPath(sourceRoot: tmpDir)

            // Then: The path is right
            XCTAssertEqual(fileFullPath, filePath)
        }

        XCTAssertEqual(proj.fileReferences.count, 2)
        XCTAssertEqual(proj.groups.count, 1)
    }

    func test_addFile_alreadyExisted() {
        // Given: The project is created
        let proj = fillAndCreateProj(path: tmpDir.string)

        let project = proj.projects.first!
        let mainGroup = project.mainGroup!
        try! proj.batchUpdate(sourceRoot: tmpDir) { updater in

            // When: A file that already exists is added
            let fileName = "file.swift"
            let filePath = tmpDir + fileName
            try createFile(at: filePath)
            let firstFile = updater.addFile(to: project, at: filePath)
            let secondFile = updater.addFile(to: mainGroup, fileName: fileName)
            let firstFileFullPath = firstFile.fullPath(sourceRoot: tmpDir)
            let secondFileFullPath = secondFile.fullPath(sourceRoot: tmpDir)

            // Then: The paths are right
            XCTAssertEqual(firstFileFullPath, filePath)
            XCTAssertEqual(secondFileFullPath, filePath)
            XCTAssertEqual(firstFile, secondFile)
        }

        // Then: The number of files and groups is right
        XCTAssertEqual(proj.fileReferences.count, 2)
        XCTAssertEqual(proj.groups.count, 1)
    }

    func test_addFile_alreadyExistedWithSubgroups() {
        // Given: The project is created
        let proj = fillAndCreateProj(path: tmpDir.string)

        let project = proj.projects.first!
        let subgroupNames = (0 ... 5).map { _ in UUID().uuidString }
        let expectedGroupCount = 1 + subgroupNames.count

        try! proj.batchUpdate(sourceRoot: tmpDir) { updater in
            // When: Files and groups are added
            let fileName = "file.swift"
            let subgroupPath = subgroupNames.joined(separator: "/")
            let filePath = tmpDir + subgroupPath + fileName
            try createFile(at: filePath)
            let firstFile = updater.addFile(to: project, at: filePath)
            let parentGroup = proj.groups.first(where: { $0.path == subgroupNames.last! })!
            let secondFile = updater.addFile(to: parentGroup, fileName: fileName)
            let firstFileFullPath = firstFile.fullPath(sourceRoot: tmpDir)
            let secondFileFullPath = secondFile.fullPath(sourceRoot: tmpDir)

            // Then: The paths have the right value
            XCTAssertEqual(firstFileFullPath, filePath)
            XCTAssertEqual(secondFileFullPath, filePath)
            XCTAssertEqual(firstFile, secondFile)
        }

        // Then: The number of files and groups is the expected
        XCTAssertEqual(proj.fileReferences.count, 2)
        XCTAssertEqual(proj.groups.count, expectedGroupCount)
    }

    private func fillAndCreateProj(path: String) -> PBXProj {
        // Proj
        let proj = PBXProj()

        // Group
        let mainGroup = PBXGroup()
        mainGroup.sourceTree = .absolute
        mainGroup.path = path
        proj.add(object: mainGroup)

        // Configuration
        let configurationList = XCConfigurationList(buildConfigurations: [], defaultConfigurationName: nil, defaultConfigurationIsVisible: true)
        proj.add(object: configurationList)

        // Project
        let project = PBXProject(name: "test", buildConfigurationList: configurationList, compatibilityVersion: "1", mainGroup: mainGroup)
        proj.add(object: project)
        proj.rootObject = project

        // File
        let fileref = PBXFileReference(sourceTree: .group,
                                       fileEncoding: 1,
                                       explicitFileType: "sourcecode.swift",
                                       lastKnownFileType: nil,
                                       path: "path")
        proj.add(object: fileref)
        mainGroup.children.append(fileref)

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
