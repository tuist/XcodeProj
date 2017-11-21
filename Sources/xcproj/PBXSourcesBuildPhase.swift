import Foundation

/// This is the element for the sources compilation build phase.
final public class PBXSourcesBuildPhase: PBXBuildPhase, Hashable {

    public override var buildPhase: BuildPhase {
        return .sources
    }

    // MARK: - Hashable
    
    public static func == (lhs: PBXSourcesBuildPhase,
                           rhs: PBXSourcesBuildPhase) -> Bool {
        return lhs.reference == rhs.reference &&
        lhs.buildActionMask == rhs.buildActionMask &&
        lhs.files == rhs.files &&
        lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing
    }
}

extension PBXSourcesBuildPhase: PlistSerializable {

    // MARK: - PlistSerializable
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = plistValues(proj: proj)
        dictionary["isa"] = .string(CommentedString(PBXSourcesBuildPhase.isa))
        return (key: CommentedString(self.reference, comment: "Sources"), value: .dictionary(dictionary))
    }
    
}
