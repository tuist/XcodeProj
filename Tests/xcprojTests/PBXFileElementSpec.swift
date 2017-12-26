import Foundation
import XCTest
import xcproj

final class PBXFileElementSpec: XCTestCase {

    var subject: PBXFileElement!

    override func setUp() {
        super.setUp()
        subject = PBXFileElement(sourceTree: .absolute,
                                 path: "path",
                                 name: "name")
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXFileElement.isa, "PBXFileElement")
    }

    func test_init_initializesTheFileElementWithTheRightAttributes() {
        XCTAssertEqual(subject.sourceTree, .absolute)
        XCTAssertEqual(subject.path, "path")
        XCTAssertEqual(subject.name, "name")
    }

    func test_equal_returnsTheCorrectValue() {
        let another = PBXFileElement(sourceTree: .absolute,
                                     path: "path",
                                     name: "name")
        XCTAssertEqual(subject, another)
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

    private func testDictionary() -> [String: Any] {
        return [
            "sourceTree": "absolute",
            "path": "path",
            "name": "name"
        ]
    }
}
