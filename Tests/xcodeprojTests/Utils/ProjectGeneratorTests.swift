import Foundation
import XCTest

@testable import XcodeProj

final class ReferenceGeneratorTests: XCTestCase {
    
    var subject: ReferenceGenerator!
    var pbxproj: PBXProj!
    
    override func setUp() {
        super.setUp()
        let settings = PBXOutputSettings(projFileListOrder: .byFilename,
                                         projNavigatorFileOrder: .byFilename,
                                         projBuildPhaseFileOrder: .byFilename,
                                         projReferenceFormat: .xcode)
        subject = ReferenceGenerator(outputSettings: settings)
        pbxproj = PBXProj()
    }
    func test_generateReferences() throws {
        // Given
        let buildConfigurationList = XCConfigurationList.init(buildConfigurations: [],
                                                         defaultConfigurationName: "Debug")
        let mainGroup = PBXGroup()
        let project = PBXProject(name: "Project",
                                 buildConfigurationList: buildConfigurationList, compatibilityVersion: "",
                                 mainGroup: mainGroup)

        pbxproj.add(object: buildConfigurationList)
        pbxproj.add(object: mainGroup)
        pbxproj.add(object: project)
        pbxproj.rootObject = project
        
        // When
        try subject.generateReferences(proj: pbxproj)
        
        // Then
        XCTAssertFalse(project.reference.temporary)
        XCTAssertFalse(mainGroup.reference.temporary)
        XCTAssertFalse(buildConfigurationList.reference.temporary)

        XCTAssertEqual(24, project.reference.value.count)
        XCTAssertEqual(24, mainGroup.reference.value.count)
        XCTAssertEqual(24, buildConfigurationList.reference.value.count)
    }
    
}
