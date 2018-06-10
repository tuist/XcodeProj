import Foundation
@testable import xcodeproj
import XCTest

final class PBXReferenceProxySpec: XCTestCase {
    var subject: PBXReferenceProxy!

    override func setUp() {
        super.setUp()
        subject = PBXReferenceProxy(fileType: "fileType",
                                    path: "path",
                                    remoteReference: PBXObjectReference("remoteRef"),
                                    sourceTree: .absolute)
    }

    func test_init_initializesTheModelWithTheCorrectAttributes() {
        XCTAssertEqual(subject.fileType, "fileType")
        XCTAssertEqual(subject.path, "path")
        XCTAssertEqual(subject.remoteReference?.value, "remoteRef")
        XCTAssertEqual(subject.sourceTree, .absolute)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "fileType": "fileType",
            "path": "path",
            "remoteRef": "remoteRef",
            "sourceTree": "<absolute>",
        ]
    }
}
