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
    
    // MARK: - Integration
    
    func test_integration_init_hasTheCorrectArchiveVersion() {
        let got = integrationSubject()
        XCTAssertEqual(got?.archiveVersion, 1)
    }
    
    func test_integration_init_hasTheCorrectObjectVersion() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objectVersion, 46)
    }
    
    func test_integration_init_hasTheCorrectClasses() {
        let got = integrationSubject()
        XCTAssertEqual(got?.classes.count, 0)
    }
    
    func test_integration_init_hasTheCorrectBuildFiles() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objects.buildFiles.count, 6)
    }
    
    func test_integration_init_hasTheCorrectAggregateTargets() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objects.aggregateTargets.count, 0)
    }
    
    func test_integration_init_hasTheCorrectContainerItemProxies() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objects.containerItemProxies.count, 1)
    }
    
    func test_integration_init_hasTheCorrectCopyFilesBuildPhases() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objects.copyFilesBuildPhases.count, 1)
    }
    
    func test_integration_init_hasTheCorrectGroups() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objects.groups.count, 4)
    }
    
    func test_integration_init_hasTheCorrectFileElements() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objects.fileElements.count, 0)
    }
    
    func test_integration_init_hasTheCorrectConfigurationLists() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objects.configurationLists.count, 3)
    }
    
    func test_integration_init_hasTheCorrectBuildConfigurations() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objects.buildConfigurations.count, 6)
    }
    
    func test_integration_init_hasTheCorrectVariantGroups() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objects.variantGroups.count, 2)
    }
    
    func test_integration_init_hasTheCorrectTargetDependencies() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objects.targetDependencies.count, 1)
    }
    
    func test_integration_init_hasTheCorrectSourcesBuildPhases() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objects.sourcesBuildPhases.count, 2)
    }
    
    func test_integration_init_hasTheCorrectShellScriptBuildPhases() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objects.shellScriptBuildPhases.count, 1)
    }
    
    func test_integration_init_hasTheCorrectResourcesBuildPhases() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objects.resourcesBuildPhases.count, 2)
    }
    
    func test_integration_init_hasTheCorrectFrameworksBuildPhases() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objects.frameworksBuildPhases.count, 2)
    }
    
    func test_integration_init_hasTheCorrectHeadersBuildPhases() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objects.headersBuildPhases.count, 1)
    }
    
    func test_integration_init_hasTheCorrectNativeTargets() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objects.nativeTargets.count, 2)
    }
    
    func test_integration_init_hasTheCorrectFileReferences() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objects.fileReferences.count, 10)
    }
    
    func test_integration_init_hasTheCorrectProjects() {
        let got = integrationSubject()
        XCTAssertEqual(got?.objects.projects.count, 1)
    }
    
    private func integrationSubject() -> PBXProj? {
        let fixtures = Path(#file).parent().parent().parent() + Path("Fixtures")
        let path = fixtures + Path("iOS/Project.xcodeproj/project.pbxproj")
        return try? PBXProj(path: path)
    }
    
}
