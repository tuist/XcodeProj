import Foundation
import XCTest
@testable import XcodeProj

final class PBXTargetDependencyTests: XCTestCase {
    func test_hasTheCorrectIsa() {
        XCTAssertEqual(PBXTargetDependency.isa, "PBXTargetDependency")
    }
}
