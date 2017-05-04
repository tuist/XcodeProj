import Foundation

// This is the element for to decorate a target item.
public struct PBXContainerItemProxy: Isa {
    
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
    
}
