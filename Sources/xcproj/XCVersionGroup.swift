import Foundation
import PathKit

/// Group that contains multiple files references to the different versions of a resource.
/// Used to contain the different versions of a xcdatamodel
public class XCVersionGroup: PBXObject, Hashable {

    // MARK: - Attributes

    /// Current version.
    public let currentVersion: String?

    /// Path.
    public let path: String?

    /// Name.
    public let name: String?

    /// Source tree type.
    public let sourceTree: PBXSourceTree?

    /// Version group type.
    public let versionGroupType: String?

    /// Children references.
    public let children: [String]

    // MARK: - Init

    public init(reference: String,
                currentVersion: String? = nil,
                path: String? = nil,
                name: String? = nil,
                sourceTree: PBXSourceTree? = nil,
                versionGroupType: String? = nil,
                children: [String] = []) {
        self.currentVersion = currentVersion
        self.path = path
        self.name = name
        self.sourceTree = sourceTree
        self.versionGroupType = versionGroupType
        self.children = children
        super.init(reference: reference)
    }

    public static func == (lhs: XCVersionGroup,
                           rhs: XCVersionGroup) -> Bool {
        return lhs.reference == rhs.reference &&
        lhs.currentVersion == rhs.currentVersion &&
        lhs.path == rhs.path &&
        lhs.sourceTree == rhs.sourceTree &&
        lhs.versionGroupType == rhs.versionGroupType &&
        lhs.children == rhs.children
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case currentVersion
        case path
        case name
        case sourceTree
        case versionGroupType
        case children
        case reference
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currentVersion = try container.decodeIfPresent(String.self, forKey: .currentVersion)
        self.path = try container.decodeIfPresent(String.self, forKey: .path)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.sourceTree = try container.decodeIfPresent(PBXSourceTree.self, forKey: .sourceTree)
        self.versionGroupType = try container.decodeIfPresent(String.self, forKey: .versionGroupType)
        self.children = try container.decodeIfPresent([String].self, forKey: .children) ?? []
        try super.init(from: decoder)
    }
}

// MARK: - XCVersionGroup Extension (PlistSerializable)

extension XCVersionGroup: PlistSerializable {

    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(XCVersionGroup.isa))
        if let name = name {
            dictionary["name"] = .string(CommentedString(name))
        }
        if let path = path {
            dictionary["path"] = .string(CommentedString(path))
        }
        if let sourceTree = sourceTree {
            dictionary["sourceTree"] = sourceTree.plist()
        }
        if let versionGroupType = versionGroupType {
            dictionary["versionGroupType"] = .string(CommentedString(versionGroupType))
        }
        dictionary["children"] = .array(children
            .map({ fileReference in
                let comment = proj.fileName(fileReference: fileReference)
                return .string(CommentedString(fileReference, comment: comment))
            }))
        if let currentVersion = currentVersion {
            dictionary["currentVersion"] = .string(CommentedString(currentVersion, comment: proj.fileName(fileReference: currentVersion)))
        }
        return (key: CommentedString(self.reference, comment: path.flatMap({Path($0)})?.lastComponent),
                value: .dictionary(dictionary))
    }
}
