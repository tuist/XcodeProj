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

    func test_init_failsIfTheFileTypeIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "fileType")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXReferenceProxy.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_init_failsIfThePathIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "path")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXReferenceProxy.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_init_failsIfTheRemoteRefIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "remoteRef")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXReferenceProxy.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_init_failsIfTheSourceTreeIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "sourceTree")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXReferenceProxy.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
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
