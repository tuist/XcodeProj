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
    @available(*, deprecated, message: "Use remote instead")
    public var remoteReference: PBXObjectReference?

    /// Element remote.
    public var remote: PBXContainerItemProxy? {
        get {
            return try! remoteReference?.object()
        }
        set {
            remoteReference = remote?.reference
        }
    }

    /// Element source tree.
    public var sourceTree: PBXSourceTree?

    // MARK: - Init

    @available(*, deprecated, message: "Use the constructor that takes objects instead of references")
    public init(fileType: String? = nil,
                path: String? = nil,
                remoteReference: PBXObjectReference? = nil,
                sourceTree: PBXSourceTree? = nil) {
        self.fileType = fileType
        self.path = path
        self.remoteReference = remoteReference
        self.sourceTree = sourceTree
        super.init()
    }

    public convenience init(fileType: String? = nil,
                            path: String? = nil,
                            remote: PBXContainerItemProxy? = nil,
                            sourceTree: PBXSourceTree? = nil) {
        self.init(fileType: fileType,
                  path: path,
                  remoteReference: remote?.reference,
                  sourceTree: sourceTree)
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case fileType
        case path
        case remoteRef
        case sourceTree
    }

    public required init(from decoder: Decoder) throws {
        let objectReferenceRepository = decoder.context.objectReferenceRepository
        let objects = decoder.context.objects
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let remoteRefString: String = try container.decodeIfPresent(.remoteRef) {
            remoteReference = objectReferenceRepository.getOrCreate(reference: remoteRefString, objects: objects)
        }
        fileType = try container.decodeIfPresent(.fileType)
        path = try container.decodeIfPresent(.path)
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
        if let remoteReference = remoteReference {
            dictionary["remoteRef"] = .string(CommentedString(remoteReference.value, comment: "PBXContainerItemProxy"))
        }
        if let sourceTree = sourceTree {
            dictionary["sourceTree"] = sourceTree.plist()
        }
        return (key: CommentedString(reference, comment: path),
                value: .dictionary(dictionary))
    }
}
