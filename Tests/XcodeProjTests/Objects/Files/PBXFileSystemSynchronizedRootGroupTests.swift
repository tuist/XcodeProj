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

    // MARK: - plistKeyAndValue

    func test_plistKeyAndValue_explicitFileTypes_serializedOnlyWhenNonEmpty() throws {
        let (_, nonEmpty) = try subject.plistKeyAndValue(proj: PBXProj(), reference: "ref")
        XCTAssertNotNil(nonEmpty.dictionary?[CommentedString("explicitFileTypes")])

        subject.explicitFileTypes = [:]
        let (_, empty) = try subject.plistKeyAndValue(proj: PBXProj(), reference: "ref")
        XCTAssertNil(empty.dictionary?[CommentedString("explicitFileTypes")])
    }

    func test_plistKeyAndValue_explicitFolders_serializedOnlyWhenNonEmpty() throws {
        let (_, empty) = try subject.plistKeyAndValue(proj: PBXProj(), reference: "ref")
        XCTAssertNil(empty.dictionary?[CommentedString("explicitFolders")])

        subject.explicitFolders = ["SubFolder"]
        let (_, nonEmpty) = try subject.plistKeyAndValue(proj: PBXProj(), reference: "ref")
        XCTAssertNotNil(nonEmpty.dictionary?[CommentedString("explicitFolders")])
    }

    func test_plistKeyAndValue_name_serializedOnlyWhenDifferentFromPath() throws {
        let (_, same) = try subject.plistKeyAndValue(proj: PBXProj(), reference: "ref")
        XCTAssertNil(same.dictionary?[CommentedString("name")])

        subject.name = "Display Name"
        let (_, different) = try subject.plistKeyAndValue(proj: PBXProj(), reference: "ref")
        XCTAssertEqual(different.dictionary?[CommentedString("name")], .string(CommentedString("Display Name")))
    }

    func test_plistKeyAndValue_exceptionReference_usesDescriptiveComment() throws {
        let (_, value) = try subject.plistKeyAndValue(proj: PBXProj(), reference: "ref")
        let exceptionsArray = try XCTUnwrap(value.dictionary?[CommentedString("exceptions")]?.array)
        let entry = try XCTUnwrap(exceptionsArray.first?.string)
        XCTAssertEqual(entry.comment, "Exceptions for \"synchronized\" folder in \"Test\" target")
    }

    // MARK: - assignParentToChildren

    func test_assignParentToChildren_wiresSynchronizedRootGroup() {
        XCTAssertIdentical(exception.synchronizedRootGroup, subject)
    }
}
