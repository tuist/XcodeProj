import Foundation
import Unbox

// An absctract class for all the build phase objects
public class PBXBuildPhase: PBXObject {

    /// Element build action mask.
    public var buildActionMask: UInt

    /// Element files.
    public var files: Set<String>

    /// Element run only for deployment post processing value.
    public var runOnlyForDeploymentPostprocessing: UInt

    public init(reference: String,
                files: Set<String> = [],
                buildActionMask: UInt = 2147483647,
                runOnlyForDeploymentPostprocessing: UInt = 0) {
        self.files = files
        self.buildActionMask = buildActionMask
        self.runOnlyForDeploymentPostprocessing = runOnlyForDeploymentPostprocessing
        super.init(reference: reference)
    }

    public override init(reference: String, dictionary: [String: Any]) throws {
        let unboxer = Unboxer(dictionary: dictionary)
        self.files = try unboxer.unbox(key: "files")
        self.buildActionMask = try unboxer.unbox(key: "buildActionMask")
        self.runOnlyForDeploymentPostprocessing = try unboxer.unbox(key: "runOnlyForDeploymentPostprocessing")
        try super.init(reference: reference, dictionary: dictionary)
    }

    public static func == (lhs: PBXBuildPhase,
                           rhs: PBXBuildPhase) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.files == rhs.files &&
            lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing
    }
}
