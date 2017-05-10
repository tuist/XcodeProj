import Foundation
import Unbox

// This element is an abstract parent for file and group elements.
public struct PBXFileElement: ProjectElement, Hashable {
    
    // MARK: - Attributes

    /// Element reference.
    public let reference: UUID
    
    /// Element isa.
    public let isa: String = "PBXFileElement"
    
    /// Element source tree.
    public let sourceTree: PBXSourceTree
    
    /// Element path.
    public let path: String
    
    /// Element name.
    public let name: String
    
    // MARK: - Init
    
    /// Initializes the file element with its properties.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - sourceTree: file source tree.
    ///   - path: file path.
    ///   - name: file name.
    public init(reference: UUID,
                sourceTree: PBXSourceTree,
                path: String,
                name: String) {
        self.reference = reference
        self.sourceTree = sourceTree
        self.path = path
        self.name = name
    }
    
    /// Initializes the file element with its reference and a dictionary that contains its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: element dictionary.
    /// - Throws: an error in case any of the attributes are missing or it has the wrong type.
    public init(reference: UUID, dictionary: [String : Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.sourceTree = try unboxer.unbox(key: "sourceTree")
        self.path = try unboxer.unbox(key: "path")
        self.name = try unboxer.unbox(key: "name")
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXFileElement,
                           rhs: PBXFileElement) -> Bool {
        return lhs.isa == rhs.isa &&
        lhs.reference == rhs.reference &&
        lhs.sourceTree == rhs.sourceTree &&
        lhs.path == rhs.path &&
        lhs.name == rhs.name
    }
    
    public var hashValue: Int { return self.reference.hashValue }
    
}
