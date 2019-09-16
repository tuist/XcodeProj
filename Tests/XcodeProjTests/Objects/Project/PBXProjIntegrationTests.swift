import Foundation
import PathKit
import Shell
import XCTest
@testable import XcodeProj

final class PBXProjIntegrationTests: XCTestCase {
    var shell: Shell!

    override func setUp() {
        super.setUp()
        shell = Shell()
    }

    func test_init_initializesTheProjCorrectly() {
        let data = try! Data(contentsOf: fixturePath().url)
        let decoder = XcodeprojPropertyListDecoder()
        let proj = try? decoder.decode(PBXProj.self, from: data)
        XCTAssertNotNil(proj)
        if let proj = proj {
            assert(proj: proj)
        }
    }

    func test_write() {
        testWrite(from: fixturePath(),
                  initModel: { path -> PBXProj? in
                      let data = try! Data(contentsOf: path.url)
                      let decoder = XcodeprojPropertyListDecoder()
                      return try? decoder.decode(PBXProj.self, from: data)
                  },
                  modify: { $0 })
    }

    func test_write_produces_no_diff() throws {
        let tmpDir = try Path.uniqueTemporary()
        defer {
            try? tmpDir.delete()
        }

        let fixturePath = self.fixturePath().parent()
        let xcodeprojPath = tmpDir + "Project.xcodeproj"
        try fixturePath.copy(xcodeprojPath)

        try tmpDir.chdir {
            // Create a commit
            _ = try shell.capture(["git", "init"]).get()
            _ = try shell.capture(["git", "add", "."]).get()
            _ = try shell.capture(["git", "commit", "-m", "'test'"]).get()

            // Read/write the project
            let project = try XcodeProj(path: xcodeprojPath)
            try project.writePBXProj(path: xcodeprojPath, outputSettings: PBXOutputSettings())

            let got = try shell.capture(["git", "status"]).get()
            XCTAssertTrue(got.contains("nothing to commit"))
        }
    }

    private func fixturePath() -> Path {
        let path = fixturesPath() + "iOS/Project.xcodeproj/project.pbxproj"
        return path
    }

    private func assert(proj: PBXProj) {
        XCTAssertEqual(proj.archiveVersion, 1)
        XCTAssertEqual(proj.objectVersion, 52)
        XCTAssertEqual(proj.classes.count, 0)
        XCTAssertEqual(proj.objects.buildFiles.count, 13)
        XCTAssertEqual(proj.objects.aggregateTargets.count, 0)
        XCTAssertEqual(proj.objects.containerItemProxies.count, 1)
        XCTAssertEqual(proj.objects.copyFilesBuildPhases.count, 1)
        XCTAssertEqual(proj.objects.groups.count, 6)
        XCTAssertEqual(proj.objects.configurationLists.count, 3)
        XCTAssertEqual(proj.objects.buildConfigurations.count, 6)
        XCTAssertEqual(proj.objects.variantGroups.count, 2)
        XCTAssertEqual(proj.objects.targetDependencies.count, 1)
        XCTAssertEqual(proj.objects.sourcesBuildPhases.count, 2)
        XCTAssertEqual(proj.objects.shellScriptBuildPhases.count, 1)
        XCTAssertEqual(proj.objects.resourcesBuildPhases.count, 2)
        XCTAssertEqual(proj.objects.frameworksBuildPhases.count, 2)
        XCTAssertEqual(proj.objects.headersBuildPhases.count, 1)
        XCTAssertEqual(proj.objects.nativeTargets.count, 2)
        XCTAssertEqual(proj.objects.fileReferences.count, 16)
        XCTAssertEqual(proj.objects.buildRules.count, 1)
        XCTAssertEqual(proj.objects.versionGroups.count, 1)
        XCTAssertEqual(proj.objects.projects.count, 1)
        XCTAssertEqual(proj.objects.swiftPackageProductDependencies.count, 2)
        XCTAssertEqual(proj.objects.remoteSwiftPackageReferences.count, 1)
    }
}
