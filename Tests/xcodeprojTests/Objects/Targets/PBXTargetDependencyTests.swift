import Foundation
import XCTest
@testable import xcodeproj

final class PBXTargetDependencyTests: XCTestCase {
    func test_hasTheCorrectIsa() {
        XCTAssertEqual(PBXTargetDependency.isa, "PBXTargetDependency")
    }
}
