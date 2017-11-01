import Foundation
import XCTest

@testable import xcproj

final class PBXSourceTreeSpec: XCTestCase {

    func test_none_hasTheCorrectValue() {
        XCTAssertEqual(PBXSourceTree.none.rawValue, "")
    }

    func test_absolute_hasTheCorrectValue() {
        XCTAssertEqual(PBXSourceTree.absolute.rawValue, "<absolute>")
    }

    func test_group_hasTheCorrectValue() {
        XCTAssertEqual(PBXSourceTree.group.rawValue, "<group>")
    }

    func test_sourceRoot_hasTheCorrectValue() {
        XCTAssertEqual(PBXSourceTree.sourceRoot.rawValue, "SOURCE_ROOT")
    }

    func test_buildProductsDir_hasTheCorrectValue() {
        XCTAssertEqual(PBXSourceTree.buildProductsDir.rawValue, "BUILT_PRODUCTS_DIR")
    }

    func test_sdkRoot_hasTheCorrectValue() {
        XCTAssertEqual(PBXSourceTree.sdkRoot.rawValue, "SDKROOT")
    }
    
    func test_developerDir_hasTheCorrectValue() {
        XCTAssertEqual(PBXSourceTree.developerDir.rawValue, "DEVELOPER_DIR")
    }

    func test_plistReturnsTheRightValue_whenItsNone() {
        let expected = PlistValue.string(CommentedString(PBXSourceTree.none.rawValue))
        XCTAssertEqual(PBXSourceTree.none.plist(), expected)
    }

    func test_plistReturnsTheRightValue_whenItsAbsolute() {
        let expected = PlistValue.string(CommentedString(PBXSourceTree.absolute.rawValue))
        XCTAssertEqual(PBXSourceTree.absolute.plist(), expected)
    }

    func test_plistReturnsTheRightValue_whenItsGroup() {
        let expected = PlistValue.string(CommentedString(PBXSourceTree.group.rawValue))
        XCTAssertEqual(PBXSourceTree.group.plist(), expected)
    }

    func test_plistReturnsTheRightValue_whenItsSourceRoot() {
        let expected = PlistValue.string(CommentedString(PBXSourceTree.sourceRoot.rawValue))
        XCTAssertEqual(PBXSourceTree.sourceRoot.plist(), expected)
    }

    func test_plistReturnsTheRightValue_whenItsBuildProductsDir() {
        let expected = PlistValue.string(CommentedString(PBXSourceTree.buildProductsDir.rawValue))
        XCTAssertEqual(PBXSourceTree.buildProductsDir.plist(), expected)
    }

    func test_plistReturnsTheRightValue_whenItsSdkRoot() {
        let expected = PlistValue.string(CommentedString(PBXSourceTree.sdkRoot.rawValue))
        XCTAssertEqual(PBXSourceTree.sdkRoot.plist(), expected)
    }
}
