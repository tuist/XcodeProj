import Foundation

public enum ContainerPortal {
    case project(PBXProject)                /// Project where the proxied object is located in
    case fileReference(PBXFileReference)    /// File reference to .xcodeproj where the proxied object is located
    case unknownObject(PBXObject?)          /// This is used only for reading from corrupted projects. Don't use it.
}

/// This is the element to decorate a target item.
public final class PBXContainerItemProxy: PBXObject {
    public enum ProxyType: UInt, Decodable {
        case nativeTarget = 1
        case reference = 2
        case other
    }

    /// The object is a reference to a PBXProject element if proxy is for the object located in current .xcodeproj, otherwise PBXFileReference.
    var containerPortalReference: PBXObjectReference

    /// Returns the project that contains the remote object. If container portal is a remote project this getter will fail. Use isContainerPortalFileReference to check if you can use the getter
    public var containerPortal: ContainerPortal {
        get {
            return ContainerPortal(object: containerPortalReference.getObject())
        }
        set {
            guard let reference = newValue.reference else { fatalError("Container portal is mandatory field that has to be set to a known value instead of: \(newValue)") }
            containerPortalReference = reference
        }
    }

    /// Element proxy type.
    public var proxyType: ProxyType?

    /// Element remote global ID reference. ID of the proxied object.
    public var remoteGlobalIDString: String?

    /// Element remote info.
    public var remoteInfo: String?

    /// Initializes the container item proxy with its attributes.
    /// Use this initializer if the proxy is for an object within the same .pbxproj file.
    ///
    /// - Parameters:
    ///   - containerPortal: container portal. For proxied object located in the same .xcodeproj use .project. For remote object use .fileReference with PBXFileRefence of remote .xcodeproj
    ///   - remoteGlobalIDString: ID of the proxied object. Can be ID from remote .xcodeproj referenced if containerPortal is .fileReference
    ///   - proxyType: proxy type.
    ///   - remoteInfo: remote info.
    public init(containerPortal: ContainerPortal,
                remoteGlobalIDString: String? = nil,
                proxyType: ProxyType? = nil,
                remoteInfo: String? = nil) {
        guard let containerPortalReference = containerPortal.reference else { fatalError("Container portal is mandatory field that has to be set to a known value instead of: \(containerPortal)") }
        self.containerPortalReference = containerPortalReference
        self.remoteGlobalIDString = remoteGlobalIDString
        self.remoteInfo = remoteInfo
        self.proxyType = proxyType
        super.init()
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case containerPortal
        case proxyType
        case remoteGlobalIDString
        case remoteInfo
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let objects = decoder.context.objects
        let objectReferenceRepository = decoder.context.objectReferenceRepository
        let containerPortalString: String = try container.decode(.containerPortal)
        containerPortalReference = objectReferenceRepository.getOrCreate(reference: containerPortalString,
                                                                         objects: objects)

        proxyType = try container.decodeIntIfPresent(.proxyType).flatMap(ProxyType.init)
        remoteGlobalIDString = try container.decodeIfPresent(.remoteGlobalIDString)
        remoteInfo = try container.decodeIfPresent(.remoteInfo)
        try super.init(from: decoder)
    }
}

// MARK: - PBXContainerItemProxy Extension (PlistSerializable)

extension PBXContainerItemProxy: PlistSerializable {
    func plistKeyAndValue(proj _: PBXProj, reference: String) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXContainerItemProxy.isa))
        dictionary["containerPortal"] = .string(CommentedString(containerPortalReference.value, comment: containerPortal.comment))
        if let proxyType = proxyType {
            dictionary["proxyType"] = .string(CommentedString("\(proxyType.rawValue)"))
        }
        if let remoteGlobalIDString = remoteGlobalIDString {
            dictionary["remoteGlobalIDString"] = .string(CommentedString(remoteGlobalIDString))
        }
        if let remoteInfo = remoteInfo {
            dictionary["remoteInfo"] = .string(CommentedString(remoteInfo))
        }
        return (key: CommentedString(reference,
                                     comment: "PBXContainerItemProxy"),
                value: .dictionary(dictionary))
    }
}

private extension ContainerPortal {
    init(object: PBXObject?) {
        if let project = object as? PBXProject {
            self = .project(project)
        } else if let fileReference = object as? PBXFileReference {
            self = .fileReference(fileReference)
        } else {
            self = .unknownObject(object)
        }
    }

    var reference: PBXObjectReference? {
        switch self {
        case .project(let project):
            return project.reference
        case .fileReference(let fileReference):
            return fileReference.reference
        case .unknownObject(_):
            return nil
        }
    }

    var comment: String {
        let defaultComment = "Project object"
        switch self {
        case .fileReference(let fileReference):
            return fileReference.name ?? defaultComment
        default:
            return defaultComment
        }
    }
}
