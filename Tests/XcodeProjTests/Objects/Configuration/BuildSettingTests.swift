import Foundation
import Testing
@testable import XcodeProj

struct BuildSettingTests {
    @Test func test_BuildSettings_encode_to_string() async throws {
        #expect(BuildSetting.string("one").description == "one")
        #expect(BuildSetting.array(["one", "two"]).description == "one two")
    }

    @Test func test_buildSettings_decodes_from_JSON() async throws {
        let json = #"{"one":"one","two":["two","two"]}"#

        let expectedSettings: BuildSettings = [
            "one": .string("one"),
            "two": .array(["two", "two"]),
        ]

        let result = try JSONDecoder().decode(BuildSettings.self, from: json.data(using: .utf8)!)

        #expect(result == expectedSettings)
    }

    @Test func test_buildSettings_bool_conversion() async throws {
        let settings: [BuildSetting] = [
            BuildSetting.string("YES"),
            BuildSetting.string("NO"),
            BuildSetting.string("tuist"),
            BuildSetting.string("No"),
            BuildSetting.string("yES"),
            BuildSetting.array(["YES", "yES"]),
            true,
            false,
        ]

        let expected: [Bool?] = [
            true,
            false,
            nil,
            nil,
            nil,
            nil,
            true,
            false,
        ]

        #expect(settings.map(\.boolValue) == expected)
    }
}
