import Foundation
@testable import xcodeproj
import XCTest

final class XCConfigurationListSpec: XCTestCase {
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(XCConfigurationList.isa, "XCConfigurationList")
    }
}
