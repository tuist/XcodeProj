import Foundation
import Unbox

// This is the element for to decorate a target item.
public struct PBXContainerItemProxy {
    
    public enum ProxyType: UInt, UnboxableEnum {
        case nativeTarget = 1
        case reference = 2
        case other
    }
    
    /// Element reference.
    public let reference: UUID
    
    /// The object is a reference to a PBXProject element.
    public let containerPortal: UUID
    
    /// Element proxy type.
    public let proxyType: ProxyType
    
    /// Element remote global ID reference.
    public let remoteGlobalIDString: UUID
    
    /// Element remote info.
    public let remoteInfo: String?
    
    /// Initializes the container item proxy with its attributes.
    ///
    /// - Parameters:
    ///   - reference: reference to the element.
    ///   - containerPortal: reference to the container portal.
    ///   - remoteGlobalIDString: reference to the remote global ID.
    ///   - remoteInfo: remote info.
    public init(reference: UUID,
                containerPortal: UUID,
                remoteGlobalIDString: UUID,
                proxyType: ProxyType = .nativeTarget,
                remoteInfo: String? = nil) {
        self.reference = reference
        self.containerPortal = containerPortal
        self.remoteGlobalIDString = remoteGlobalIDString
        self.remoteInfo = remoteInfo
        self.proxyType = proxyType
    }
    
}

// MARK: - PBXContainerItemProxy Extension (ProjectElement)

extension PBXContainerItemProxy: ProjectElement {
    
    public static func == (lhs: PBXContainerItemProxy,
                           rhs: PBXContainerItemProxy) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.proxyType == rhs.proxyType &&
            lhs.containerPortal == rhs.containerPortal &&
            lhs.remoteGlobalIDString == rhs.remoteGlobalIDString &&
            lhs.remoteInfo == rhs.remoteInfo
    }
    
    public var hashValue: Int { return self.reference.hashValue }
    
    public init(reference: UUID, dictionary: [String: Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.containerPortal = try unboxer.unbox(key: "containerPortal")
        self.remoteGlobalIDString = try unboxer.unbox(key: "remoteGlobalIDString")
        self.remoteInfo = unboxer.unbox(key: "remoteInfo")
        let proxyTypeInt: UInt = try unboxer.unbox(key: "proxyType")
        self.proxyType = ProxyType(rawValue: proxyTypeInt) ?? .other
    }
    
}

// MARK: - PBXContainerItemProxy Extension (PlistSerializable)

extension PBXContainerItemProxy: PlistSerializable {
    
    public static var isa: String = "PBXContainerItemProxy"
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXContainerItemProxy.isa))
        dictionary["containerPortal"] = .string(CommentedString(containerPortal, comment: "Project object"))
        dictionary["proxyType"] = .string(CommentedString("\(proxyType.rawValue)"))
        dictionary["remoteGlobalIDString"] = .string(CommentedString(remoteGlobalIDString))
        if let remoteInfo = remoteInfo {
            dictionary["remoteInfo"] = .string(CommentedString(remoteInfo))
        }
        return (key: CommentedString(self.reference,
                                                 comment: "PBXContainerItemProxy"),
                value: .dictionary(dictionary))
    }

}
