import Foundation
import XcodeProj
import XCTest

final class PBXResourcesBuildPhaseTests: XCTestCase {
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXResourcesBuildPhase.isa, "PBXResourcesBuildPhase")
    }

    private func testDictionary() -> [String: Any] {
        return [
            "files": ["file1"],
            "buildActionMask": "333",
            "runOnlyForDeploymentPostprocessing": "3",
        ]
    }
}
