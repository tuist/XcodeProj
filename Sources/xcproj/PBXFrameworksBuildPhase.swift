import Foundation

/// This is the element for the framework link build phase.
final public class PBXFrameworksBuildPhase: PBXBuildPhase, Hashable {

    public override var buildPhase: BuildPhase {
        return .frameworks
    }
    
    public static func == (lhs: PBXFrameworksBuildPhase,
                           rhs: PBXFrameworksBuildPhase) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.files == rhs.files &&
            lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing
    }
}

// MARK: - PBXFrameworksBuildPhase Extension (PlistSerializable)

extension PBXFrameworksBuildPhase: PlistSerializable {
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = plistValues(proj: proj)
        dictionary["isa"] = .string(CommentedString(PBXFrameworksBuildPhase.isa))
        return (key: CommentedString(self.reference, comment: "Frameworks"), value: .dictionary(dictionary))
    }
    
}
