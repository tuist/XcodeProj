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
        XCTAssertNil(subject.buildActionMask)
        XCTAssertEqual(subject.files, ["file"])
        XCTAssertEqual(subject.runOnlyForDeploymentPostprocessing, 0)
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

    func test_init_failsIfFilesAreMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "files")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXResourcesBuildPhase.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }


    private func testDictionary() -> [String: Any] {
        return [
            "files": ["file"],
            "reference": "reference"
        ]
    }
}
