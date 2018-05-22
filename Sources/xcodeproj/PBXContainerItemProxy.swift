import Foundation

/// This is the element to decorate a target item.
public final class PBXContainerItemProxy: PBXObject {
    public enum ProxyType: UInt, Decodable {
        case nativeTarget = 1
        case reference = 2
        case other
    }

    /// The object is a reference to a PBXProject element.
    public var containerPortal: PBXObjectReference

    /// Element proxy type.
    public var proxyType: ProxyType?

    /// Element remote global ID reference.
    public var remoteGlobalID: PBXObjectReference?

    /// Element remote info.
    public var remoteInfo: String?

    /// Initializes the container item proxy with its attributes.
    ///
    /// - Parameters:
    ///   - reference: reference to the element.
    ///   - containerPortal: reference to the container portal.
    ///   - remoteGlobalID: reference to the remote global ID.
    ///   - remoteInfo: remote info.
    public init(containerPortal: PBXObjectReference,
                remoteGlobalID: PBXObjectReference? = nil,
                proxyType: ProxyType? = nil,
                remoteInfo: String? = nil) {
        self.containerPortal = containerPortal
        self.remoteGlobalID = remoteGlobalID
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
        containerPortal = objectReferenceRepository.getOrCreate(reference: containerPortalString,
                                                                objects: objects)
        proxyType = try container.decodeIntIfPresent(.proxyType).flatMap(ProxyType.init)
        if let remoteGlobalIDString: String = try container.decodeIfPresent(.remoteGlobalIDString) {
            remoteGlobalID = objectReferenceRepository.getOrCreate(reference: remoteGlobalIDString,
                                                                   objects: objects)
        } else {
            remoteGlobalID = nil
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
        dictionary["containerPortal"] = .string(CommentedString(containerPortal.value, comment: "Project object"))
        if let proxyType = proxyType {
            dictionary["proxyType"] = .string(CommentedString("\(proxyType.rawValue)"))
        }
        if let remoteGlobalID = remoteGlobalID {
            dictionary["remoteGlobalIDString"] = .string(CommentedString(remoteGlobalID.value))
        }
        if let remoteInfo = remoteInfo {
            dictionary["remoteInfo"] = .string(CommentedString(remoteInfo))
        }
        return (key: CommentedString(reference,
                                     comment: "PBXContainerItemProxy"),
                value: .dictionary(dictionary))
    }
}
