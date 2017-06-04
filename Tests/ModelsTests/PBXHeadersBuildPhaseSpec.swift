import Foundation
import XCTest

@testable import xcodeproj

final class PBXHeadersBuildPhaseSpec: XCTestCase {
    
    var subject: PBXHeadersBuildPhase!
    
    override func setUp() {
        super.setUp()
        subject = PBXHeadersBuildPhase(reference: "ref",
                                       buildActionMask: 0,
                                       files: Set(arrayLiteral: "333"),
                                       runOnlyForDeploymentPostprocessing: 0)
    }
    
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXHeadersBuildPhase.isa, "PBXHeadersBuildPhase")
    }
    
    func test_init_initializesTheBuildPhaseWithTheRightAttributes() {
        XCTAssertEqual(subject.reference, "ref")
        XCTAssertEqual(subject.buildActionMask, 0)
        XCTAssertEqual(subject.files, Set(arrayLiteral: "333"))
        XCTAssertEqual(subject.runOnlyForDeploymentPostprocessing, 0)
    }
    
    func test_init_failsWhenTheBuildActionMaskIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildActionMask")
        do {
            _ = try PBXHeadersBuildPhase(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failWhenFilesIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "files")
        do {
            _ = try PBXHeadersBuildPhase(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsWhenRunOnlyForDeploymentPostProcessingIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "runOnlyForDeploymentPostprocessing")
        do {
            _ = try PBXHeadersBuildPhase(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_equals_returnsTheCorrectValue() {
        let another = PBXHeadersBuildPhase(reference: "ref",
                                           buildActionMask: 0,
                                           files: Set(arrayLiteral: "333"),
                                           runOnlyForDeploymentPostprocessing: 0)
        XCTAssertEqual(subject, another)
    }
    
    func test_addingFile_returnsANewBuildPhaseWithTheFileAdded() {
        let got = subject.adding(file: "555")
        XCTAssertTrue(got.files.contains("555"))
    }
    
    func test_removingFile_returnsANewBuildPhaseWiththeFileRemoved() {
        let got = subject.removing(file: "333")
        XCTAssertFalse(got.files.contains("333"))
    }
    
    func test_hashValue_returnsTheReferenceHashValue() {
        XCTAssertEqual(subject.hashValue, subject.reference.hashValue)
    }
    
    private func testDictionary() -> [String: Any] {
        return [
            "buildActionMask": 3,
            "files": ["file"],
            "runOnlyForDeploymentPostprocessing": 2
        ]
    }
}
