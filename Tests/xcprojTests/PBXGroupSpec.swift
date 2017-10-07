import Foundation
import XCTest
import xcproj

final class PBXGroupSpec: XCTestCase {

    var subject: PBXGroup!

    override func setUp() {
        super.setUp()
        self.subject = PBXGroup(reference: "ref",
                                children: ["333"],
                                sourceTree: .group,
                                name: "name")
    }

    func test_init_initializesTheGroupWithTheRightProperties() {
        XCTAssertEqual(subject.reference, "ref")
        XCTAssertEqual(subject.children, ["333"])
        XCTAssertEqual(subject.sourceTree, .group)
        XCTAssertEqual(subject.name, "name")
    }

    func test_init_setsTheCorrectDefaultValue_whenChildrenIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "children")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXGroup.self, from: data)
        XCTAssertEqual(subject.children, [])
    }

    func test_init_setsTheCorrectDefaultValue_whenSourceTreeIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "sourceTree")
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXGroup.self, from: data)
        XCTAssertEqual(subject.sourceTree, .none)
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXGroup.isa, "PBXGroup")
    }

    func test_equals_returnsTheCorretValue() {
        let another = PBXGroup(reference: "ref",
                               children: ["333"],
                               sourceTree: .group,
                               name: "name")
        XCTAssertEqual(subject, another)
    }

    func test_hashValue_returnsTheReferenceHashValue() {
        XCTAssertEqual(subject.hashValue, subject.reference.hashValue)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "children": ["child"],
            "name": "name",
            "sourceTree": "<absolute>",
            "reference": "reference"
        ]
    }
}
