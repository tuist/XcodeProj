import Foundation
import Unbox

// Specifies source trees for files
public enum PBXSourceTree: String, UnboxableEnum {
    case none = ""
    case absolute = "<absolute>"
    case group = "<group>"
    case sourceRoot = "SOURCE_ROOT"
    case buildProductsDir = "BUILD_PRODUCTS_DIR"
    case sdkRoot = "SDKROOT"
}
