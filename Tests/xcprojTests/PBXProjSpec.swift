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
        subject.objects.addObject(PBXCopyFilesBuildPhase(reference: "ref1"))
        subject.objects.addObject(PBXSourcesBuildPhase(reference: "ref2"))
        subject.objects.addObject(PBXShellScriptBuildPhase(reference: "ref3", files: [], inputPaths: [], outputPaths: [], shellScript: nil))
        subject.objects.addObject(PBXResourcesBuildPhase(reference: "ref4"))
        subject.objects.addObject(PBXFrameworksBuildPhase(reference: "ref5"))
        subject.objects.addObject(PBXHeadersBuildPhase(reference: "ref6"))
        subject.objects.addObject(PBXRezBuildPhase(reference: "ref7"))
        XCTAssertEqual(subject.objects.buildPhases.count, 7)
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
        XCTAssertEqual(proj.objects.buildFiles.count, 11)
        XCTAssertEqual(proj.objects.aggregateTargets.count, 0)
        XCTAssertEqual(proj.objects.containerItemProxies.count, 1)
        XCTAssertEqual(proj.objects.copyFilesBuildPhases.count, 1)
        XCTAssertEqual(proj.objects.groups.count, 5)
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
        XCTAssertEqual(proj.objects.versionGroups.count, 1)
        XCTAssertEqual(proj.objects.projects.count, 1)
    }

}
