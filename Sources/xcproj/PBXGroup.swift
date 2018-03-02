import Foundation

final public class PBXGroup: PBXFileElement {

    // MARK: - Attributes

    /// Element children.
    public var children: [String]

    /// Element indent width.
    public var indentWidth: UInt?
    
    /// Element tab width.
    public var tabWidth: UInt?

    // MARK: - Init

    /// Initializes the group with its attributes.
    ///
    /// - Parameters:
    ///   - children: group children.
    ///   - sourceTree: group source tree.
    ///   - name: group name.
    ///   - path: group path.
    ///   - wrapsLines: should the IDE wrap lines for files in the group?
    ///   - usesTabs: group uses tabs.
    public init(children: [String],
                sourceTree: PBXSourceTree? = nil,
                name: String? = nil,
                path: String? = nil,
                includeInIndex: Bool? = nil,
                wrapsLines: Bool? = nil,
                usesTabs: Bool? = nil,
                indentWidth: UInt? = nil,
                tabWidth: UInt? = nil) {
        self.children = children
        self.indentWidth = indentWidth
        self.tabWidth = tabWidth
        super.init(sourceTree: sourceTree, path: path, name: name, includeInIndex: includeInIndex, usesTabs: usesTabs, wrapsLines: wrapsLines)
    }

    public override func isEqual(to object: PBXObject) -> Bool {
        guard let rhs = object as? PBXGroup,
            super.isEqual(to: rhs) else {
                return false
        }
        let lhs = self
        return lhs.children == rhs.children &&
            lhs.name == rhs.name &&
            lhs.sourceTree == rhs.sourceTree &&
            lhs.path == rhs.path &&
            lhs.indentWidth == rhs.indentWidth &&
            lhs.tabWidth == rhs.tabWidth
    }
    
    // MARK: - Decodable
    
    fileprivate enum CodingKeys: String, CodingKey {
        case children
        case indentWidth
        case tabWidth
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.children = (try container.decodeIfPresent(.children)) ?? []
        self.indentWidth = try container.decodeIntIfPresent(.indentWidth)
        self.tabWidth = try container.decodeIntIfPresent(.tabWidth)
        try super.init(from: decoder)
    }
    
    // MARK: - PlistSerializable
    
    override func plistKeyAndValue(proj: PBXProj, reference: String) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = super.plistKeyAndValue(proj: proj, reference: reference).value.dictionary ?? [:]
        dictionary["isa"] = .string(CommentedString(PBXGroup.isa))
        dictionary["children"] = .array(children.map({ (fileReference) -> PlistValue in
            let comment = proj.objects.fileName(fileReference: fileReference)
            return .string(CommentedString(fileReference, comment: comment))
        }))

        [("indentWidth" as CommentedString, indentWidth),
         ("tabWidth", tabWidth)]
            .forEach { name, valueOption in
            if let value = valueOption {
                dictionary[name] = .string(CommentedString("\(value)"))
            }
        }
        
        return (key: CommentedString(reference,
                                     comment: self.name ?? self.path),
                value: .dictionary(dictionary))
    }
}
