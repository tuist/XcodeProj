import Foundation
import XCTest
import xcproj

class PBXSourcesBuildPhaseSpec: XCTestCase {

    var subject: PBXSourcesBuildPhase!

    override func setUp() {
        super.setUp()
        self.subject = PBXSourcesBuildPhase(reference: "reference", files: ["file"])
    }

    func test_init_initializesThePropertiesCorrectly() {
        XCTAssertEqual(subject.reference, "reference")
        XCTAssertEqual(subject.buildActionMask, PBXBuildPhase.defaultBuildActionMask)
        XCTAssertEqual(subject.files, ["file"])
        XCTAssertNil(subject.runOnlyForDeploymentPostprocessing)
    }

    func test_itHasTheCorrectIsa() {
        XCTAssertEqual(PBXSourcesBuildPhase.isa, "PBXSourcesBuildPhase")
    }

    func test_equals_returnsTheCorrectValue() {
        let one = PBXSourcesBuildPhase(reference: "refrence", files: ["file"])
        let another =  PBXSourcesBuildPhase(reference: "refrence", files: ["file"])
        XCTAssertEqual(one, another)
    }

    func test_hashValue_returnsTheReferenceHashValue() {
        XCTAssertEqual(subject.hashValue, subject.reference.hashValue)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "files": ["file"],
            "reference": "reference"
        ]
    }
}
