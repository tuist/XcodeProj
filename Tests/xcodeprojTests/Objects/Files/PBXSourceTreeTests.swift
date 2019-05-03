import Foundation
import XCTest
@testable import XcodeProj

final class PBXSourceTreeTests: XCTestCase {
    func test_none_hasTheCorrectValue() {
        XCTAssertEqual(String(describing: PBXSourceTree.none), "")
    }

    func test_absolute_hasTheCorrectValue() {
        XCTAssertEqual(String(describing: PBXSourceTree.absolute), "<absolute>")
    }

    func test_group_hasTheCorrectValue() {
        XCTAssertEqual(String(describing: PBXSourceTree.group), "<group>")
    }

    func test_sourceRoot_hasTheCorrectValue() {
        XCTAssertEqual(String(describing: PBXSourceTree.sourceRoot), "SOURCE_ROOT")
    }

    func test_buildProductsDir_hasTheCorrectValue() {
        XCTAssertEqual(String(describing: PBXSourceTree.buildProductsDir), "BUILT_PRODUCTS_DIR")
    }

    func test_sdkRoot_hasTheCorrectValue() {
        XCTAssertEqual(String(describing: PBXSourceTree.sdkRoot), "SDKROOT")
    }

    func test_developerDir_hasTheCorrectValue() {
        XCTAssertEqual(String(describing: PBXSourceTree.developerDir), "DEVELOPER_DIR")
    }

    func test_plistReturnsTheRightValue_whenItsNone() {
        let expected = PlistValue.string(CommentedString(String(describing: PBXSourceTree.none)))
        XCTAssertEqual(PBXSourceTree.none.plist(), expected)
    }

    func test_plistReturnsTheRightValue_whenItsAbsolute() {
        let expected = PlistValue.string(CommentedString(String(describing: PBXSourceTree.absolute)))
        XCTAssertEqual(PBXSourceTree.absolute.plist(), expected)
    }

    func test_plistReturnsTheRightValue_whenItsGroup() {
        let expected = PlistValue.string(CommentedString(String(describing: PBXSourceTree.group)))
        XCTAssertEqual(PBXSourceTree.group.plist(), expected)
    }

    func test_plistReturnsTheRightValue_whenItsSourceRoot() {
        let expected = PlistValue.string(CommentedString(String(describing: PBXSourceTree.sourceRoot)))
        XCTAssertEqual(PBXSourceTree.sourceRoot.plist(), expected)
    }

    func test_plistReturnsTheRightValue_whenItsBuildProductsDir() {
        let expected = PlistValue.string(CommentedString(String(describing: PBXSourceTree.buildProductsDir)))
        XCTAssertEqual(PBXSourceTree.buildProductsDir.plist(), expected)
    }

    func test_plistReturnsTheRightValue_whenItsSdkRoot() {
        let expected = PlistValue.string(CommentedString(String(describing: PBXSourceTree.sdkRoot)))
        XCTAssertEqual(PBXSourceTree.sdkRoot.plist(), expected)
    }

    func test_plistReturnsTheRightValue_whenCustom() {
        let expected = PlistValue.string(CommentedString("CustomSourceTree"))
        XCTAssertEqual(PBXSourceTree.custom("CustomSourceTree").plist(), expected)
    }
}
