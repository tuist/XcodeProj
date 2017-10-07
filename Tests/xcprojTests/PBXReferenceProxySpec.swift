import Foundation
import XCTest
import xcproj

final class PBXReferenceProxySpec: XCTestCase {

    var subject: PBXReferenceProxy!

    override func setUp() {
        super.setUp()
        self.subject = PBXReferenceProxy(reference: "ref",
                                         fileType: "fileType",
                                         path: "path",
                                         remoteRef: "remoteRef",
                                         sourceTree: .absolute)
    }

    func test_init_initializesTheModelWithTheCorrectAttributes() {
        XCTAssertEqual(subject.reference, "ref")
        XCTAssertEqual(subject.fileType, "fileType")
        XCTAssertEqual(subject.path, "path")
        XCTAssertEqual(subject.remoteRef, "remoteRef")
        XCTAssertEqual(subject.sourceTree, .absolute)
    }

    func test_init_setsTheCorrectDefaultValue_whenFileTypeIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "fileType")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXReferenceProxy.self, from: data)
        XCTAssertEqual(subject.fileType, "")
    }

    func test_init_setsTheCorrectDefaultValue_whenPathIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "path")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXReferenceProxy.self, from: data)
        XCTAssertEqual(subject.path, "")
    }

    func test_init_setsTheCorrectDefaultValue_whenRemoteRefIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "remoteRef")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXReferenceProxy.self, from: data)
        XCTAssertEqual(subject.remoteRef, "")
    }

    func test_init_setsTheCorrectDefaultValue_whenSourceTreeIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "sourceTree")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXReferenceProxy.self, from: data)
        XCTAssertEqual(subject.sourceTree, .none)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "fileType": "fileType",
            "path": "path",
            "remoteRef": "remoteRef",
            "sourceTree": "<absolute>",
            "reference": "reference"
        ]
    }
}
