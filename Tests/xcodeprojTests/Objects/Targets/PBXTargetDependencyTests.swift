import Foundation
@testable import xcodeproj
import XCTest

final class PBXTargetDependencyTests: XCTestCase {
    func test_hasTheCorrectIsa() {
        XCTAssertEqual(PBXTargetDependency.isa, "PBXTargetDependency")
    }
}
