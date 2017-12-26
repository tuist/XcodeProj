import Foundation
import XCTest
import PathKit
import xcproj
import ShellOut

final class PerformanceTests: XCTestCase {
    
    var tempDirectory: Path!
    
    override func setUp() {
        super.setUp()
        tempDirectory = (Path(#file) + "../../.." + Path("tmp")).normalize()
        try? tempDirectory.delete()
        try? tempDirectory.mkpath()
    }
    
    func test_githaw() throws {
        let path = try cloneRepo(gitURL: URL(string: "https://github.com/rnystrom/GitHawk")!,
                                 revision: "8e30bacb81593daff279cf288f64ced15676bfa3",
                                 projectPath: "Freetime.xcodeproj")
        measure {
            _ = try? XcodeProj(path: path)
        }
    }
    
    func test_wwdc() throws {
        let path = try cloneRepo(gitURL: URL(string: "https://github.com/insidegui/WWDC")!,
                                 revision: "272ac4c4a162b093f5eb73e32f3aeb706f698d66",
                                 projectPath: "WWDC.xcodeproj")
        measure {
            _ = try? XcodeProj(path: path)
        }
    }
    
    func test_emergence() throws {
        let path = try cloneRepo(gitURL: URL(string: "https://github.com/artsy/Emergence")!,
                                 revision: "21069fb406411d02b438b2b6c4a268141f03191a",
                                 projectPath: "Emergence.xcodeproj")
        measure {
            _ = try? XcodeProj(path: path)
        }
    }
    
    fileprivate func cloneRepo(gitURL: URL, revision: String, projectPath: String) throws -> Path {
        let name = gitURL.lastPathComponent
        let clonePath = tempDirectory + Path(name)
        try shellOut(to: "git clone --depth=1 \(gitURL) \(clonePath.string)")
        let gitDirectory = (clonePath + ".git").absolute().string
        try shellOut(to: "git --git-dir \(gitDirectory) reset --hard \(revision)")
        return clonePath + Path(projectPath)
    }
    
}
