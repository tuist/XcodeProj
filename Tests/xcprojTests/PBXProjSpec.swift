import Foundation
import XCTest
import PathKit
import xcproj

extension PBXProj {

    static func testData(archiveVersion: Int = 0,
                objectVersion: Int = 1,
                rootObject: String = "rootObject",
                classes: [Any] = [],
                objects: [PBXObject] = []) -> PBXProj {
        return PBXProj(archiveVersion: archiveVersion,
                       objectVersion: objectVersion,
                       rootObject: rootObject,
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
        subject = PBXProj(archiveVersion: 1,
                          objectVersion: 46,
                          rootObject: "root",
                          classes: [],
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

}

final class PBXProjIntegrationSpec: XCTestCase {

    func test_init_initializesTheProjCorrectly() {
//        do {
//            try PBXProj(path: fixturePath())
//        } catch {
//            print(error)
//        }
        let proj = try? PBXProj(path: fixturePath())
        XCTAssertNotNil(proj)
        if let proj = proj{
            assert(proj: proj)
        }
    }

    func test_write() {
        testWrite(from: fixturePath(),
                  initModel: { try? PBXProj(path: $0) },
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
        XCTAssertEqual(proj.buildFiles.count, 10)
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
        XCTAssertEqual(proj.fileReferences.count, 14)
        XCTAssertEqual(proj.projects.count, 1)
    }

}
