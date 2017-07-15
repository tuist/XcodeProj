import Foundation
import Unbox

/// Product type.
///
/// - none: None
/// - application: Application
/// - tool: Tool
/// - libraryStatic: Static Library
/// - libraryDynamic: Dynamic Library.
/// - kernelExtension: Kernel Extension.
/// - kernelExtensionIOKit: Kernel Extension IO Kit
/// - bundleUnitTest: Bundle unit test
public enum PBXProductType: String, UnboxableEnum {
    case none = ""
    case application = "com.apple.product-type.application"
    case tool = "com.apple.product-type.tool"
    case libraryStatic = "com.apple.product-type.library.static"
    case libraryDynamic = "com.apple.product-type.library.dynamic"
    case kernelExtension = "com.apple.product-type.kernel-extension"
    case kernelExtensionIOKit = "com.apple.product-type.kernel-extension.iokit"
    case bundleUnitTest = "com.apple.product-type.bundle.unit-test"
}
