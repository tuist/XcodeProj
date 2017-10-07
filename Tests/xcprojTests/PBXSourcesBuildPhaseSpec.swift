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
        XCTAssertEqual(subject.buildActionMask, 2147483647)
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

    func test_init_setsTheCorrectDefaultValue_whenFilesIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "files")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXResourcesBuildPhase.self, from: data)
        XCTAssertEqual(subject.files, [])
    }


    private func testDictionary() -> [String: Any] {
        return [
            "files": ["file"],
            "reference": "reference"
        ]
    }
}
