import Foundation

// This element indicate a file reference that is used in a PBXBuildPhase (either as an include or resource).
public struct PBXBuildFile {
    
    // MARK: - Attributes
    
    let reference: UUID
    let isa: String = "PBXBuildFile"
    let fileRef: PBXFileReference
    let settings: [String: Any]
    
}
