import Foundation

// This is the element for referencing localized resources.
public class PBXVariantGroup: PBXObject, Hashable {
    
    // MARK: - Attributes
    
    // The objects are a reference to a PBXFileElement element
    public var children: [String]
    
    // The filename
    public var name: String
    
    // Variant group source tree.
    public var sourceTree: PBXSourceTree
    
    // MARK: - Init
    
    /// Initializes the PBXVariantGroup with its values.
    ///
    /// - Parameters:
    ///   - reference: variant group reference.
    ///   - children: group children references.
    ///   - name: name of the variant group
    ///   - sourceTree: the group source tree.
    public init(reference: String,
                children: [String],
                name: String,
                sourceTree: PBXSourceTree) {
        self.children = children
        self.name = name
        self.sourceTree = sourceTree
        super.init(reference: reference)
    }
    
    // MARK: - Decodable
    
    fileprivate enum CodingKeys: String, CodingKey {
        case children
        case name
        case sourceTree
        case reference
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.children = try container.decode([String].self, forKey: .children)
        self.name = try container.decode(String.self, forKey: .name)
        self.sourceTree = try container.decode(PBXSourceTree.self, forKey: .sourceTree)
        try super.init(from: decoder)
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXVariantGroup,
                           rhs: PBXVariantGroup) -> Bool {
        return lhs.reference == rhs.reference &&
        lhs.children == rhs.children &&
        lhs.name == rhs.name &&
        lhs.sourceTree == rhs.sourceTree
    }
}

// MARK: - PlistSerializable
extension PBXVariantGroup: PlistSerializable {

    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXVariantGroup.isa))
        dictionary["name"] = .string(CommentedString(name))
        dictionary["sourceTree"] = sourceTree.plist()
        dictionary["children"] = .array(children
            .map({PlistValue.string(CommentedString($0, comment: proj.fileName(from: $0)))}))
        return (key: CommentedString(self.reference,
                                                 comment: name),
                value: .dictionary(dictionary))
    }
    
}
