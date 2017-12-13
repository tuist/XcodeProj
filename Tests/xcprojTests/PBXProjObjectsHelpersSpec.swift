import Foundation
import XCTest

@testable import xcproj

final class PBXProjObjectsHelpersSpec: XCTestCase {
 
    var subject: PBXProj.Objects!
    
    override func setUp() {
        super.setUp()
        subject = PBXProj.Objects(objects: [:])
    }
    
    func test_targetsNamed_returnsTheCorrectValue() {
        let nativeTarget = PBXNativeTarget(name: "test")
        let legacyTarget = PBXLegacyTarget(name: "test")
        let aggregateTarget = PBXAggregateTarget(name: "test")
        subject.addObject(nativeTarget, reference: "1")
        subject.addObject(legacyTarget, reference: "2")
        subject.addObject(aggregateTarget, reference: "3")
        let got = subject.targets(named: "test")
        XCTAssertTrue(got.contains(nativeTarget))
        XCTAssertTrue(got.contains(legacyTarget))
        XCTAssertTrue(got.contains(aggregateTarget))
    }
    
}
