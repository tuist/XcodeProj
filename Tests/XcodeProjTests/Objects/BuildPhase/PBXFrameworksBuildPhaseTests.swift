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
            _ = try decoder.decode(PBXFrameworksBuildPhase.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
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
