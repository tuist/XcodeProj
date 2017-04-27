import Foundation

// This is the element for the resources copy build phase.
public struct PBXResourcesBuildPhase {
    
    public let reference: UUID
    public let isa: String = "PBXResourcesBuildPhase"
    public let buildActionMask: Int = 2147483647
    public let files: [UUID]
    public let runOnlyForDeploymentPostprocessing: Int = 0
    
}
