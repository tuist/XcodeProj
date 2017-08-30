import Foundation
import Unbox
import PathKit

// Group that contains multiple files references to the different versions of a resource.
// Used to contain the different versions of a xcdatamodel
public class XCVersionGroup: PBXObject, Hashable {
    
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
    
    override init(reference: String, dictionary: [String : Any]) throws {
        let unboxer = Unboxer(dictionary: dictionary)
        self.currentVersion = try unboxer.unbox(key: "currentVersion")
        self.path = try unboxer.unbox(key: "path")
        self.name = unboxer.unbox(key: "name")
        self.sourceTree = try unboxer.unbox(key: "sourceTree")
        self.versionGroupType = try unboxer.unbox(key: "versionGroupType")
        self.children = (try? unboxer.unbox(key: "children")) ?? []
        try super.init(reference: reference, dictionary: dictionary)
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


