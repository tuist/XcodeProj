import Foundation

public class PBXGroup: PBXObject, Hashable {

    // MARK: - Attributes

    /// Element children.
    public var children: [String]

    /// Element name.
    public var name: String?

    /// Element path.
    public var path: String?

    /// Element source tree.
    public var sourceTree: PBXSourceTree

    // MARK: - Init

    /// Initializes the group with its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - children: group children.
    ///   - sourceTree: group source tree.
    ///   - name: group name.
    ///   - path: group path.
    public init(reference: String,
                children: [String],
                sourceTree: PBXSourceTree,
                name: String? = nil,
                path: String? = nil) {
        self.children = children
        self.name = name
        self.sourceTree = sourceTree
        self.path = path
        super.init(reference: reference)
    }

    public static func == (lhs: PBXGroup,
                           rhs: PBXGroup) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.children == rhs.children &&
            lhs.name == rhs.name &&
            lhs.sourceTree == rhs.sourceTree &&
            lhs.path == rhs.path
    }
    
    // MARK: - Decodable
    
    fileprivate enum CodingKeys: String, CodingKey {
        case children
        case name
        case sourceTree
        case path
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(.name)
        self.children = (try container.decodeIfPresent(.children)) ?? []
        self.path = try container.decodeIfPresent(.path)
        self.sourceTree = try container.decodeIfPresent(.sourceTree) ?? .none
        try super.init(from: decoder)
    }
    
}

// MARK: - PBXGroup Extension (PlistSerializable)

extension PBXGroup: PlistSerializable {

    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXGroup.isa))
        dictionary["children"] = .array(children.map({ (fileReference) -> PlistValue in
            let comment = name(reference: fileReference, proj: proj)
            return .string(CommentedString(fileReference, comment: comment))
        }))
        if let name = name {
            dictionary["name"] = .string(CommentedString(name))
        }
        if let path = path {
            dictionary["path"] = .string(CommentedString(path))
        }
        dictionary["sourceTree"] = sourceTree.plist()
        return (key: CommentedString(self.reference,
                                                 comment: self.name ?? self.path),
                value: .dictionary(dictionary))
    }

    fileprivate func name(reference: String, proj: PBXProj) -> String? {
        if let group = proj.groups.getReference(reference) {
            return group.name ?? group.path
        } else if let variantGroup = proj.variantGroups.getReference(reference) {
            return variantGroup.name
        } else if let file = proj.fileReferences.getReference(reference) {
            return file.name ?? file.path
        }
        return nil
    }

}
