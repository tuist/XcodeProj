import Foundation
import XCTest

@testable import Models

final class PBXProductTypeSpec: XCTestCase {
    
    
    func test_none_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.none.rawValue, "")
    }
    
    func test_application_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.application.rawValue, "com.apple.product-type.application")
    }
    
    func test_tool_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.tool.rawValue, "com.apple.product-type.tool")
    }
    
    func test_libraryStatic_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.libraryStatic.rawValue, "com.apple.product-type.library.static")
    }
    
    func test_libraryDynamic_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.libraryDynamic.rawValue, "com.apple.product-type.library.dynamic")
    }
    
    func test_kernelExtension_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.kernelExtension.rawValue, "com.apple.product-type.kernel-extension")
    }
    
    func test_kernelExtensionIOKit_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.kernelExtensionIOKit.rawValue, "com.apple.product-type.kernel-extension.iokit")
    }
}
