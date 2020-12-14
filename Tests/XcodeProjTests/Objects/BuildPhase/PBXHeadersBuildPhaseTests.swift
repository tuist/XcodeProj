import Foundation
import XCTest
@testable import XcodeProj

final class PBXHeadersBuildPhaseTests: XCTestCase {
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXHeadersBuildPhase.isa, "PBXHeadersBuildPhase")
    }

    func test_init_failsWhenTheBuildActionMaskIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildActionMask")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = XcodeprojJSONDecoder()
        do {
            let phase = try decoder.decode(PBXCopyFilesBuildPhase.self, from: data)
            XCTAssertEqual(phase.buildActionMask, PBXBuildPhase.defaultBuildActionMask, "Expected buildActionMask to be equal to \(PBXBuildPhase.defaultBuildActionMask) but it's \(phase.buildActionMask)")
        } catch {}
    }

    func test_init_failWhenFilesIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "files")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = XcodeprojJSONDecoder()
        do {
            let phase = try decoder.decode(PBXCopyFilesBuildPhase.self, from: data)
            XCTAssertNil(phase.files, "Expected files to be nil but it's present")
        } catch {}
    }

    func test_init_failsWhenRunOnlyForDeploymentPostProcessingIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "runOnlyForDeploymentPostprocessing")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = XcodeprojJSONDecoder()
        do {
            let phase = try decoder.decode(PBXCopyFilesBuildPhase.self, from: data)
            XCTAssertFalse(phase.runOnlyForDeploymentPostprocessing, "Expected runOnlyForDeploymentPostprocessing to default to false")
        } catch {}
    }

    private func testDictionary() -> [String: Any] {
        [
            "buildActionMask": 3,
            "files": ["file"],
            "runOnlyForDeploymentPostprocessing": 2,
            "reference": "reference",
        ]
    }
}
