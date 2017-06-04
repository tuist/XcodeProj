import Foundation
import XCTest

@testable import xcodeproj

final class PBXFrameworksBuildPhaseSpec: XCTestCase {
    
    var subject: PBXFrameworksBuildPhase!
    
    override func setUp() {
        super.setUp()
        subject = PBXFrameworksBuildPhase(reference: "ref",
                                          files: Set(arrayLiteral: "33"),
                                          runOnlyForDeploymentPostprocessing: 0)
    }
    
    func test_isa_returnsTheRightValue() {
        XCTAssertEqual(PBXFrameworksBuildPhase.isa, "PBXFrameworksBuildPhase")
    }
    
    func test_init_initializesTheBuildPhaseWithTheCorrectAttributes() {
        XCTAssertEqual(subject.reference, "ref")
        XCTAssertEqual(subject.files, Set(arrayLiteral: "33"))
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
    
    func test_addingFile_returnsANewBuildPhaseWithTheFileAdded() {
        let got = subject.adding(file: "222")
        XCTAssertTrue(got.files.contains("222"))
    }
    
    func test_removingFile_returnsANewBuildPhaseWithTheFileRemoved() {
        let got = subject.removing(file: "33")
        XCTAssertFalse(got.files.contains("33"))
    }
    
    func test_equals_returnsTheCorrectValue() {
        let another = PBXFrameworksBuildPhase(reference: "ref",
                                              files: Set(arrayLiteral: "33"),
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
