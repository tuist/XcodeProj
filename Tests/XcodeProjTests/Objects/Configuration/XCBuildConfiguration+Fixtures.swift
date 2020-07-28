import Foundation
@testable import XcodeProj

extension XCBuildConfiguration {
    static func fixture(name: String = "Debug") -> XCBuildConfiguration {
        XCBuildConfiguration(name: name)
    }
}
