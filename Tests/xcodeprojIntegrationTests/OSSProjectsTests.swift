import Basic
import Foundation
@testable import xcodeproj
import XCTest

final class OSSProjectsTests: XCTestCase {
    var tempDirectory: TemporaryDirectory!

    override func setUp() {
        super.setUp()
        tempDirectory = try! TemporaryDirectory()
        try! tempDirectory.path.delete()
        try! tempDirectory.path.mkpath()
    }

    override func tearDown() {
        super.tearDown()
        try! tempDirectory.path.delete()
    }

    func test_projects() throws {
        try attemptOpen(gitURL: URL(string: "https://github.com/insidegui/WWDC")!, projectPath: "WWDC.xcodeproj")
    }

    fileprivate func attemptOpen(gitURL: URL,
                                 projectPath: String) throws {
        let name = gitURL.lastPathComponent
        let clonePath = tempDirectory.path.appending(RelativePath(name))
        print("> Cloning \(gitURL) to run the integration test")
        try Process.checkNonZeroExit(args: "git", "clone", "--depth=1", gitURL.absoluteString, clonePath.asString)
        let hash = try Process.popen(args: "cd", clonePath.asString, "&&", "git", "rev-parse", "HEAD").utf8Output()
        print("> Running tests on commit: \(hash)")
        let projectFullPath = clonePath.appending(RelativePath(projectPath))
        let project = try XcodeProj(path: projectFullPath)
        print("> Project \(projectPath) can be opened ✅")
        try project.write(path: projectFullPath)
        let diff = try Process.popen(args: "cd", clonePath.asString, "&&", "git", "diff").utf8Output()
        XCTAssertTrue(diff == "", "Writing project without changes should not result in changes")
    }

    fileprivate func assertGeneratesAllReferences() {
    }
}
