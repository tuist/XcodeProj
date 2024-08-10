import Foundation
import XCTest
@testable import XcodeProj

final class PBXFileSystemSynchronizedRootGroupTests: XCTestCase {
    var subject: PBXFileSystemSynchronizedRootGroup!
    var target: PBXTarget!
    var exception: PBXFileSystemSynchronizedBuildFileExceptionSet!

    override func setUp() {
        super.setUp()
        target = PBXTarget.fixture()
        exception = PBXFileSystemSynchronizedBuildFileExceptionSet.fixture(target: target)
        subject = PBXFileSystemSynchronizedRootGroup(sourceTree: .group,
                                                     path: "synchronized",
                                                     name: "synchronized",
                                                     includeInIndex: true,
                                                     usesTabs: true,
                                                     indentWidth: 2,
                                                     tabWidth: 2,
                                                     wrapsLines: true,
                                                     explicitFileTypes: ["Source.m": "sourcecode.c.objc"],
                                                     exceptions: [exception],
                                                     explicitFolders: [])
    }

    override func tearDown() {
        exception = nil
        subject = nil
        super.tearDown()
    }

    func test_itHasTheCorrectIsa() {
        XCTAssertEqual(PBXFileSystemSynchronizedRootGroup.isa, "PBXFileSystemSynchronizedRootGroup")
    }

    func test_equal_returnsTheCorrectValue() {
        let another = PBXFileSystemSynchronizedRootGroup(sourceTree: .group,
                                                         path: "synchronized",
                                                         name: "synchronized",
                                                         includeInIndex: true,
                                                         usesTabs: true,
                                                         indentWidth: 2,
                                                         tabWidth: 2,
                                                         wrapsLines: true,
                                                         explicitFileTypes: ["Source.m": "sourcecode.c.objc"],
                                                         exceptions: [exception],
                                                         explicitFolders: [])
        XCTAssertEqual(subject, another)
    }
}
