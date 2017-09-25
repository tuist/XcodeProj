import Foundation
import XCTest
import xcodeproj

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
        do {
            _ = try PBXReferenceProxy(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsIfThePathIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "path")
        do {
            _ = try PBXReferenceProxy(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsIfTheRemoteRefIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "remoteRef")
        do {
            _ = try PBXReferenceProxy(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsIfTheSourceTreeIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "sourceTree")
        do {
            _ = try PBXReferenceProxy(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    private func testDictionary() -> [String: Any] {
        return [
            "fileType": "fileType",
            "path": "path",
            "remoteRef": "remoteRef",
            "sourceTree": "<absolute>"
        ]
    }
}
