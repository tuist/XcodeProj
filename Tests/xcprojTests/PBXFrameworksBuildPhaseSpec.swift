import Foundation
import XCTest
import xcproj

final class PBXFrameworksBuildPhaseSpec: XCTestCase {

    var subject: PBXFrameworksBuildPhase!

    override func setUp() {
        super.setUp()
        subject = PBXFrameworksBuildPhase(files: ["33"],
                                          runOnlyForDeploymentPostprocessing: 0)
    }

    func test_isa_returnsTheRightValue() {
        XCTAssertEqual(PBXFrameworksBuildPhase.isa, "PBXFrameworksBuildPhase")
    }

    func test_init_initializesTheBuildPhaseWithTheCorrectAttributes() {
        XCTAssertEqual(subject.files, ["33"])
        XCTAssertEqual(subject.runOnlyForDeploymentPostprocessing, 0)
    }

    func test_init_fails_whenTheFilesAreMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "files")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXFrameworksBuildPhase.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_equals_returnsTheCorrectValue() {
        let another = PBXFrameworksBuildPhase(files: ["33"],
                                              runOnlyForDeploymentPostprocessing: 0)
        XCTAssertEqual(subject, another)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "files": ["file1"],
            "runOnlyForDeploymentPostprocessing": 0,
            "reference": "reference"
        ]
    }
}
