import Foundation
import XCTest
import xcproj

final class PBXProductTypeSpec: XCTestCase {


    func test_none_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.none.rawValue, "")
    }

    func test_application_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.application.rawValue, "com.apple.product-type.application")
    }

    func test_framework_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.framework.rawValue, "com.apple.product-type.framework")
    }

    func test_dynamicLibrary_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.dynamicLibrary.rawValue, "com.apple.product-type.library.dynamic")
    }

    func test_staticLibrary_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.staticLibrary.rawValue, "com.apple.product-type.library.static")
    }

    func test_bundle_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.bundle.rawValue, "com.apple.product-type.bundle")
    }

    func test_unitTestBundle_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.unitTestBundle.rawValue, "com.apple.product-type.bundle.unit-test")
    }

    func test_uiTestBundle_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.uiTestBundle.rawValue, "com.apple.product-type.bundle.ui-testing")
    }

    func test_appExtension_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.appExtension.rawValue, "com.apple.product-type.app-extension")
    }

    func test_commandLineTool_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.commandLineTool.rawValue, "com.apple.product-type.tool")
    }

    func test_watchApp_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.watchApp.rawValue, "com.apple.product-type.application.watchapp")
    }

    func test_watch2App_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.watch2App.rawValue, "com.apple.product-type.application.watchapp2")
    }

    func test_watchExtension_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.watchExtension.rawValue, "com.apple.product-type.watchkit-extension")
    }

    func test_watch2Extension_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.watch2Extension.rawValue, "com.apple.product-type.watchkit2-extension")
    }

    func test_tvExtension_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.tvExtension.rawValue, "com.apple.product-type.tv-app-extension")
    }

    func test_messagesApplication_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.messagesApplication.rawValue, "com.apple.product-type.application.messages")
    }

    func test_messagesExtension_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.messagesExtension.rawValue, "com.apple.product-type.app-extension.messages")
    }

    func test_stickerPack_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.stickerPack.rawValue, "com.apple.product-type.app-extension.messages-sticker-pack")
    }

    func test_xpcService_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.xpcService.rawValue, "com.apple.product-type.xpc-service")
    }
    
    func test_ocUnitTestBundle_hasTheRightValue() {
        XCTAssertEqual(PBXProductType.ocUnitTestBundle.rawValue, "com.apple.product-type.bundle.ocunit-test")
    }
}
