import Foundation
import XCTest

import xcproj

final class XCBuildConfigurationSpec: XCTestCase {

    var subject: XCBuildConfiguration!

    override func setUp() {
        super.setUp()
        subject = XCBuildConfiguration(name: "Debug",
                                       baseConfigurationReference: "base",
                                       buildSettings: ["name": "value"])
    }

    func test_init_initializesTheEntityProperly() {
        let subject = XCBuildConfiguration(name: "name", baseConfigurationReference: "build_reference", buildSettings: [:])
        XCTAssertEqual(subject.name, "name")
        XCTAssertEqual(subject.baseConfigurationReference, "build_reference")
        XCTAssertEqual(subject.buildSettings as! [String: String], [:])
    }

    func test_initFails_ifNameIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "name")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(XCBuildConfiguration.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_isa_hasTheCorrectValue() {
        XCTAssertEqual(XCBuildConfiguration.isa, "XCBuildConfiguration")
    }

    func test_equals_returnsTheCorrectValue() {
        let one = XCBuildConfiguration(name: "name", baseConfigurationReference: "config_reference", buildSettings: ["a": "b"])
        let another = XCBuildConfiguration(name: "name", baseConfigurationReference: "config_reference", buildSettings: ["a": "b"])
        XCTAssertEqual(one, another)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "baseConfigurationReference": "baseConfigurationReference",
            "buildSettings": [:],
            "name": "name",
            "reference": "reference"
        ]
    }

}
