import Basic
import Foundation
@testable import xcodeproj
import XCTest

extension PBXProj {
    static func testData(archiveVersion: UInt = 0,
                         objectVersion: UInt = 1,
                         rootObject: String = "rootObject",
                         classes: [String: Any] = [:],
                         objects: [String: PBXObject] = [:]) -> PBXProj {
        return PBXProj(rootObject: rootObject,
                       objectVersion: objectVersion,
                       archiveVersion: archiveVersion,
                       classes: classes,
                       objects: objects)
    }
}

final class PBXProjSpec: XCTestCase {
    var subject: PBXProj!
    var object: PBXObject!

    override func setUp() {
        super.setUp()
        object = PBXBuildFile(fileRef: "333")
        subject = PBXProj(rootObject: "root",
                          objectVersion: 46,
                          archiveVersion: 1,
                          classes: [:],
                          objects: ["ref": object])
    }

    func test_initWithDictionary_hasTheCorrectArchiveVersion() {
        XCTAssertEqual(subject.archiveVersion, 1)
    }

    func test_initWithDictionary_hasTheCorrectObjectVersion() {
        XCTAssertEqual(subject.objectVersion, 46)
    }

    func test_initWithDictionary_hasTheCorrectClasses() throws {
        XCTAssertTrue(subject.classes.isEmpty)
    }

    func test_buildPhases_returnsAllBuildPhases() {
        let subject = PBXProj(rootObject: "root")
        subject.objects.addObject(PBXCopyFilesBuildPhase(), reference: "ref1")
        subject.objects.addObject(PBXSourcesBuildPhase(), reference: "ref2")
        subject.objects.addObject(PBXShellScriptBuildPhase(files: [], inputPaths: [], outputPaths: [], shellScript: nil), reference: "ref3")
        subject.objects.addObject(PBXResourcesBuildPhase(), reference: "ref4")
        subject.objects.addObject(PBXFrameworksBuildPhase(), reference: "ref5")
        subject.objects.addObject(PBXHeadersBuildPhase(), reference: "ref6")
        subject.objects.addObject(PBXRezBuildPhase(), reference: "ref7")
        XCTAssertEqual(subject.objects.buildPhases.count, 7)
    }
}

final class PBXProjIntegrationSpec: XCTestCase {
    func test_init_initializesTheProjCorrectly() {
        let data = try! Data(contentsOf: fixturePath().url)
        let decoder = PropertyListDecoder()
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
                      let decoder = PropertyListDecoder()
                      return try? decoder.decode(PBXProj.self, from: data)
                  },
                  modify: { $0 })
    }

    private func fixturePath() -> AbsolutePath {
        let path = fixturesPath().appending(RelativePath("iOS/Project.xcodeproj/project.pbxproj"))
        return path
    }

    private func assert(proj: PBXProj) {
        XCTAssertEqual(proj.archiveVersion, 1)
        XCTAssertEqual(proj.objectVersion, 46)
        XCTAssertEqual(proj.classes.count, 0)
        XCTAssertEqual(proj.objects.buildFiles.count, 11)
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
        XCTAssertEqual(proj.objects.fileReferences.count, 15)
        XCTAssertEqual(proj.objects.buildRules.count, 1)
        XCTAssertEqual(proj.objects.versionGroups.count, 1)
        XCTAssertEqual(proj.objects.projects.count, 1)
    }
}
