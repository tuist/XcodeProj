import Foundation
@testable import xcodeproj
import XCTest

final class PBXTargetDependencySpec: XCTestCase {
    var subject: PBXTargetDependency!

    override func setUp() {
        subject = PBXTargetDependency(name: "name",
                                      target: PBXObjectReference("target"),
                                      targetProxy: PBXObjectReference("target_proxy"))
    }

    func test_hasTheCorrectIsa() {
        XCTAssertEqual(PBXTargetDependency.isa, "PBXTargetDependency")
    }
}
