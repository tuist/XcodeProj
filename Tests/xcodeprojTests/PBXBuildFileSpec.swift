import Foundation
import xcodeproj
import XCTest

final class PBXBuildFileSpec: XCTestCase {
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXBuildFile.isa, "PBXBuildFile")
    }
}
