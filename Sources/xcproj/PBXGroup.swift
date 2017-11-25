import Foundation

final public class PBXGroup: PBXObject, Hashable {

    // MARK: - Attributes

    /// Element children.
    public var children: [String]

    /// Element name.
    public var name: String?

    /// Element path.
    public var path: String?

    /// Element source tree.
    public var sourceTree: PBXSourceTree?

    /// Element uses tabs.
    public var usesTabs: Int?

    // MARK: - Init

    /// Initializes the group with its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - children: group children.
    ///   - sourceTree: group source tree.
    ///   - name: group name.
    ///   - path: group path.
    ///   - usesTabs: group uses tabs.
    public init(reference: String,
                children: [String],
                sourceTree: PBXSourceTree? = nil,
                name: String? = nil,
                path: String? = nil,
                usesTabs: Int? = nil) {
        self.children = children
        self.name = name
        self.sourceTree = sourceTree
        self.path = path
        self.usesTabs = usesTabs
        super.init(reference: reference)
    }

    public static func == (lhs: PBXGroup,
                           rhs: PBXGroup) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.children == rhs.children &&
            lhs.name == rhs.name &&
            lhs.sourceTree == rhs.sourceTree &&
            lhs.path == rhs.path &&
            lhs.usesTabs == rhs.usesTabs
    }
    
    // MARK: - Decodable
    
    fileprivate enum CodingKeys: String, CodingKey {
        case children
        case name
        case sourceTree
        case path
        case usesTabs
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(.name)
        self.children = (try container.decodeIfPresent(.children)) ?? []
        self.path = try container.decodeIfPresent(.path)
        self.sourceTree = try container.decodeIfPresent(.sourceTree)
        let usesTabString: String? = try container.decodeIfPresent(.usesTabs)
        self.usesTabs = usesTabString.flatMap(Int.init)
        try super.init(from: decoder)
    }
    
}

// MARK: - PBXGroup Extension (PlistSerializable)

extension PBXGroup: PlistSerializable {

    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXGroup.isa))
        dictionary["children"] = .array(children.map({ (fileReference) -> PlistValue in
            let comment = proj.fileName(fileReference: fileReference)
            return .string(CommentedString(fileReference, comment: comment))
        }))
        if let name = name {
            dictionary["name"] = .string(CommentedString(name))
        }
        if let path = path {
            dictionary["path"] = .string(CommentedString(path))
        }
        if let sourceTree = sourceTree {
            dictionary["sourceTree"] = sourceTree.plist()
        }
        if let usesTabs = usesTabs {
            dictionary["usesTabs"] = .string(CommentedString("\(usesTabs)"))
        }
        return (key: CommentedString(self.reference,
                                                 comment: self.name ?? self.path),
                value: .dictionary(dictionary))
    }

}
