import Foundation
import Unbox

// This element is an abstract parent for file and group elements.
public struct PBXFileElement {
    
    // MARK: - Attributes

    /// Element reference.
    public var reference: String
    
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
        self.reference = reference
        self.sourceTree = sourceTree
        self.path = path
        self.name = name
    }
    
}

// MARK: - PBXFileElement Extension (ProjectElement)

extension PBXFileElement: ProjectElement {
    
    public static var isa: String = "PBXFileElement"
    
    public static func == (lhs: PBXFileElement,
                           rhs: PBXFileElement) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.sourceTree == rhs.sourceTree &&
            lhs.path == rhs.path &&
            lhs.name == rhs.name
    }
    
    public var hashValue: Int { return self.reference.hashValue }
    
    public init(reference: String, dictionary: [String : Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.sourceTree = try unboxer.unbox(key: "sourceTree")
        self.path = try unboxer.unbox(key: "path")
        self.name = try unboxer.unbox(key: "name")
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
