import Foundation

public enum PBXProductType: String, Decodable {
    case none = ""
    case application = "com.apple.product-type.application"
    case framework = "com.apple.product-type.framework"
    case staticFramework = "com.apple.product-type.framework.static"
    case xcFramework = "com.apple.product-type.xcframework"
    case dynamicLibrary = "com.apple.product-type.library.dynamic"
    case staticLibrary = "com.apple.product-type.library.static"
    case bundle = "com.apple.product-type.bundle"
    case unitTestBundle = "com.apple.product-type.bundle.unit-test"
    case uiTestBundle = "com.apple.product-type.bundle.ui-testing"
    case appExtension = "com.apple.product-type.app-extension"
    case extensionKitExtension = "com.apple.product-type.extensionkit-extension"
    case commandLineTool = "com.apple.product-type.tool"
    case watchApp = "com.apple.product-type.application.watchapp"
    case watch2App = "com.apple.product-type.application.watchapp2"
    case watch2AppContainer = "com.apple.product-type.application.watchapp2-container"
    case watchExtension = "com.apple.product-type.watchkit-extension"
    case watch2Extension = "com.apple.product-type.watchkit2-extension"
    case tvExtension = "com.apple.product-type.tv-app-extension"
    case messagesApplication = "com.apple.product-type.application.messages"
    case messagesExtension = "com.apple.product-type.app-extension.messages"
    case stickerPack = "com.apple.product-type.app-extension.messages-sticker-pack"
    case xpcService = "com.apple.product-type.xpc-service"
    case ocUnitTestBundle = "com.apple.product-type.bundle.ocunit-test"
    case xcodeExtension = "com.apple.product-type.xcode-extension"
    case instrumentsPackage = "com.apple.product-type.instruments-package"
    case intentsServiceExtension = "com.apple.product-type.app-extension.intents-service"
    case onDemandInstallCapableApplication = "com.apple.product-type.application.on-demand-install-capable"
    case metalLibrary = "com.apple.product-type.metal-library"
    case driverExtension = "com.apple.product-type.driver-extension"
    case systemExtension = "com.apple.product-type.system-extension"

    /// Returns the file extension for the given product type.
    public var fileExtension: String? {
        switch self {
        case .application, .watchApp, .watch2App, .watch2AppContainer, .messagesApplication, .onDemandInstallCapableApplication:
            "app"
        case .framework, .staticFramework:
            "framework"
        case .dynamicLibrary:
            "dylib"
        case .staticLibrary:
            "a"
        case .bundle:
            "bundle"
        case .unitTestBundle, .uiTestBundle:
            "xctest"
        case .appExtension, .extensionKitExtension, .tvExtension, .watchExtension, .watch2Extension, .messagesExtension, .stickerPack, .xcodeExtension,
             .intentsServiceExtension:
            "appex"
        case .commandLineTool:
            nil
        case .xpcService:
            "xpc"
        case .ocUnitTestBundle:
            "octest"
        case .instrumentsPackage:
            "instrpkg"
        case .xcFramework:
            "xcframework"
        case .metalLibrary:
            "metallib"
        case .systemExtension:
            "systemextension"
        case .driverExtension:
            "dext"
        case .none:
            nil
        }
    }
}
