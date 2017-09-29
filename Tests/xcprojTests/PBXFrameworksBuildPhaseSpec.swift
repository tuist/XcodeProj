import Foundation
import XCTest
import xcproj

final class PBXFrameworksBuildPhaseSpec: XCTestCase {

    var subject: PBXFrameworksBuildPhase!

    override func setUp() {
        super.setUp()
        subject = PBXFrameworksBuildPhase(reference: "ref",
                                          files: ["33"],
                                          runOnlyForDeploymentPostprocessing: 0)
    }

    func test_isa_returnsTheRightValue() {
        XCTAssertEqual(PBXFrameworksBuildPhase.isa, "PBXFrameworksBuildPhase")
    }

    func test_init_initializesTheBuildPhaseWithTheCorrectAttributes() {
        XCTAssertEqual(subject.reference, "ref")
        XCTAssertEqual(subject.files, ["33"])
        XCTAssertEqual(subject.runOnlyForDeploymentPostprocessing, 0)
    }

    func test_init_fails_whenTheFilesAreMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "files")
        do {
            _ = try PBXFrameworksBuildPhase(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_init_fails_whenTheRunOnlyForDeploymentPostProcessingIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "runOnlyForDeploymentPostprocessing")
        do {
            _ = try PBXFrameworksBuildPhase(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_equals_returnsTheCorrectValue() {
        let another = PBXFrameworksBuildPhase(reference: "ref",
                                              files: ["33"],
                                              runOnlyForDeploymentPostprocessing: 0)
        XCTAssertEqual(subject, another)
    }

    func test_hashValue_returnsTheReferenceHashValue() {
        XCTAssertEqual(subject.hashValue, subject.reference.hashValue)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "files": ["file1"],
            "runOnlyForDeploymentPostprocessing": 0
        ]
    }
}
