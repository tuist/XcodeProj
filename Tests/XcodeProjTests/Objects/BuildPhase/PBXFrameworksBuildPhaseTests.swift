import Foundation
import XCTest
@testable import XcodeProj

final class PBXFrameworksBuildPhaseTests: XCTestCase {
    func test_isa_returnsTheRightValue() {
        XCTAssertEqual(PBXFrameworksBuildPhase.isa, "PBXFrameworksBuildPhase")
    }

    func test_init_fails_whenTheFilesAreMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "files")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = XcodeprojJSONDecoder()
        do {
            let phase = try decoder.decode(PBXCopyFilesBuildPhase.self, from: data)
            XCTAssertNil(phase.files, "Expected files to be nil but it's present")
        } catch {}
    }

    private func testDictionary() -> [String: Any] {
        [
            "files": ["file1"],
            "runOnlyForDeploymentPostprocessing": 0,
            "reference": "reference",
        ]
    }
}
