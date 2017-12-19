import Foundation
import XCTest
import xcproj

final class PBXBuildRuleSpec: XCTestCase {

    var subject: PBXBuildRule!

    override func setUp() {
        super.setUp()
        subject = PBXBuildRule(reference: "ref",
                               compilerSpec: "spec",
                               filePatterns: "pattern",
                               fileType: "type",
                               isEditable: 1,
                               name: "rule",
                               outputFiles:["a", "b"],
                               outputFilesCompilerFlags: ["-1", "-2"],
                               script: "script")
    }

    func test_init_initializesTheBuildRuleWithTheRightAttributes() {
        XCTAssertEqual(subject.reference, "ref")
        XCTAssertEqual(subject.compilerSpec, "spec")
        XCTAssertEqual(subject.filePatterns, "pattern")
        XCTAssertEqual(subject.fileType, "type")
        XCTAssertEqual(subject.isEditable, 1)
        XCTAssertEqual(subject.name, "rule")
        XCTAssertEqual(subject.outputFiles, ["a", "b"])
        XCTAssertEqual(subject.outputFilesCompilerFlags ?? [], ["-1", "-2"])
        XCTAssertEqual(subject.script, "script")
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXBuildRule.isa, "PBXBuildRule")
    }

    func test_hashValue_returnsTheReferenceHashValue() {
        XCTAssertEqual(subject.hashValue, subject.reference.hashValue)
    }

    func test_equal_shouldReturnTheCorrectValue() {
        let another = PBXBuildRule(reference: "ref",
                                   compilerSpec: "spec",
                                   filePatterns: "pattern",
                                   fileType: "type",
                                   isEditable: 1,
                                   name: "rule",
                                   outputFiles:["a", "b"],
                                   outputFilesCompilerFlags: ["-1", "-2"],
                                   script: "script")
        XCTAssertEqual(subject, another)
    }
}
