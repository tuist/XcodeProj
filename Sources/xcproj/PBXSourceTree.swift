import Foundation

/// Specifies source trees for files
/// Corresponds to the "Location" dropdown in Xcode's File Inspector
public enum PBXSourceTree: CustomStringConvertible, Hashable, Decodable {

    case none
    case absolute
    case group
    case sourceRoot
    case buildProductsDir
    case sdkRoot
    case developerDir
    case custom(String)

    public init(value: String) {
        switch value {
            case "":
                self = .none
            case "<absolute>":
                self = .absolute
            case "<group>":
                self = .group
            case "SOURCE_ROOT":
                self = .sourceRoot
            case "BUILT_PRODUCTS_DIR":
                self = .buildProductsDir
            case "SDKROOT":
                self = .sdkRoot
            case "DEVELOPER_DIR":
                self = .developerDir
            default:
                self = .custom(value)
        }
    }

    public init(from decoder: Decoder) throws {
        try self.init(value: decoder.singleValueContainer().decode(String.self))
    }

    public static func ==(lhs: PBXSourceTree, rhs: PBXSourceTree) -> Bool {
        switch (lhs, rhs) {
            case (.none, .none),
                 (.absolute, .absolute),
                 (.group, .group),
                 (.sourceRoot, .sourceRoot),
                 (.buildProductsDir, .buildProductsDir),
                 (.sdkRoot, .sdkRoot),
                 (.developerDir, .developerDir):
                return true

            case (.custom(let lhsValue), .custom(let rhsValue)):
                return lhsValue == rhsValue

            case (.none, _),
                 (.absolute, _),
                 (.group, _),
                 (.sourceRoot, _),
                 (.buildProductsDir, _),
                 (.sdkRoot, _),
                 (.developerDir, _),
                 (.custom, _):
                return false
        }
    }

    public var hashValue: Int {
        return description.hashValue
    }

    public var description: String {
        switch self {
            case .none:
                return ""
            case .absolute:
                return "<absolute>"
            case .group:
                return "<group>"
            case .sourceRoot:
                return "SOURCE_ROOT"
            case .buildProductsDir:
                return "BUILT_PRODUCTS_DIR"
            case .sdkRoot:
                return "SDKROOT"
            case .developerDir:
                return "DEVELOPER_DIR"
            case .custom(let value):
                return value
        }
    }
}

// MARK: - PBXSourceTree Extension (PlistValue)

extension PBXSourceTree {
    
    func plist() -> PlistValue {
        return .string(CommentedString(String(describing: self)))
    }

}
