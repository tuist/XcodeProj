import Foundation
import Testing
@testable import XcodeProj

struct BuildFileSettingTests {
    @Test func test_BuildSettings_encodes_to_JSON() async throws {
        let expectedJSON = #"{"one":"one","two":["two","two"]}"#

        let settings: [String: BuildFileSetting] = [
            "one": .string("one"),
            "two": .array(["two", "two"]),
        ]

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        let result = try encoder.encode(settings)

        #expect(result == expectedJSON.data(using: .utf8))
    }

    @Test func test_buildSettings_decodes_from_JSON() async throws {
        let json = #"{"one":"one","two":["two","two"]}"#

        let expectedSettings: [String: BuildFileSetting] = [
            "one": .string("one"),
            "two": .array(["two", "two"]),
        ]

        let result = try JSONDecoder().decode([String: BuildFileSetting].self, from: json.data(using: .utf8)!)

        #expect(result == expectedSettings)
    }
}
