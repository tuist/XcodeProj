import Foundation
import XCTest

@testable import xcodeproj

final class XCBuildConfigurationSpec: XCTestCase {
    
    var subject: XCBuildConfiguration!
    
    override func setUp() {
        super.setUp()
        subject = XCBuildConfiguration(reference: "reference",
                                       baseConfigurationReference: nil,
                                       buildSettings: ["name": "value"],
                                       name: "Debug")
    }
    
    func test_addingBuildSetting_returnsABuildConfigurationWithTheSettingAdded() {
        let got = subject.addingBuild(setting: "name2", value: "value2")
        XCTAssertEqual(got.buildSettings["name2"], "value2")
    }
    
    func test_removingBuildSetting_returnsABuildConfigurationWithTheSettingRemoved() {
        let got = subject.removingBuild(setting: "name")
        XCTAssertNil(got.buildSettings["name"])
    }
    
    func test_isa_hasTheCorrectValue() {
        XCTAssertEqual(subject.isa, "XCBuildConfiguration")
    }
    
}
