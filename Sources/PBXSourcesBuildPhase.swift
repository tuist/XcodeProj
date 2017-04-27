import Foundation

// This is the element for the sources compilation build phase.
public struct PBXSourcesBuildPhase {
    
    // MARK: - Attributes
    
    public let reference: UUID
    public let isa: String = "PBXSourcesBuildPhase"
    public let buildActionMask: Int = 2147483647
    public let files: [UUID]
    public let runOnlyForDeploymentPostprocessing: Int = 0
    
}
