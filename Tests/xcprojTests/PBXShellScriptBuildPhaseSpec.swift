import Foundation
import XCTest
import xcproj

final class PBXShellScriptBuildPhaseSpec: XCTestCase {

    var subject: PBXShellScriptBuildPhase!

    override func setUp() {
        super.setUp()
        self.subject = PBXShellScriptBuildPhase(files: ["file"], name: "name", inputPaths: ["input"], outputPaths: ["output"], shellPath: "shell", shellScript: "script")
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

    private func testDictionary() -> [String: Any] {
        return [
            "files": ["files"],
            "inputPaths": ["input"],
            "outputPaths": ["output"],
            "shellPath": "shellPath",
            "shellScript": "shellScript"
        ]
    }
}
