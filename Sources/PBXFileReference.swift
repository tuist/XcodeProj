import Foundation
import Unbox

//  A PBXFileReference is used to track every external file referenced by 
//  the project: source files, resource files, libraries, generated application files, and so on.
public struct PBXFileReference: ProjectElement {
 
    // MARK: - Attributes
    
    /// Element reference.
    public let reference: UUID
    
    /// Element isa.
    public let isa: String = "PBXFileReference"
    
    /// Element file encoding.
    public let fileEncoding: Int?
    
    /// Element explicit file type.
    public let explicitFileType: String?
    
    /// Element last known file type.
    public let lastKnownFileType: String?
    
    /// Element name.
    public let name: String
    
    /// Element path.
    public let path: String?
 
    /// Element source tree.
    public let sourceTree: PBXSourceTree
    
    // MARK: - Init
    
    public init(reference: UUID,
                name: String,
                sourceTree: PBXSourceTree,
                fileEncoding: Int? = nil,
                explicitFileType: String? = nil,
                lastKnownFileType: String? = nil,
                path: String? = nil) {
        self.reference = reference
        self.fileEncoding = fileEncoding
        self.explicitFileType = explicitFileType
        self.lastKnownFileType = lastKnownFileType
        self.name = name
        self.path = path
        self.sourceTree = sourceTree
    }
    
    /// Constructor that initializes the project element with the reference and a dictionary with its properties.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: dictionary with the element properties.
    /// - Throws: throws an error in case any of the propeties are missing or they have the wrong type.
    public init(reference: UUID, dictionary: [String : Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.fileEncoding = unboxer.unbox(key: "fileEncoding")
        self.explicitFileType = unboxer.unbox(key: "explicitFileType")
        self.lastKnownFileType = unboxer.unbox(key: "lastKnownFileType")
        self.name = try unboxer.unbox(key: "name")
        self.path = unboxer.unbox(key: "path")
        self.sourceTree = try unboxer.unbox(key: "sourceTree")
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXFileReference,
                           rhs: PBXFileReference) -> Bool {
        return lhs.reference == rhs.reference &&
        lhs.isa == rhs.isa &&
        lhs.fileEncoding == rhs.fileEncoding &&
        lhs.explicitFileType == rhs.explicitFileType &&
        lhs.lastKnownFileType == rhs.lastKnownFileType &&
        lhs.name == rhs.name &&
        lhs.path == rhs.path &&
        lhs.sourceTree == rhs.sourceTree
    }
    
    public var hashValue: Int { return self.reference.hashValue }
}
