import Foundation
import Unbox

// This is the element for to decorate a target item.
public class PBXContainerItemProxy: ProjectElement {

    public enum ProxyType: UInt, UnboxableEnum {
        case nativeTarget = 1
        case reference = 2
        case other
    }
    
    /// The object is a reference to a PBXProject element.
    public var containerPortal: String
    
    /// Element proxy type.
    public var proxyType: ProxyType
    
    /// Element remote global ID reference.
    public var remoteGlobalIDString: String
    
    /// Element remote info.
    public var remoteInfo: String?
    
    /// Initializes the container item proxy with its attributes.
    ///
    /// - Parameters:
    ///   - reference: reference to the element.
    ///   - containerPortal: reference to the container portal.
    ///   - remoteGlobalIDString: reference to the remote global ID.
    ///   - remoteInfo: remote info.
    public init(reference: String,
                containerPortal: String,
                remoteGlobalIDString: String,
                proxyType: ProxyType = .nativeTarget,
                remoteInfo: String? = nil) {
        self.containerPortal = containerPortal
        self.remoteGlobalIDString = remoteGlobalIDString
        self.remoteInfo = remoteInfo
        self.proxyType = proxyType
        super.init(reference: reference)
    }
    
    public static func == (lhs: PBXContainerItemProxy,
                           rhs: PBXContainerItemProxy) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.proxyType == rhs.proxyType &&
            lhs.containerPortal == rhs.containerPortal &&
            lhs.remoteGlobalIDString == rhs.remoteGlobalIDString &&
            lhs.remoteInfo == rhs.remoteInfo
    }
    
    public override init(reference: String, dictionary: [String: Any]) throws {
        let unboxer = Unboxer(dictionary: dictionary)
        self.containerPortal = try unboxer.unbox(key: "containerPortal")
        self.remoteGlobalIDString = try unboxer.unbox(key: "remoteGlobalIDString")
        self.remoteInfo = unboxer.unbox(key: "remoteInfo")
        let proxyTypeInt: UInt = try unboxer.unbox(key: "proxyType")
        self.proxyType = ProxyType(rawValue: proxyTypeInt) ?? .other
        try super.init(reference: reference, dictionary: dictionary)
    }
    
}

// MARK: - PBXContainerItemProxy Extension (PlistSerializable)

extension PBXContainerItemProxy: PlistSerializable {
    
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
