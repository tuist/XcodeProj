import Foundation
import XcodeProj
import XCTest

final class PBXBuildFileTests: XCTestCase {
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXBuildFile.isa, "PBXBuildFile")
    }

    func test_platformFilterIsSet() {
        let pbxBuildFile: PBXBuildFile = PBXBuildFile(
            platformFilter: "platformFilter"
        )
        XCTAssertEqual(pbxBuildFile.platformFilter, "platformFilter")
    }
}
