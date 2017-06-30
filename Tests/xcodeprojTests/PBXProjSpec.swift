import Foundation
import XCTest
import PathKit
import xcodeproj

final class PBXProjSpec: XCTestCase {
    
    var subject: PBXProj!
    var object: PBXObject!
    
    override func setUp() {
        super.setUp()
        object = PBXObject.pbxBuildFile(PBXBuildFile(reference: "ref", fileRef: "333"))
        subject = PBXProj(path: "test",
                          name: "name",
                          archiveVersion: 1,
                          objectVersion: 46,
                          rootObject: "root",
                          classes: [],
                          objects: Set(arrayLiteral: object))
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
    
    func test_addingObject_returnsAProjWithTheObjectAdded() {
        let anotherObject = PBXObject.pbxBuildFile(PBXBuildFile(reference: "ref", fileRef: "444"))
        let got = subject.adding(object: anotherObject)
        XCTAssertTrue(got.objects.contains(anotherObject))
    }
    
    func test_removingObject_returnsAProjWithTheObjectRemoved() {
        let got = subject.removing(object: object)
        XCTAssertTrue(subject.objects.contains(object))
        XCTAssertFalse(got.objects.contains(object))
    }
    
}

final class PBXProjIntegrationSpec: XCTestCase {
    
    func test_init_initializesTheProjCorrectly() {
        let proj = try? PBXProj(path: fixturePath(), name: "Test")
        XCTAssertNotNil(proj)
        if let proj = proj{
            assert(proj: proj)
        }
    }
    
    func test_write() {
        testWrite(from: fixturePath(),
                  initModel: { try? PBXProj(path: $0, name: "Project") },
                  modify: { $0 },
                  assertion: assert)
    }
    
    private func fixturePath() -> Path {
        let fixtures = Path(#file).parent().parent().parent() + Path("Fixtures")
        let path = fixtures + Path("iOS/Project.xcodeproj/project.pbxproj")
        return path
    }
    
    private func assert(proj: PBXProj) {
        XCTAssertEqual(proj.archiveVersion, 1)
        XCTAssertEqual(proj.objectVersion, 46)
        XCTAssertEqual(proj.classes.count, 0)
        XCTAssertEqual(proj.objects.buildFiles.count, 6)
        XCTAssertEqual(proj.objects.aggregateTargets.count, 0)
        XCTAssertEqual(proj.objects.containerItemProxies.count, 1)
        XCTAssertEqual(proj.objects.copyFilesBuildPhases.count, 1)
        XCTAssertEqual(proj.objects.groups.count, 4)
        XCTAssertEqual(proj.objects.fileElements.count, 0)
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
        XCTAssertEqual(proj.objects.fileReferences.count, 10)
        XCTAssertEqual(proj.objects.projects.count, 1)
    }
    
}
