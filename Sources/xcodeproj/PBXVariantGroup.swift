import Foundation
import Unbox

// This is the element for referencing localized resources.
public struct PBXVariantGroup: ProjectElement, PlistSerializable {
    
    // MARK: - Attributes
    
    // Variant group reference.
    public var reference: String
    
    // Variant group isa.
    public static var isa: String = "PBXVariantGroup"
    
    // The objects are a reference to a PBXFileElement element
    public var children: Set<String>
    
    // The filename
    public var name: String
    
    // Variant group source tree.
    public var sourceTree: PBXSourceTree
    
    // MARK: - Init
    
    /// Initializes the PBXVariantGroup with its values.
    ///
    /// - Parameters:
    ///   - reference: variant group reference. Will be automatically generated if not specified
    ///   - children: group children references.
    ///   - name: name of the variant group
    ///   - sourceTree: the group source tree.
    public init(reference: String? = nil,
                children: Set<String>,
                name: String,
                sourceTree: PBXSourceTree) {
        self.reference = reference ?? ReferenceGenerator.shared.generateReference(PBXVariantGroup.self, name)
        self.children = children
        self.name = name
        self.sourceTree = sourceTree
    }
    
    /// Initializes the variant group with the element reference an a dictionary with its properties.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: dictionary with the element properties.
    /// - Throws: an error in case any property is missing or the format is wrong.
    public init(reference: String, dictionary: [String: Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.children = try unboxer.unbox(key: "children")
        self.name = try unboxer.unbox(key: "name")
        self.sourceTree = try unboxer.unbox(key: "sourceTree")
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXVariantGroup,
                           rhs: PBXVariantGroup) -> Bool {
        return lhs.reference == rhs.reference &&
        lhs.children == rhs.children &&
        lhs.name == rhs.name &&
        lhs.sourceTree == rhs.sourceTree
    }
    
    public var hashValue: Int { return self.reference.hashValue }

    // MARK: - PlistSerializable
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXVariantGroup.isa))
        dictionary["name"] = .string(CommentedString(name))
        dictionary["sourceTree"] = sourceTree.plist()
        dictionary["children"] = .array(children
            .map({PlistValue.string(CommentedString($0, comment: proj.objects.fileName(from: $0)))}))
        return (key: CommentedString(self.reference,
                                                 comment: name),
                value: .dictionary(dictionary))
    }
    
}
