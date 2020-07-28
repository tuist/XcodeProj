import Foundation
import XCTest
@testable import XcodeProj

final class XCBuildConfigurationTests: XCTestCase {
    func test_initFails_ifNameIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "name")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = XcodeprojJSONDecoder()
        do {
            _ = try decoder.decode(XCBuildConfiguration.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_isa_hasTheCorrectValue() {
        XCTAssertEqual(XCBuildConfiguration.isa, "XCBuildConfiguration")
    }

    func test_append_when_theSettingDoesntExist() {
        // Given
        let subject = XCBuildConfiguration(name: "Debug",
                                           baseConfiguration: nil,
                                           buildSettings: [:])

        // When
        subject.append(setting: "PRODUCT_NAME", value: "$(TARGET_NAME:c99extidentifier)")

        // Then
        XCTAssertEqual(subject.buildSettings["PRODUCT_NAME"] as? String, "$(inherited) $(TARGET_NAME:c99extidentifier)")
    }

    func test_append_when_theSettingExists() {
        // Given
        let subject = XCBuildConfiguration(name: "Debug",
                                           baseConfiguration: nil,
                                           buildSettings: ["OTHER_LDFLAGS": "flag1"])

        // When
        subject.append(setting: "OTHER_LDFLAGS", value: "flag2")

        // Then
        XCTAssertEqual(subject.buildSettings["OTHER_LDFLAGS"] as? String, "flag1 flag2")
    }

    func test_append_when_duplicateSettingExists() {
        // Given
        let subject = XCBuildConfiguration(name: "Debug",
                                           baseConfiguration: nil,
                                           buildSettings: ["OTHER_LDFLAGS": "flag1"])

        // When
        subject.append(setting: "OTHER_LDFLAGS", value: "flag1")

        // Then
        XCTAssertEqual(subject.buildSettings["OTHER_LDFLAGS"] as? String, "flag1")
    }

    func test_append_removesDuplicates_when_theSettingIsAnArray() {
        // Given
        let subject = XCBuildConfiguration(name: "Debug",
                                           baseConfiguration: nil,
                                           buildSettings: [
                                               "OTHER_LDFLAGS": ["flag1", "flag2"],
                                           ])

        // When
        subject.append(setting: "OTHER_LDFLAGS", value: "flag1")

        // Then
        XCTAssertEqual(subject.buildSettings["OTHER_LDFLAGS"] as? [String], ["flag1", "flag2"])
    }

    func test_append_when_theSettingExistsAsAnArray() {
        // Given
        let subject = XCBuildConfiguration(name: "Debug",
                                           baseConfiguration: nil,
                                           buildSettings: ["OTHER_LDFLAGS": ["flag1", "flag2"]])

        // When
        subject.append(setting: "OTHER_LDFLAGS", value: "flag3")

        // Then
        XCTAssertEqual(subject.buildSettings["OTHER_LDFLAGS"] as? [String], ["flag1", "flag2", "flag3"])
    }

    private func testDictionary() -> [String: Any] {
        [
            "baseConfigurationReference": "baseConfigurationReference",
            "buildSettings": [:],
            "name": "name",
            "reference": "reference",
        ]
    }
}
