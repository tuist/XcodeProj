import Foundation
import XCTest
import Basic

@testable import xcodeproj

final class OSSProjectsTests: XCTestCase {

    var tempDirectory: AbsolutePath!

    override func setUp() {
        super.setUp()
        tempDirectory = AbsolutePath(#file).appending(RelativePath("../../../tmp"))
        try? tempDirectory.delete()
        try? tempDirectory.mkpath()
    }

    override func tearDown() {
        super.tearDown()
        try? tempDirectory.delete()
    }

    func test_projects() throws {
        try [
            (URL(string: "https://github.com/rnystrom/GitHawk")!, "Freetime.xcodeproj"),
            (URL(string: "https://github.com/insidegui/WWDC")!, "WWDC.xcodeproj"),
            (URL(string: "https://github.com/artsy/Emergence")!, "Emergence.xcodeproj")
        ].forEach { (project) in
            try attemptOpen(gitURL: project.0, projectPath: project.1)
        }

    }

    fileprivate func attemptOpen(gitURL: URL,
                                 projectPath: String) throws {
        let name = gitURL.lastPathComponent
        let clonePath = tempDirectory.appending(RelativePath(name))
        print("> Cloning \(gitURL) to run the integration test")
        try Process.checkNonZeroExit(args: "git", "clone", "--depth=1", gitURL.absoluteString, clonePath.asString)
        let hash = try Process.popen(args:  "cd", clonePath.asString, "&&", "git", "rev-parse", "HEAD").utf8Output()
        print("> Running tests on commit: \(hash)")
        let projectFullPath = clonePath.appending(RelativePath(projectPath))
        let project = try XcodeProj(path: projectFullPath)
        print("> Project \(projectPath) can be opened ✅")
        try project.write(path: projectFullPath)
        let diff = try Process.popen(args: "cd", clonePath.asString, "&&", "git", "diff").utf8Output()
        XCTAssertTrue(diff == "", "Writing project without changes should not result in changes")
    }
}
