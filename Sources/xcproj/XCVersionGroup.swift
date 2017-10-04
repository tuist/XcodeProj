import Foundation
import PathKit

// Group that contains multiple files references to the different versions of a resource.
// Used to contain the different versions of a xcdatamodel
public class XCVersionGroup: PBXObject, Hashable, Decodable {
    
    // MARK: - Attributes
        
    /// Current version.
    public let currentVersion: String
    
    /// Path.
    public let path: String
    
    /// Name.
    public let name: String?
    
    /// Source tree type.
    public let sourceTree: PBXSourceTree
    
    /// Version group type.
    public let versionGroupType: String
    
    /// Children references.
    public let children: [String]

    // MARK: - Init
    
    public init(reference: String,
                currentVersion: String,
                path: String,
                name: String?,
                sourceTree: PBXSourceTree,
                versionGroupType: String,
                children: [String]) {
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

    enum CodingKeys: String, CodingKey {
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
        self.currentVersion = try container.decode(String.self, forKey: .currentVersion)
        self.path = try container.decode(String.self, forKey: .path)
        self.name = try container.decode(String?.self, forKey: .name)
        self.sourceTree = try container.decode(PBXSourceTree.self, forKey: .sourceTree)
        self.versionGroupType = try container.decode(String.self, forKey: .versionGroupType)
        let children = try? container.decode([String].self, forKey: .children)
        self.children = children ?? []
        let reference = try container.decode(String.self, forKey: .reference)
        super.init(reference: reference)
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
        dictionary["path"] = .string(CommentedString(path))
        dictionary["sourceTree"] = sourceTree.plist()
        dictionary["versionGroupType"] = .string(CommentedString(versionGroupType))
        dictionary["children"] = .array(children
            .map({ fileReference in
                let comment = proj.fileName(fileReference: fileReference)
                return .string(CommentedString(fileReference, comment: comment))
            }))
        dictionary["currentVersion"] = .string(CommentedString(currentVersion, comment: proj.fileName(fileReference: currentVersion)))
        return (key: CommentedString(self.reference, comment: Path(path).lastComponent),
                value: .dictionary(dictionary))
    }
}
