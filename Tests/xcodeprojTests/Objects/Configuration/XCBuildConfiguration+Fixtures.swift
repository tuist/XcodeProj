import Foundation
@testable import xcodeproj

extension XCBuildConfiguration {
    static func fixture(name: String = "Debug") -> XCBuildConfiguration {
        return XCBuildConfiguration(name: name)
    }
}
