import XCTest
@testable import XcodeProj

final class BuildSettingTests: XCTestCase {
    func test_BuildSettings_Encode_to_JSON() throws {
        let expectedJSON = #"{"one":"one","two":["two","two"]}"#

        let settings: BuildSettings = [
            "one": .string("one"),
            "two": .array(["two", "two"]),
        ]

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        let result = try encoder.encode(settings)

        XCTAssertEqual(result, expectedJSON.data(using: .utf8))
    }

    func test_buildSettings_decodes_from_JSON() throws {
        let json = #"{"one":"one","two":["two","two"]}"#

        let expectedSettings: BuildSettings = [
            "one": .string("one"),
            "two": .array(["two", "two"]),
        ]

        let result = try JSONDecoder().decode(BuildSettings.self, from: json.data(using: .utf8)!)

        XCTAssertEqual(result, expectedSettings)
    }
}
