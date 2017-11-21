import Foundation

/// This is the element for the resources copy build phase.
final public class PBXResourcesBuildPhase: PBXBuildPhase, Hashable {

    public override var buildPhase: BuildPhase {
        return .resources
    }
    
    public static func == (lhs: PBXResourcesBuildPhase,
                           rhs: PBXResourcesBuildPhase) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.buildActionMask == rhs.buildActionMask &&
            lhs.files == rhs.files &&
            lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing
    }

}

// MARK: - PBXResourcesBuildPhase Extension (PlistSerializable)

extension PBXResourcesBuildPhase: PlistSerializable {

    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = plistValues(proj: proj)        
        dictionary["isa"] = .string(CommentedString(PBXResourcesBuildPhase.isa))
        return (key: CommentedString(self.reference, comment: "Resources"), value: .dictionary(dictionary))
    }
}
