import Foundation
import Unbox

// Specifies source trees for files
public enum PBXSourceTree: String, UnboxableEnum, Hashable {
    case none = ""
    case absolute = "<absolute>"
    case group = "<group>"
    case sourceRoot = "SOURCE_ROOT"
    case buildProductsDir = "BUILT_PRODUCTS_DIR"
    case sdkRoot = "SDKROOT"
}
