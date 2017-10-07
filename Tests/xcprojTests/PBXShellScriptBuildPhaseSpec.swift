import Foundation
import XCTest
import xcproj

final class PBXShellScriptBuildPhaseSpec: XCTestCase {

    var subject: PBXShellScriptBuildPhase!

    override func setUp() {
        super.setUp()
        self.subject = PBXShellScriptBuildPhase(reference: "reference", files: ["file"], name: "name", inputPaths: ["input"], outputPaths: ["output"], shellPath: "shell", shellScript: "script")
    }

    func test_init_initializesTheBuildPhaseWithTheCorrectValues() {
        XCTAssertEqual(subject.reference, "reference")
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

    func test_initSetsTheCorrectDefaultValue_whenFilesIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "files")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXShellScriptBuildPhase.self, from: data)
        XCTAssertEqual(subject.files, [])
    }
    
    func test_initSetsTheCorrectDefaultValue_whenShellPathIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "shellPath")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXShellScriptBuildPhase.self, from: data)
        XCTAssertEqual(subject.shellPath, "")
    }

    func test_initSetsTheCorrectDefaultValue_whenNameIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "name")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXShellScriptBuildPhase.self, from: data)
        XCTAssertEqual(subject.name, "")
    }

    func test_equals_returnsTheCorrectValue() {
        let one = PBXShellScriptBuildPhase(reference: "reference", files: ["file"], name: "name", inputPaths: ["input"], outputPaths: ["output"], shellPath: "shell", shellScript: "script")
        let another = PBXShellScriptBuildPhase(reference: "reference", files: ["file"], name: "name", inputPaths: ["input"], outputPaths: ["output"], shellPath: "shell", shellScript: "script")
        XCTAssertEqual(one, another)
    }

    func test_hashValue_returnsTheReferenceHashValue() {
        XCTAssertEqual(subject.hashValue, subject.reference.hashValue)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "files": ["files"],
            "inputPaths": ["input"],
            "outputPaths": ["output"],
            "shellPath": "shellPath",
            "shellScript": "shellScript",
            "reference": "reference"
        ]
    }
}
