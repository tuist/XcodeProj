import Foundation

// Specifies source trees for files
public enum PBXSourceTree: String {
    case none = ""
    case absolute = "<absolute>"
    case group = "<group>"
    case sourceRoot = "SOURCE_ROOT"
    case buildProductsDir = "BUILD_PRODUCTS_DIR"
    case sdkRoot = "SDKROOT"
}
