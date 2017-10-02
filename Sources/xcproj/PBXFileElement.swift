import Foundation

// This element is an abstract parent for file and group elements.
public class PBXFileElement: PBXObject, Hashable, Decodable {
    
    // MARK: - Attributes

    /// Element source tree.
    public var sourceTree: PBXSourceTree
    
    /// Element path.
    public var path: String
    
    /// Element name.
    public var name: String
    
    // MARK: - Init
    
    /// Initializes the file element with its properties.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - sourceTree: file source tree.
    ///   - name: file name.
    public init(reference: String,
                sourceTree: PBXSourceTree,
                path: String,
                name: String) {
        self.sourceTree = sourceTree
        self.path = path
        self.name = name
        super.init(reference: reference)
    }
    
    public static func == (lhs: PBXFileElement,
                           rhs: PBXFileElement) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.sourceTree == rhs.sourceTree &&
            lhs.path == rhs.path &&
            lhs.name == rhs.name
    }
    
    enum CodingKeys: String, CodingKey {
        case sourceTree
        case name
        case path
        case reference
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sourceTree = try container.decode(PBXSourceTree.self, forKey: .sourceTree)
        self.name = try container.decode(String.self, forKey: .name)
        self.path = try container.decode(String.self, forKey: .path)
        let reference = try container.decode(String.self, forKey: .reference)
        super.init(reference: reference)
    }
    
}

// MARK: - PBXFileElement Extension (PlistSerializable)

extension PBXFileElement: PlistSerializable {
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXFileElement.isa))
        dictionary["name"] = .string(CommentedString(name))
        dictionary["path"] = .string(CommentedString(path))
        dictionary["sourceTree"] = sourceTree.plist()
        return (key: CommentedString(self.reference,
                                     comment: self.name),
                value: .dictionary(dictionary))
    }
    
}
