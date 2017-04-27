import Foundation
import XCTest

@testable import xcodeproj

final class PBXVariantGroupSpec: XCTestCase {
    
    var subject: PBXVariantGroup!
    
    override func setUp() {
        super.setUp()
        self.subject = PBXVariantGroup(reference: "reference",
                                       children: ["child"],
                                       name: "name",
                                       sourceTree: .group)
    }
    
    func test_itHasTheCorrectIsa() {
        XCTAssertEqual(subject.isa, "PBXVariantGroup")
    }
    
}
