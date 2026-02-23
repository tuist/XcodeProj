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

    func test_equal_withDifferentPlatformFilters_returnsNotEqual() {
        let one = PBXFileSystemSynchronizedBuildFileExceptionSet.fixture(
            target: target,
            platformFiltersByRelativePath: ["file.swift": ["ios"]]
        )
        let another = PBXFileSystemSynchronizedBuildFileExceptionSet.fixture(
            target: target,
            platformFiltersByRelativePath: ["file.swift": ["tvos"]]
        )
        XCTAssertNotEqual(one, another)
    }

    func test_plistKeyAndValue_platformFiltersByRelativePath_serializesCorrectly() throws {
        let proj = PBXProj()
        let exceptionSet = PBXFileSystemSynchronizedBuildFileExceptionSet.fixture(
            target: target,
            platformFiltersByRelativePath: [
                "Resources/ios_only.mp4": ["ios"],
                "Resources/multi.mp4": ["ios", "tvos"],
            ]
        )
        proj.add(object: exceptionSet)

        let (_, plistValue) = try exceptionSet.plistKeyAndValue(proj: proj, reference: "ref")

        let dict = try XCTUnwrap(plistValue.dictionary?[CommentedString("platformFiltersByRelativePath")]?.dictionary)
        XCTAssertEqual(
            dict[CommentedString("Resources/ios_only.mp4")],
            .array([.string(CommentedString("ios"))])
        )
        XCTAssertEqual(
            dict[CommentedString("Resources/multi.mp4")],
            .array([.string(CommentedString("ios")), .string(CommentedString("tvos"))])
        )
    }

    func test_plistKeyAndValue_platformFiltersByRelativePath_omittedWhenNil() throws {
        let proj = PBXProj()
        let exceptionSet = PBXFileSystemSynchronizedBuildFileExceptionSet.fixture(
            target: target,
            platformFiltersByRelativePath: nil
        )
        proj.add(object: exceptionSet)

        let (_, plistValue) = try exceptionSet.plistKeyAndValue(proj: proj, reference: "ref")

        XCTAssertNil(plistValue.dictionary?[CommentedString("platformFiltersByRelativePath")])
    }
}
