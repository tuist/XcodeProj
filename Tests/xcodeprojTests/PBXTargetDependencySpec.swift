import Foundation
import XCTest

@testable import xcodeproj

final class PBXTargetDependencySpec: XCTestCase {
    
    var subject: PBXTargetDependency!
    
    override func setUp() {
        subject = PBXTargetDependency(reference: "reference",
                                      target: "target",
                                      targetProxy: "target_proxy")
    }
    
    func test_hasTheCorrectIsa() {
        XCTAssertEqual(subject.isa, "PBXTargetDependency")
    }
}
