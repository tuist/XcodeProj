import Foundation

// This is the element for referencing other target through content proxies.
public struct PBXTargetDependency {
    
    // MARK: - Attributes
    
    public let reference: UUID
    
    public let isa: String = "PBXTargetDependency"
    
    public let target: UUID
    
    public let targetProxy: UUID
    
}
