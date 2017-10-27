import Foundation
import XCTest
import PathKit
import xcproj

extension PBXProj {

    static func testData(archiveVersion: Int = 0,
                objectVersion: Int = 1,
                rootObject: String = "rootObject",
                classes: [String: Any] = [:],
                objects: [PBXObject] = []) -> PBXProj {
        return PBXProj(objectVersion: objectVersion,
                       rootObject: rootObject,
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
        object = PBXBuildFile(reference: "ref", fileRef: "333")
        subject = PBXProj(objectVersion: 46,
                          rootObject: "root",
                          archiveVersion: 1,
                          classes: [:],
                          objects: [object])
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
        let subject = PBXProj(objectVersion: 0, rootObject: "root")
        subject.addObject(PBXCopyFilesBuildPhase(reference: "ref1"))
        subject.addObject(PBXSourcesBuildPhase(reference: "ref2"))
        subject.addObject(PBXShellScriptBuildPhase(reference: "ref3", files: [], inputPaths: [], outputPaths: [], shellScript: nil))
        subject.addObject(PBXResourcesBuildPhase(reference: "ref4"))
        subject.addObject(PBXFrameworksBuildPhase(reference: "ref5"))
        subject.addObject(PBXHeadersBuildPhase(reference: "ref6"))
        XCTAssertEqual(subject.buildPhases.count, 6)
    }
}

final class PBXProjIntegrationSpec: XCTestCase {

    func test_init_initializesTheProjCorrectly() {
        let data = try! Data(contentsOf: fixturePath().url)
        let decoder = PropertyListDecoder()
        let proj = try? decoder.decode(PBXProj.self, from: data)
        XCTAssertNotNil(proj)
        if let proj = proj{
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

    private func fixturePath() -> Path {
        let path = fixturesPath() + Path("iOS/Project.xcodeproj/project.pbxproj")
        return path
    }

    private func assert(proj: PBXProj) {
        XCTAssertEqual(proj.archiveVersion, 1)
        XCTAssertEqual(proj.objectVersion, 46)
        XCTAssertEqual(proj.classes.count, 0)
        XCTAssertEqual(proj.buildFiles.count, 11)
        XCTAssertEqual(proj.aggregateTargets.count, 0)
        XCTAssertEqual(proj.containerItemProxies.count, 1)
        XCTAssertEqual(proj.copyFilesBuildPhases.count, 1)
        XCTAssertEqual(proj.groups.count, 5)
        XCTAssertEqual(proj.fileElements.count, 0)
        XCTAssertEqual(proj.configurationLists.count, 3)
        XCTAssertEqual(proj.buildConfigurations.count, 6)
        XCTAssertEqual(proj.variantGroups.count, 2)
        XCTAssertEqual(proj.targetDependencies.count, 1)
        XCTAssertEqual(proj.sourcesBuildPhases.count, 2)
        XCTAssertEqual(proj.shellScriptBuildPhases.count, 1)
        XCTAssertEqual(proj.resourcesBuildPhases.count, 2)
        XCTAssertEqual(proj.frameworksBuildPhases.count, 2)
        XCTAssertEqual(proj.headersBuildPhases.count, 1)
        XCTAssertEqual(proj.nativeTargets.count, 2)
        XCTAssertEqual(proj.fileReferences.count, 15)
        XCTAssertEqual(proj.versionGroups.count, 1)
        XCTAssertEqual(proj.projects.count, 1)
    }

}
