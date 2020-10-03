import Foundation
import XCTest
@testable import XcodeProj

final class PBXShellScriptBuildPhaseTests: XCTestCase {
    func test_returnsTheCorrectIsa() {
        XCTAssertEqual(PBXShellScriptBuildPhase.isa, "PBXShellScriptBuildPhase")
    }

    func test_write_showEnvVarsInLog() throws {
        let show = PBXShellScriptBuildPhase(showEnvVarsInLog: true)
        let doNotShow = PBXShellScriptBuildPhase(showEnvVarsInLog: false)
        let proj = PBXProj.fixture()

        let (_, showPlistValue) = try show.plistKeyAndValue(proj: proj, reference: "ref")
        let (_, doNotShowPlistValue) = try doNotShow.plistKeyAndValue(proj: proj, reference: "ref")

        if case let PlistValue.dictionary(showDictionary) = showPlistValue,
            case let PlistValue.dictionary(doNotShowDictionary) = doNotShowPlistValue {
            XCTAssertNil(showDictionary["showEnvVarsInLog"])
            XCTAssertEqual(doNotShowDictionary["showEnvVarsInLog"]?.string, "0")
        } else {
            XCTAssert(false)
        }
    }

    func test_write_alwaysOutOfDate() throws {
        // Given
        let alwaysOutOfDateNotPresent = PBXShellScriptBuildPhase()
        let alwaysOutOfDateFalse = PBXShellScriptBuildPhase(alwaysOutOfDate: false)
        let alwaysOutOfDateTrue = PBXShellScriptBuildPhase(alwaysOutOfDate: true)
        let proj = PBXProj.fixture()

        // When
        guard
            case let .dictionary(valuesWhenNotPresent) = try alwaysOutOfDateNotPresent.plistKeyAndValue(proj: proj, reference: "ref").value,
            case let .dictionary(valuesWhenFalse) = try alwaysOutOfDateFalse.plistKeyAndValue(proj: proj, reference: "ref").value,
            case let .dictionary(valuesWhenTrue) = try alwaysOutOfDateTrue.plistKeyAndValue(proj: proj, reference: "ref").value else {
            XCTFail("Plist should contain dictionary")
            return
        }

        // Then
        XCTAssertFalse(valuesWhenNotPresent.keys.contains("alwaysOutOfDate"))
        XCTAssertFalse(valuesWhenFalse.keys.contains("alwaysOutOfDate"))
        XCTAssertEqual(valuesWhenTrue["alwaysOutOfDate"], "1")
    }

    private func testDictionary() -> [String: Any] {
        [
            "files": ["files"],
            "inputPaths": ["input"],
            "outputPaths": ["output"],
            "shellPath": "shellPath",
            "shellScript": "shellScript",
        ]
    }
}
