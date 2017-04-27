import Foundation

// This is the element for the resources copy build phase.
public struct PBXShellScriptBuildPhase {

    // MARK: - Attributes
    
    public let reference: UUID
    public let isa: String = "PBXShellScriptBuildPhase"
    public let buildActionMask: Int = 2147483647
    public let files: [UUID]
    public let inputPaths: [String]
    public let outputPaths: [String]
    public let runOnlyForDeploymentPostprocessing: Int = 0
    public let shellPath: String
    public let shellScript: String

}
