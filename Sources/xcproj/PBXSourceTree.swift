import Foundation

/// Specifies source trees for files
/// Corresponds to the "Location" dropdown in Xcode's File Inspector
public enum PBXSourceTree: String, Hashable, Decodable {
    case none = ""
    case absolute = "<absolute>"
    case group = "<group>"
    case sourceRoot = "SOURCE_ROOT"
    case buildProductsDir = "BUILT_PRODUCTS_DIR"
    case sdkRoot = "SDKROOT"
    case developerDir = "DEVELOPER_DIR"
}

// MARK: - PBXSourceTree Extension (PlistValue)

extension PBXSourceTree {
    
    func plist() -> PlistValue {
        return .string(CommentedString(self.rawValue))
    }

}
