import Foundation
import XcodeProj
import XCTest

final class PBXBuildRuleTests: XCTestCase {
    var subject: PBXBuildRule!

    override func setUp() {
        super.setUp()
        subject = PBXBuildRule(compilerSpec: "spec",
                               fileType: "type",
                               isEditable: true,
                               filePatterns: "pattern",
                               name: "rule",
                               outputFiles: ["a", "b"],
                               outputFilesCompilerFlags: ["-1", "-2"],
                               script: "script",
                               runOncePerArchitecture: false)
    }

    func test_init_initializesTheBuildRuleWithTheRightAttributes() {
        XCTAssertEqual(subject.compilerSpec, "spec")
        XCTAssertEqual(subject.filePatterns, "pattern")
        XCTAssertEqual(subject.fileType, "type")
        XCTAssertEqual(subject.isEditable, true)
        XCTAssertEqual(subject.name, "rule")
        XCTAssertEqual(subject.outputFiles, ["a", "b"])
        XCTAssertEqual(subject.outputFilesCompilerFlags ?? [], ["-1", "-2"])
        XCTAssertEqual(subject.script, "script")
        XCTAssertEqual(subject.runOncePerArchitecture, false)
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXBuildRule.isa, "PBXBuildRule")
    }

    func test_equal_shouldReturnTheCorrectValue() {
        let another = PBXBuildRule(compilerSpec: "spec",
                                   fileType: "type",
                                   isEditable: true,
                                   filePatterns: "pattern",
                                   name: "rule",
                                   outputFiles: ["a", "b"],
                                   outputFilesCompilerFlags: ["-1", "-2"],
                                   script: "script",
                                   runOncePerArchitecture: false)
        XCTAssertEqual(subject, another)
    }
}
