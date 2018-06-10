import Foundation

/// This is the element to decorate a target item.
public final class PBXContainerItemProxy: PBXObject {
    public enum ProxyType: UInt, Decodable {
        case nativeTarget = 1
        case reference = 2
        case other
    }

    /// The object is a reference to a PBXProject element.
    public var containerPortalReference: PBXObjectReference

    /// Element proxy type.
    public var proxyType: ProxyType?

    /// Element remote global ID reference.
    public var remoteGlobalIDReference: PBXObjectReference?

    /// Element remote info.
    public var remoteInfo: String?

    /// Initializes the container item proxy with its attributes.
    ///
    /// - Parameters:
    ///   - containerPortalReference: reference to the container portal.
    ///   - remoteGlobalIDReference: reference to the remote global ID.
    ///   - proxyType: proxy type.
    ///   - remoteInfo: remote info.
    public init(containerPortalReference: PBXObjectReference,
                remoteGlobalIDReference: PBXObjectReference? = nil,
                proxyType: ProxyType? = nil,
                remoteInfo: String? = nil) {
        self.containerPortalReference = containerPortalReference
        self.remoteGlobalIDReference = remoteGlobalIDReference
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
