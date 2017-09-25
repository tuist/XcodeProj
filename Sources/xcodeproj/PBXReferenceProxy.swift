import Foundation
import Unbox

/// A proxy for another object which might belong to another project
/// contained in the same workspace of the document.
/// This class is referenced by PBXTargetDependency.
public class PBXReferenceProxy: PBXObject, Hashable {
    
    // MARK: - Attributes
    
    // Element file type
    public var fileType: String
    
    // Element path.
    public var path: String
    
    // Element remote reference.
    public var remoteRef: String
    
    // Element source tree.
    public var sourceTree: PBXSourceTree
    
    // MARK: - Init
    
    public init(reference: String,
                fileType: String,
                path: String,
                remoteRef: String,
                sourceTree: PBXSourceTree) {
        self.fileType = fileType
        self.path = path
        self.remoteRef = remoteRef
        self.sourceTree = sourceTree
        super.init(reference: reference)
    }
    
    /// Initializes the reference proxy with the element reference an a dictionary with its properties.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: dictionary with the element properties.
    /// - Throws: an error in case any property is missing or the format is wrong.
    public override init(reference: String, dictionary: [String: Any]) throws {
        let unboxer = Unboxer(dictionary: dictionary)
        self.fileType = try unboxer.unbox(key: "fileType")
        self.path = try unboxer.unbox(key: "path")
        self.remoteRef = try unboxer.unbox(key: "remoteRef")
        self.sourceTree = try unboxer.unbox(key: "sourceTree")
        try super.init(reference: reference, dictionary: dictionary)
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXReferenceProxy,
                           rhs: PBXReferenceProxy) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.fileType == rhs.fileType &&
            lhs.path == rhs.path &&
            lhs.remoteRef == rhs.remoteRef &&
            lhs.sourceTree == rhs.sourceTree
    }
}

// MARK: - PBXReferenceProxy
extension PBXReferenceProxy: PlistSerializable {
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXVariantGroup.isa))
        dictionary["fileType"] = .string(CommentedString(fileType))
        dictionary["path"] = .string(CommentedString(path))
        dictionary["remoteRef"] = .string(CommentedString(remoteRef, comment: "PBXContainerItemProxy"))
        dictionary["sourceTree"] = sourceTree.plist()
        return (key: CommentedString(self.reference, comment: path),
                value: .dictionary(dictionary))
    }
    
}
