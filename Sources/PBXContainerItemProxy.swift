import Foundation
import Unbox

// This is the element for to decorate a target item.
public struct PBXContainerItemProxy: ProjectElement, Hashable {
    
    /// Element reference.
    public let reference: UUID
    
    /// Element isa.
    public let isa: String = "PBXContainerItemProxy"
    
    /// The object is a reference to a PBXProject element.
    public let containerPortal: UUID
    
    public let proxyType: UInt = 1
    
    /// Element remote global ID reference.
    public let remoteGlobalIDString: UUID
    
    /// Element remote info.
    public let remoteInfo: String
    
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
                remoteInfo: String) {
        self.reference = reference
        self.containerPortal = containerPortal
        self.remoteGlobalIDString = remoteGlobalIDString
        self.remoteInfo = remoteInfo
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
        self.remoteInfo = try unboxer.unbox(key: "remoteInfo")
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXContainerItemProxy,
                           rhs: PBXContainerItemProxy) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.isa == rhs.isa &&
            lhs.proxyType == rhs.proxyType &&
            lhs.containerPortal == rhs.containerPortal &&
            lhs.remoteGlobalIDString == rhs.remoteGlobalIDString &&
            lhs.remoteInfo == rhs.remoteInfo
    }
    
    public var hashValue: Int { return self.reference.hashValue }
}
