import Foundation

/// A proxy for another object which might belong to another project
/// contained in the same workspace of the document.
/// This class is referenced by PBXTargetDependency.
public final class PBXReferenceProxy: PBXObject {

    // MARK: - Attributes

    /// Element file type
    public var fileType: String?

    /// Element path.
    public var path: String?

    /// Element remote reference.
    public var remoteRef: String?

    /// Element source tree.
    public var sourceTree: PBXSourceTree?

    // MARK: - Init

    public init(fileType: String? = nil,
                path: String? = nil,
                remoteRef: String? = nil,
                sourceTree: PBXSourceTree? = nil) {
        self.fileType = fileType
        self.path = path
        self.remoteRef = remoteRef
        self.sourceTree = sourceTree
        super.init()
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case fileType
        case path
        case remoteRef
        case sourceTree
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fileType = try container.decodeIfPresent(.fileType)
        path = try container.decodeIfPresent(.path)
        remoteRef = try container.decodeIfPresent(.remoteRef)
        sourceTree = try container.decodeIfPresent(.sourceTree)
        try super.init(from: decoder)
    }
}

// MARK: - PBXReferenceProxy

extension PBXReferenceProxy: PlistSerializable {
    func plistKeyAndValue(proj _: PBXProj, reference: String) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXReferenceProxy.isa))
        if let fileType = fileType {
            dictionary["fileType"] = .string(CommentedString(fileType))
        }
        if let path = path {
            dictionary["path"] = .string(CommentedString(path))
        }
        if let remoteRef = remoteRef {
            dictionary["remoteRef"] = .string(CommentedString(remoteRef, comment: "PBXContainerItemProxy"))
        }
        if let sourceTree = sourceTree {
            dictionary["sourceTree"] = sourceTree.plist()
        }
        return (key: CommentedString(reference, comment: path),
                value: .dictionary(dictionary))
    }
}
