import Foundation

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
    public var containerPortal: PBXProject! {
        get {
            return containerPortalReference.getObject()
        }
        set {
            containerPortalReference = newValue.reference
        }
    }

    /// Returns file reference of the remote xcodeproj bundle. Use isContainerPortalFileReference to check if you can use the getter.
    public var containerPortalAsFileReference: PBXFileReference! {
        get {
            return containerPortalReference.getObject()
        }
        set {
            containerPortalReference = newValue.reference
        }
    }

    public var isContainerPortalFileReference: Bool {
        return containerPortalReference.getObject() as? PBXFileReference != nil
    }

    /// Element proxy type.
    public var proxyType: ProxyType?

    /// Element remote global ID reference.
    var remoteGlobalIDReference: PBXObjectReference?

    /// Remote global object. When referencing objects in remote .xcodeproj this will return nil, for such case use remoteGlobalIDString.
    public var remoteGlobalID: PBXObject? {
        get {
            return remoteGlobalIDReference?.getObject()
        }
        set {
            remoteGlobalIDReference = newValue?.reference
        }
    }

    /// The value of remoteGlobalIDString property in pbxproj. Use this accessor if the object is in remote .xcodeproj.
    public var remoteGlobalIDString: String? {
        get {
            return remoteGlobalIDReference?.value
        }
        set {
            remoteGlobalIDReference = newValue.map { PBXObjectReference($0) }
        }
    }

    /// Element remote info.
    public var remoteInfo: String?

    init(containerPortalReference: PBXObjectReference,
         remoteGlobalIDReference: PBXObjectReference? = nil,
         proxyType: ProxyType? = nil,
         remoteInfo: String? = nil) {
        self.containerPortalReference = containerPortalReference
        self.remoteGlobalIDReference = remoteGlobalIDReference
        self.remoteInfo = remoteInfo
        self.proxyType = proxyType
        super.init()
    }

    /// Initializes the container item proxy with its attributes.
    /// Use this initializer if the proxy is for an object within the same .pbxproj file.
    ///
    /// - Parameters:
    ///   - containerPortal: container portal. PBXProject object located in current .xcodeproj
    ///   - remoteGlobalID: remote global ID.
    ///   - proxyType: proxy type.
    ///   - remoteInfo: remote info.
    public convenience init(containerPortal: PBXObject,
                            remoteGlobalID: PBXObject? = nil,
                            proxyType: ProxyType? = nil,
                            remoteInfo: String? = nil) {
        self.init(containerPortalReference: containerPortal.reference,
                  remoteGlobalIDReference: remoteGlobalID?.reference,
                  proxyType: proxyType,
                  remoteInfo: remoteInfo)
    }

    /// Initializes the container item proxy with its attributes.
    /// Use this initializer if the proxy is for an object residing in referenced .pbxproj file.
    ///
    /// - Parameters:
    ///   - containerPortal: file reference to external .xcodeproj.
    ///   - remoteGlobalID: string object ID within the remote project.
    ///   - proxyType: proxy type.
    ///   - remoteInfo: remote info.
    public convenience init(containerPortal: PBXFileReference,
                            remoteGlobalID: String? = nil,
                            proxyType: ProxyType? = nil,
                            remoteInfo: String? = nil) {
        self.init(containerPortalReference: containerPortal.reference,
                  remoteGlobalIDReference: remoteGlobalID.map { PBXObjectReference($0) },
                  proxyType: proxyType,
                  remoteInfo: remoteInfo)
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
        dictionary["containerPortal"] = .string(CommentedString(containerPortalReference.value, comment: isContainerPortalFileReference ? containerPortalAsFileReference.name : "Project object"))
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
