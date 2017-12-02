import Foundation

final public class PBXGroup: PBXFileElement {

    // MARK: - Attributes

    /// Element children.
    public var children: [String]

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
        self.usesTabs = usesTabs
        super.init(reference: reference, sourceTree: sourceTree, path: path, name: name)
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
        case usesTabs
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.children = (try container.decodeIfPresent(.children)) ?? []
        let usesTabString: String? = try container.decodeIfPresent(.usesTabs)
        self.usesTabs = usesTabString.flatMap(Int.init)
        try super.init(from: decoder)
    }
    
    // MARK: - PlistSerializable
    
    override func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = super.plistKeyAndValue(proj: proj).value.dictionary ?? [:]
        dictionary["isa"] = .string(CommentedString(PBXGroup.isa))
        dictionary["children"] = .array(children.map({ (fileReference) -> PlistValue in
            let comment = proj.fileName(fileReference: fileReference)
            return .string(CommentedString(fileReference, comment: comment))
        }))
        if let usesTabs = usesTabs {
            dictionary["usesTabs"] = .string(CommentedString("\(usesTabs)"))
        }
        return (key: CommentedString(self.reference,
                                     comment: self.name ?? self.path),
                value: .dictionary(dictionary))
    }
}
