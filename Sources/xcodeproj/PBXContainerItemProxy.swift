import Foundation
import Unbox

// This is the element for to decorate a target item.
public struct PBXContainerItemProxy: ProjectElement, Hashable {
    
    public enum ProxyType: UInt, UnboxableEnum {
        case targetReference = 1
        case other
    }
    
    /// Element reference.
    public let reference: UUID
    
    /// Element isa.
    public static var isa: String = "PBXContainerItemProxy"
    
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
                proxyType: ProxyType = .targetReference,
                remoteInfo: String? = nil) {
        self.reference = reference
        self.containerPortal = containerPortal
        self.remoteGlobalIDString = remoteGlobalIDString
        self.remoteInfo = remoteInfo
        self.proxyType = proxyType
    }
    
    // MARK: - Init
    
    /// Initializes the container with the reference and a dictionary that contains all its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: dictionary with the attributes.
    public init(reference: UUID, dictionary: [String: Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.containerPortal = try unboxer.unbox(key: "containerPortal")
        self.remoteGlobalIDString = try unboxer.unbox(key: "remoteGlobalIDString")
        self.remoteInfo = unboxer.unbox(key: "remoteInfo")
        let proxyTypeInt: UInt = try unboxer.unbox(key: "proxyType")
        self.proxyType = ProxyType(rawValue: proxyTypeInt) ?? .other
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXContainerItemProxy,
                           rhs: PBXContainerItemProxy) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.proxyType == rhs.proxyType &&
            lhs.containerPortal == rhs.containerPortal &&
            lhs.remoteGlobalIDString == rhs.remoteGlobalIDString &&
            lhs.remoteInfo == rhs.remoteInfo
    }
    
    public var hashValue: Int { return self.reference.hashValue }
    
}
