import Foundation
import XCTest

@testable import xcodeproj

final class PBXShellScriptBuildPhaseSpec: XCTestCase {
    
    var subject: PBXShellScriptBuildPhase!
    
    override func setUp() {
        super.setUp()
        self.subject = PBXShellScriptBuildPhase(reference: "reference", files: ["file"], inputPaths: ["input"], outputPaths: ["output"], shellPath: "shell", shellScript: "script")
    }

    func test_init_initializesTheBuildPhaseWithTheCorrectValues() {
        XCTAssertEqual(subject.reference, "reference")
        XCTAssertEqual(subject.files, ["file"])
        XCTAssertEqual(subject.inputPaths, ["input"])
        XCTAssertEqual(subject.outputPaths, ["output"])
        XCTAssertEqual(subject.shellPath, "shell")
        XCTAssertEqual(subject.shellScript, "script")
    }
    
    func test_returnsTheCorrectIsa() {
        XCTAssertEqual(PBXShellScriptBuildPhase.isa, "PBXShellScriptBuildPhase")
    }
    
    func test_initFails_whenTheFilesAreMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "files")
        do {
            _ = try PBXShellScriptBuildPhase(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didnt'")
        } catch {}
    }
    
    func test_initFails_whenShellPathIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "shellPath")
        do {
            _ = try PBXShellScriptBuildPhase(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didnt'")
        } catch {}
    }
    
    func test_addingFile_returnsABuildPhaseWithTheFileAdded() {
        let got = subject.adding(file: "file2")
        XCTAssertTrue(got.files.contains("file2"))
    }
    
    func test_removingFile_returnsABuildPhaseWithTheFileRemoved() {
        let got = subject.removing(file: "file")
        XCTAssertFalse(got.files.contains("file"))
    }
    
    func test_addingInputFile_returnsABuildPhaseAddingTheInputFile() {
        let got = subject.adding(inputPath: "input2")
        XCTAssertTrue(got.inputPaths.contains("input2"))
    }
    
    func test_removingInputFile_returnsABuildPhaseRemovingTheInputFile() {
        let got = subject.removing(inputPath: "input")
        XCTAssertFalse(got.inputPaths.contains("input"))
    }
    
    func test_addingOutputFile_returnsABuildPhaseAddingTheOutputFile() {
        let got = subject.adding(outputPath: "output2")
        XCTAssertTrue(got.outputPaths.contains("output2"))
    }
    
    func test_removingOutputFile_returnsABuildPhaseRemovingTheOutputFile() {
        let got = subject.removing(outputPath: "output")
        XCTAssertFalse(got.outputPaths.contains("output"))
    }
    
    func test_equals_returnsTheCorrectValue() {
        let one = PBXShellScriptBuildPhase(reference: "reference", files: ["file"], inputPaths: ["input"], outputPaths: ["output"], shellPath: "shell", shellScript: "script")
        let another = PBXShellScriptBuildPhase(reference: "reference", files: ["file"], inputPaths: ["input"], outputPaths: ["output"], shellPath: "shell", shellScript: "script")
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
            "shellScript": "shellScript"
        ]
    }
}
