import Foundation
import XCTest
import xcproj

final class XCConfigurationListSpec: XCTestCase {

    var subject: XCConfigurationList!

    override func setUp() {
        super.setUp()
        self.subject = XCConfigurationList(reference: "reference",
                                           buildConfigurations: ["12345"],
                                           defaultConfigurationName: "Debug")
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(XCConfigurationList.isa, "XCConfigurationList")
    }

}
