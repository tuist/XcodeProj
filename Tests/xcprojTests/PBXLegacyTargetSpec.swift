import Foundation
import XCTest
@testable import xcproj

final class PBXLegacyTargetSpec: XCTestCase {
    
    var subject: PBXLegacyTarget!
    
    override func setUp() {
        super.setUp()
        subject = PBXLegacyTarget(name: "name",
                                  buildToolPath: "/usr/bin/true",
                                  buildArgumentsString: "hello world",
                                  passBuildSettingsInEnvironment: false,
                                  buildWorkingDirectory: "/home/xcodeuser",
                                  buildConfigurationList: "list",
                                  buildPhases: ["phase"],
                                  buildRules: ["rule"],
                                  dependencies: ["dependency"],
                                  productName: "productname",
                                  productReference: "productreference",
                                  productType: .application)
    }
    
    func test_plistReturnsTheRightValue() throws {
        let expected = PlistValue.dictionary([
            "buildToolPath": "/usr/bin/true",
            "buildArgumentsString": "hello world",
            "passBuildSettingsInEnvironment": "0",
            "buildWorkingDirectory": "/home/xcodeuser"
        ]).dictionary!
        
        let plistDict = subject.plistValues(proj: PBXProj.testData(), isa: PBXLegacyTarget.isa, reference: "ref").value.dictionary!
        
        (["buildToolPath",
          "buildArgumentsString",
          "passBuildSettingsInEnvironment",
          "buildWorkingDirectory"] as [CommentedString]).forEach {
            XCTAssertEqual(plistDict[$0]!, expected[$0]!)
        }
    }
}
