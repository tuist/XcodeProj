import Foundation
@testable import xcodeproj
import XCTest

final class PBXTargetDependencyTests: XCTestCase {
    var subject: PBXTargetDependency!

    override func setUp() {
        subject = PBXTargetDependency(name: "name",
                                      targetReference: PBXObjectReference("target"),
                                      targetProxyReference: PBXObjectReference("target_proxy"))
    }

    func test_hasTheCorrectIsa() {
        XCTAssertEqual(PBXTargetDependency.isa, "PBXTargetDependency")
    }
}
