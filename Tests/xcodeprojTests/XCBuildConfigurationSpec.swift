import Foundation
import XCTest

@testable import xcodeproj

final class XCBuildConfigurationSpec: XCTestCase {
    
    var subject: XCBuildConfiguration!
    
    override func setUp() {
        super.setUp()
        subject = XCBuildConfiguration(reference: "reference",
                                       name: "Debug",
                                       baseConfigurationReference: "base",
                                       buildSettings: ["name": "value"])
    }
    
    func test_init_initializesTheEntityProperly() {
        let subject = XCBuildConfiguration(reference: "reference", name: "name", baseConfigurationReference: "build_reference", buildSettings: [:])
        XCTAssertEqual(subject.reference, "reference")
        XCTAssertEqual(subject.name, "name")
        XCTAssertEqual(subject.baseConfigurationReference, "build_reference")
        XCTAssertEqual(subject.buildSettings as! [String: String], [:])
    }
    
    func test_initFails_ifNameIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "name")
        do {
            _ = try XCBuildConfiguration(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didnt' throw any")
        } catch {}
    }
    
    func test_addingBuildSetting_returnsABuildConfigurationWithTheSettingAdded() {
        let got = subject.addingBuild(setting: "name2", value: "value2")
        XCTAssertEqual(got.buildSettings["name2"] as! String, "value2")
    }
    
    func test_removingBuildSetting_returnsABuildConfigurationWithTheSettingRemoved() {
        let got = subject.removingBuild(setting: "name")
        XCTAssertNil(got.buildSettings["name"])
    }
    
    func test_isa_hasTheCorrectValue() {
        XCTAssertEqual(subject.isa, "XCBuildConfiguration")
    }
    
    private func testDictionary() -> [String: Any] {
        return [
            "baseConfigurationReference": "baseConfigurationReference",
            "buildSettings": [:],
            "name": "name"
        ]
    }
    
}
