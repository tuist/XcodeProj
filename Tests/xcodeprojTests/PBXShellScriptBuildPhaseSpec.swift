import Foundation
@testable import xcodeproj
import XCTest

final class PBXShellScriptBuildPhaseSpec: XCTestCase {
    var subject: PBXShellScriptBuildPhase!

    override func setUp() {
        super.setUp()
        subject = PBXShellScriptBuildPhase(files: ["file"], name: "name", inputPaths: ["input"], outputPaths: ["output"], shellPath: "shell", shellScript: "script")
    }

    func test_init_initializesTheBuildPhaseWithTheCorrectValues() {
        XCTAssertEqual(subject.files, ["file"])
        XCTAssertEqual(subject.name, "name")
        XCTAssertEqual(subject.inputPaths, ["input"])
        XCTAssertEqual(subject.outputPaths, ["output"])
        XCTAssertEqual(subject.shellPath, "shell")
        XCTAssertEqual(subject.shellScript, "script")
    }

    func test_returnsTheCorrectIsa() {
        XCTAssertEqual(PBXShellScriptBuildPhase.isa, "PBXShellScriptBuildPhase")
    }

    func test_equals_returnsTheCorrectValue() {
        let one = PBXShellScriptBuildPhase(files: ["file"], name: "name", inputPaths: ["input"], outputPaths: ["output"], shellPath: "shell", shellScript: "script")
        let another = PBXShellScriptBuildPhase(files: ["file"], name: "name", inputPaths: ["input"], outputPaths: ["output"], shellPath: "shell", shellScript: "script")
        XCTAssertEqual(one, another)
    }

    func test_write_showEnvVarsInLog() {
        let show = PBXShellScriptBuildPhase(showEnvVarsInLog: true)
        let doNotShow = PBXShellScriptBuildPhase(showEnvVarsInLog: false)

        let proj = PBXProj(rootObject: "rootObject",
                           objectVersion: 48,
                           objects: [
                               "show": show,
                               "doNotShow": doNotShow,
        ])

        let (_, showPlistValue) = show.plistKeyAndValue(proj: proj, reference: "ref")
        let (_, doNotShowPlistValue) = doNotShow.plistKeyAndValue(proj: proj, reference: "ref")

        if case let PlistValue.dictionary(showDictionary) = showPlistValue,
            case let PlistValue.dictionary(doNotShowDictionary) = doNotShowPlistValue {
            XCTAssertNil(showDictionary["showEnvVarsInLog"])
            XCTAssertEqual(doNotShowDictionary["showEnvVarsInLog"]?.string, "0")
        } else {
            XCTAssert(false)
        }
    }

    private func testDictionary() -> [String: Any] {
        return [
            "files": ["files"],
            "inputPaths": ["input"],
            "outputPaths": ["output"],
            "shellPath": "shellPath",
            "shellScript": "shellScript",
        ]
    }
}
