import Foundation
import XCTest
import xcproj

final class PBXResourcesBuildPhaseSpec: XCTestCase {

    var subject: PBXResourcesBuildPhase!

    override func setUp() {
        super.setUp()
        subject = PBXResourcesBuildPhase(files: ["333"],
                                         runOnlyForDeploymentPostprocessing: false)
    }

    func test_init_initializesTheBuildPhaseWithTheRightValues() {
        XCTAssertEqual(subject.files, ["333"])
        XCTAssertEqual(subject.runOnlyForDeploymentPostprocessing, false)
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXResourcesBuildPhase.isa, "PBXResourcesBuildPhase")
    }

    func test_equals_returnsTheCorrectValue() {
        let another = PBXResourcesBuildPhase(files: ["333"],
                                             runOnlyForDeploymentPostprocessing: false)
        XCTAssertEqual(subject, another)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "files": ["file1"],
            "buildActionMask": "333",
            "runOnlyForDeploymentPostprocessing": "3"
        ]
    }
}
