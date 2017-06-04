import Foundation
import XCTest

@testable import Models

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
}
