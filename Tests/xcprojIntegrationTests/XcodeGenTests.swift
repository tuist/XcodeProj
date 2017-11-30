import Foundation
import XCTest
import PathKit
import ShellOut

final class XcodeGenTests: XCTestCase {
    
    var tempDirectory: Path!
    var projectDirectory: Path!
    
    override func setUp() {
        super.setUp()
        projectDirectory = (Path(#file) + "../../..").normalize()
        tempDirectory = (projectDirectory + Path("tmp")).normalize()
        try? tempDirectory.delete()
        try? tempDirectory.mkpath()
    }
    
    override func tearDown() {
        super.tearDown()
        try? tempDirectory.delete()
    }
    
    func test_xcodegen_builds() throws {
        let clonePath = tempDirectory + Path("xcodegen")
        print("> Cloning XcodeGen repository")
        try shellOut(to: "git clone --depth=1 git@github.com:yonaskolb/XcodeGen.git \(clonePath.string)")
        let packageSwiftPath = clonePath + Path("Package.swift")
        let revisionCommand = "git --git-dir \(projectDirectory.string)/.git rev-list --max-count=1 HEAD"
        let revision = try shellOut(to: revisionCommand)
        let packageSwiftString = try String(contentsOf: packageSwiftPath.url)
        let packageSwiftWithLocalDependency = try makeXcprojDependencyLocal(content: packageSwiftString, revision: revision)
        print("> Updating Package.swift to use the local xcproj")
        try packageSwiftWithLocalDependency.write(to: packageSwiftPath.url,
                                                  atomically: true,
                                                  encoding: .utf8)
        print("> Building XcodeGen")
        try shellOut(to: "cd \(clonePath); swift build")
        print("> Testing XcodeGen")
        try shellOut(to: "cd \(clonePath); swift test")
    }
    
    fileprivate func makeXcprojDependencyLocal(content: String,
                                               revision: String) throws -> String {
        let expression = "\\.package\\(url:\\s*\\\".+xcproj.git\\\".+\\)"
        let replacement = ".package(url: \"../..\", .revision(\"\(revision)\"))"
        return content.replacingOccurrences(of: expression, with: replacement, options: .regularExpression, range: nil)
    }
    
}

