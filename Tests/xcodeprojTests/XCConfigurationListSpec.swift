import Foundation
import XCTest

import xcodeproj

final class XCConfigurationListSpec: XCTestCase {
    
    var subject: XCConfigurationList!
    
    override func setUp() {
        super.setUp()
        self.subject = XCConfigurationList(reference: "reference",
                                           buildConfigurations: Set(arrayLiteral: "12345"),
                                           defaultConfigurationName: "Debug")
    }
    
    func test_addingConfiguration_addsTheConfiguration() {
        let got = subject.adding(configuration: "3333")
        XCTAssertTrue(got.buildConfigurations.contains("3333"))
    }
    
    func test_removingConfiguration_removesTheConfiguration() {
        let got = subject.removing(configuration: "12345")
        XCTAssertFalse(got.buildConfigurations.contains("12345"))
    }
    
    func test_withDefaultConfigurationName_usesThePassedName() {
        let got = subject.withDefaultConfigurationName(name: "teeest")
        XCTAssertEqual(got.defaultConfigurationName, "teeest")
    }
    
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(XCConfigurationList.isa, "XCConfigurationList")
    }
    
}
