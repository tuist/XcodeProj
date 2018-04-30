import Foundation
import XCTest
import PathKit
import ShellOut
import xcodeproj

final class OSSProjectsTests: XCTestCase {
    
    var tempDirectory: Path!
    
    override func setUp() {
        super.setUp()
        tempDirectory = (Path(#file) + "../../.." + Path("tmp")).normalize()
        try? tempDirectory.delete()
        try? tempDirectory.mkpath()
    }
    
    override func tearDown() {
        super.tearDown()
        try? tempDirectory.delete()
    }
    
    func test_projects() throws {
        try [
            (URL(string: "https://github.com/artsy/eigen")!, "Artsy.xcodeproj"),
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
        let clonePath = tempDirectory + Path(name)
        print("> Cloning \(gitURL) to run the integration test")
        try shellOut(to: "git clone --depth=1 \(gitURL) \(clonePath.string)", at: tempDirectory.string)
        let hash = try shellOut(to: "git rev-parse HEAD", at: clonePath.string)
        print("> Running tests on commit: \(hash)")
        let projectFullPath = clonePath + Path(projectPath)
        let project = try XcodeProj(path: projectFullPath)
        print("> Project \(projectPath) can be opened ✅")
        try project.write(path: projectFullPath)
        let diff = try shellOut(to: "git diff", at: clonePath.string)
        XCTAssertTrue(diff == "", "Writing project without changes should not result in changes")
    }
    
}
