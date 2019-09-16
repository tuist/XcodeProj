import Foundation
import XCTest
@testable import XcodeProj

final class PBXProjObjectsHelpersTests: XCTestCase {
    var subject: PBXObjects!

    override func setUp() {
        super.setUp()
        subject = PBXObjects(objects: [])
    }

    func test_targetsNamed_returnsTheCorrectValue() {
        let nativeTarget = PBXNativeTarget(name: "test", buildConfigurationList: nil)
        let legacyTarget = PBXLegacyTarget(name: "test", buildConfigurationList: nil)
        let aggregateTarget = PBXAggregateTarget(name: "test", buildConfigurationList: nil)
        subject.add(object: nativeTarget)
        subject.add(object: legacyTarget)
        subject.add(object: aggregateTarget)
        let got = subject.targets(named: "test").map { $0 }
        XCTAssertTrue(got.contains(nativeTarget))
        XCTAssertTrue(got.contains(legacyTarget))
        XCTAssertTrue(got.contains(aggregateTarget))
    }
}
