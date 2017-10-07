import Foundation
import XCTest
import xcproj

final class PBXFileElementSpec: XCTestCase {

    var subject: PBXFileElement!

    override func setUp() {
        super.setUp()
        subject = PBXFileElement(reference: "ref",
                                 sourceTree: .absolute,
                                 path: "path",
                                 name: "name")
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXFileElement.isa, "PBXFileElement")
    }

    func test_init_initializesTheFileElementWithTheRightAttributes() {
        XCTAssertEqual(subject.reference, "ref")
        XCTAssertEqual(subject.sourceTree, .absolute)
        XCTAssertEqual(subject.path, "path")
        XCTAssertEqual(subject.name, "name")
    }

    func test_equal_returnsTheCorrectValue() {
        let another = PBXFileElement(reference: "ref",
                                     sourceTree: .absolute,
                                     path: "path",
                                     name: "name")
        XCTAssertEqual(subject, another)
    }

    func test_init_setsTheCorrectDefaultValue_whenSourceTreeIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "sourceTree")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXFileElement.self, from: data)
        XCTAssertEqual(subject.sourceTree, .none)
    }

    func test_init_failsIfPathIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "path")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXFileElement.self, from: data)
            XCTAssertTrue(false, "Expected to throw but it didn't")
        } catch {}
    }

    func test_init_failsIfNameIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "name")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXFileElement.self, from: data)
            XCTAssertTrue(false, "Expected to throw but it didn't")
        } catch {}
    }

    func test_hashValue_returnsTheReferenceHashValue() {
        XCTAssertEqual(subject.hashValue, subject.reference.hashValue)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "reference": "reference",
            "sourceTree": "absolute",
            "path": "path",
            "name": "name"
        ]
    }
}
