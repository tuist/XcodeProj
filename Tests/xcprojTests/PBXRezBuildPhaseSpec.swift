import Foundation
import XCTest
import xcproj

final class PBXRezBuildPhaseSpec: XCTestCase {

    var subject: PBXRezBuildPhase!

    override func setUp() {
        super.setUp()
        subject = PBXRezBuildPhase(files: ["123"],
                                   runOnlyForDeploymentPostprocessing: false)
    }

    func test_init_initializesTheBuildPhaseWithTheRightValues() {
        XCTAssertEqual(subject.files, ["123"])
        XCTAssertEqual(subject.runOnlyForDeploymentPostprocessing, false)
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXRezBuildPhase.isa, "PBXRezBuildPhase")
    }

    func test_equals_returnsTheCorrectValue() {
        let another = PBXRezBuildPhase(files: ["123"],
                                             runOnlyForDeploymentPostprocessing: false)
        XCTAssertEqual(subject, another)
    }
}
