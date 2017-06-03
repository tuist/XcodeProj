import Foundation
import XCTest
import PathKit

@testable import xcodeproj

final class PBXProjSpec: XCTestCase {
    
    var project: PBXProj!
    
    override func setUp() {
        super.setUp()
        let (path, dictionary) = iosProjectDictionary()
        project = try! PBXProj(path: path, dictionary: dictionary)
    }
    
    func test_initWithDictionary_hasTheCorrectArchiveVersion() {
        XCTAssertEqual(project.archiveVersion, 1)
    }
    
    func test_initWithDictionary_hasTheCorrectObjectVersion() {
        XCTAssertEqual(project.objectVersion, 46)
    }
    
    func test_initWithDictionary_hasTheCorrectClasses() throws {
        XCTAssertTrue(project.classes.isEmpty)
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
