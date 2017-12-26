import Foundation
import XCTest

@testable import xcproj

final class PBXHeadersBuildPhaseSpec: XCTestCase {

    var subject: PBXHeadersBuildPhase!

    override func setUp() {
        super.setUp()
        subject = PBXHeadersBuildPhase(files: ["333"],
                                       buildActionMask: 0,
                                       runOnlyForDeploymentPostprocessing: 0)
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXHeadersBuildPhase.isa, "PBXHeadersBuildPhase")
    }

    func test_init_initializesTheBuildPhaseWithTheRightAttributes() {
        XCTAssertEqual(subject.buildActionMask, 0)
        XCTAssertEqual(subject.files, ["333"])
        XCTAssertEqual(subject.runOnlyForDeploymentPostprocessing, 0)
    }

    func test_init_failsWhenTheBuildActionMaskIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildActionMask")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXHeadersBuildPhase.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_init_failWhenFilesIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "files")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXHeadersBuildPhase.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_init_failsWhenRunOnlyForDeploymentPostProcessingIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "runOnlyForDeploymentPostprocessing")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXHeadersBuildPhase.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_equals_returnsTheCorrectValue() {
        let another = PBXHeadersBuildPhase(files: ["333"],
                                           buildActionMask: 0,
                                           runOnlyForDeploymentPostprocessing: 0)
        XCTAssertEqual(subject, another)
    }

    func test_isHeader_returnsTheCorrectValue() {
        XCTAssertTrue(PBXHeadersBuildPhase.isHeader(fileExtension: "h"))
        XCTAssertTrue(PBXHeadersBuildPhase.isHeader(fileExtension: "hh"))
        XCTAssertTrue(PBXHeadersBuildPhase.isHeader(fileExtension: "hpp"))
        XCTAssertTrue(PBXHeadersBuildPhase.isHeader(fileExtension: "ipp"))
        XCTAssertTrue(PBXHeadersBuildPhase.isHeader(fileExtension: "tpp"))
        XCTAssertTrue(PBXHeadersBuildPhase.isHeader(fileExtension: "hxx"))
        XCTAssertTrue(PBXHeadersBuildPhase.isHeader(fileExtension: "def"))
        XCTAssertFalse(PBXHeadersBuildPhase.isHeader(fileExtension: "uuu"))
    }

    private func testDictionary() -> [String: Any] {
        return [
            "buildActionMask": 3,
            "files": ["file"],
            "runOnlyForDeploymentPostprocessing": 2,
            "reference": "reference"
        ]
    }
}
