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
        XCTAssertEqual(subject.usesTabs, nil)
        XCTAssertEqual(subject.indentWidth, nil)
        XCTAssertEqual(subject.tabWidth, nil)
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

        let withUsesTabs = PBXGroup(reference: "ref",
                                    children: ["333"],
                                    sourceTree: .group,
                                    name: "name",
                                    usesTabs: 1)
        XCTAssertFalse(withUsesTabs == subject)
    }

    func test_hashValue_returnsTheReferenceHashValue() {
        XCTAssertEqual(subject.hashValue, subject.reference.hashValue)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "children": ["child"],
            "name": "name",
            "sourceTree": "absolute",
            "reference": "reference"
        ]
    }
}
