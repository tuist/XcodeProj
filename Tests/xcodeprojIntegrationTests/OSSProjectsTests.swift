import Foundation
import PathKit
import SwiftShell
@testable import xcodeproj
import XCTest

final class OSSProjectsTests: XCTestCase {
    var tempDirectory = Path.temporary

    override func setUp() {
        super.setUp()
        try? tempDirectory.delete()
    }

    override func tearDown() {
        super.tearDown()
        try? tempDirectory.delete()
    }

    func test_projects() throws {
        let gitURL = URL(string: "https://github.com/insidegui/WWDC")!
        let projectPath = "WWDC.xcodeproj"
        let clonePath = try clone(gitURL: gitURL, projectPath: projectPath)
        let projectFullPath = clonePath + projectPath

        assertOpens(projectPath: projectFullPath)
        try assertEmptyDiff(projectPath: projectFullPath, clonePath: clonePath)
        try assertGeneratesAllReferences(projectPath: projectFullPath)
    }

    fileprivate func assertOpens(projectPath: Path,
                                 file _: String = #file,
                                 line _: UInt = #line) {
        XCTAssertNoThrow(try XcodeProj(path: projectPath))
    }

    fileprivate func assertEmptyDiff(projectPath: Path,
                                     clonePath: Path,
                                     file _: String = #file,
                                     line _: UInt = #line) throws {
        let project = try XcodeProj(path: projectPath)
        try project.write(path: projectPath)
        let diff = SwiftShell.run("cd", clonePath.string, "&&", "git", "diff").stdout
        XCTAssertTrue(diff == "", "Writing project without changes should not result in changes")
    }

    func assertGeneratesAllReferences(projectPath: Path,
                                      file _: String = #file,
                                      line _: UInt = #line) throws {
        let project = try XcodeProj(path: projectPath)
        project.pbxproj.objects.invalidateReferences()
        try project.write(path: projectPath)
        var temporaryFiles: [PBXObject] = []
        project.pbxproj.objects.forEach { object in
            if object.reference.temporary {
                temporaryFiles.append(object)
            }
        }
        XCTAssertTrue(temporaryFiles.isEmpty, "There are objects whose reference hasn't been generated")
    }

    fileprivate func clone(gitURL: URL,
                           projectPath _: String,
                           file _: String = #file,
                           line _: UInt = #line) throws -> Path {
        let name = gitURL.lastPathComponent
        try tempDirectory.mkpath()
        let clonePath = tempDirectory + name
        print("> Cloning \(gitURL) to run the integration test")
        try runAndPrint("git", "clone", "--depth=1", gitURL.absoluteString, clonePath.string)
        try runAndPrint("cd", clonePath.string, "&&", "git", "rev-parse", "HEAD")
        return clonePath
    }
}
