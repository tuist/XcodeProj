import Foundation
import XCTest

@testable import xcodeproj

final class PBXTargetSpec: XCTestCase {
    var subject: PBXTarget!

    override func setUp() {
        super.setUp()
        subject = PBXTarget(name: "Test",
                            buildConfigurationListReference: nil,
                            buildPhaseReferences: [],
                            buildRuleReferences: [],
                            dependencyReferences: [],
                            productName: "Test",
                            productReference: nil,
                            productType: .application)
    }

    func test_productNameWithExtension() {
        let expected = "\(subject.productName!).\(subject.productType!.fileExtension!)"
        XCTAssertEqual(subject.productNameWithExtension(), expected)
    }
}
