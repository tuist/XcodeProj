import Foundation
import XCTest

@testable import xcproj

final class PBXProjObjectsHelpersSpec: XCTestCase {
 
    var subject: PBXProj.Objects!
    
    override func setUp() {
        super.setUp()
        subject = PBXProj.Objects(objects: [])
    }
    
    func test_targetsNamed_returnsTheCorrectValue() {
        let nativeTarget = PBXNativeTarget(reference: "1", name: "test")
        let legacyTarget = PBXLegacyTarget(reference: "1", name: "test")
        let aggregateTarget = PBXAggregateTarget(reference: "1", name: "test")
        subject.addObject(nativeTarget)
        subject.addObject(legacyTarget)
        subject.addObject(aggregateTarget)
        let got = subject.targets(named: "test")
        XCTAssertTrue(got.contains(nativeTarget))
        XCTAssertTrue(got.contains(legacyTarget))
        XCTAssertTrue(got.contains(aggregateTarget))
    }
    
}
