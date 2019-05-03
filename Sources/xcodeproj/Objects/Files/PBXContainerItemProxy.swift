import Foundation

/// This is the element to decorate a target item.
public final class PBXContainerItemProxy: PBXObject {
    public enum ProxyType: UInt, Decodable {
        case nativeTarget = 1
        case reference = 2
        case other
    }

    /// The object is a reference to a PBXProject element.
    var containerPortalReference: PBXObjectReference

    /// Returns the project that contains the remote object.
    public var containerPortal: PBXProject! {
        get {
            return containerPortalReference.getObject()
        }
        set {
            containerPortalReference = newValue.reference
        }
    }

    /// Element proxy type.
    public var proxyType: ProxyType?

    /// Element remote global ID reference.
    var remoteGlobalIDReference: PBXObjectReference?

    /// Remote global object
    public var remoteGlobalID: PBXObject? {
        get {
            return remoteGlobalIDReference?.getObject()
        }
        set {
            remoteGlobalIDReference = newValue?.reference
        }
    }

    /// Element remote info.
    public var remoteInfo: String?

    /// Initializes the container item proxy with its attributes.
    ///
    /// - Parameters:
    ///   - containerPortal: container portal.
    ///   - remoteGlobalID: remote global ID.
    ///   - proxyType: proxy type.
    ///   - remoteInfo: remote info.
    public init(containerPortal: PBXObject,
                remoteGlobalID: PBXObject? = nil,
                proxyType: ProxyType? = nil,
                remoteInfo: String? = nil) {
        containerPortalReference = containerPortal.reference
        remoteGlobalIDReference = remoteGlobalID?.reference
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
        if let remoteGlobalIDString: String = try container.decodeIfPresent(.remoteGlobalIDString) {
            remoteGlobalIDReference = objectReferenceRepository.getOrCreate(reference: remoteGlobalIDString,
                                                                            objects: objects)
        } else {
            remoteGlobalIDReference = nil
        }
        remoteInfo = try container.decodeIfPresent(.remoteInfo)
        try super.init(from: decoder)
    }
}

// MARK: - PBXContainerItemProxy Extension (PlistSerializable)

extension PBXContainerItemProxy: PlistSerializable {
    func plistKeyAndValue(proj _: PBXProj, reference: String) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXContainerItemProxy.isa))
        dictionary["containerPortal"] = .string(CommentedString(containerPortalReference.value, comment: "Project object"))
        if let proxyType = proxyType {
            dictionary["proxyType"] = .string(CommentedString("\(proxyType.rawValue)"))
        }
        if let remoteGlobalIDReference = remoteGlobalIDReference {
            dictionary["remoteGlobalIDString"] = .string(CommentedString(remoteGlobalIDReference.value))
        }
        if let remoteInfo = remoteInfo {
            dictionary["remoteInfo"] = .string(CommentedString(remoteInfo))
        }
        return (key: CommentedString(reference,
                                     comment: "PBXContainerItemProxy"),
                value: .dictionary(dictionary))
    }
}
