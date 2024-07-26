import Foundation
import XCTest
@testable import XcodeProj

final class PBXFileSystemSynchronizedBuildFileExceptionSetTests: XCTestCase {
    var target: PBXTarget!
    var subject: PBXFileSystemSynchronizedBuildFileExceptionSet!

    override func setUp() {
        super.setUp()
        target = PBXTarget.fixture()
        subject = PBXFileSystemSynchronizedBuildFileExceptionSet.fixture(target: target)
    }

    override func tearDown() {
        target = nil
        subject = nil
        super.tearDown()
    }

    func test_itHasTheCorrectIsa() {
        XCTAssertEqual(PBXFileSystemSynchronizedBuildFileExceptionSet.isa, "PBXFileSystemSynchronizedBuildFileExceptionSet")
    }

    func test_equal_returnsTheCorrectValue() {
        let another = PBXFileSystemSynchronizedBuildFileExceptionSet.fixture(target: target)
        XCTAssertEqual(subject, another)
    }
}
