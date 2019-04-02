import Foundation
import XCTest

@testable import XcodeProj

final class PBXTargetTests: XCTestCase {
    var subject: PBXTarget!

    override func setUp() {
        super.setUp()
        subject = PBXTarget.fixture()
    }

    func test_productNameWithExtension() {
        let expected = "\(subject.productName!).\(subject.productType!.fileExtension!)"
        XCTAssertEqual(subject.productNameWithExtension(), expected)
    }
}
