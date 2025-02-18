import Foundation
import XcodeProj
import XCTest

final class PBXBuildFileTests: XCTestCase {
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXBuildFile.isa, "PBXBuildFile")
    }

    func test_platformFilterIsSet() {
        let pbxBuildFile = PBXBuildFile(
            platformFilter: "platformFilter"
        )
        XCTAssertEqual(pbxBuildFile.platformFilter, "platformFilter")
    }

    func test_platformCompilerFlagsIsSet() {
        let expected = "flagValue"
        let pbxBuildFile = PBXBuildFile(
            settings: ["COMPILER_FLAGS": .string(expected)]
        )
        XCTAssertEqual(pbxBuildFile.compilerFlags, expected)
    }

    func test_platformAttributesIsSet() {
        let expected = ["Public"]
        let pbxBuildFile = PBXBuildFile(
            settings: ["ATTRIBUTES": .array(expected)]
        )
        XCTAssertEqual(pbxBuildFile.attributes, expected)
    }
}
