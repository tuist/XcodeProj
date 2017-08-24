import Foundation
import Unbox

// This is the element for the resources copy build phase.
public class PBXResourcesBuildPhase: ProjectElement {
    
    /// Element build action mask.
    public var buildActionMask: Int
    
    /// Element files.
    public var files: Set<String>
    
    /// Element run only for deployment post processing value.
    public var runOnlyForDeploymentPostprocessing: Int
    
    /// Initializes the resources build phase with its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - files: element files.
    ///   - runOnlyForDeploymentPostprocessing: run only for deployment post processing value.
    public init(reference: String,
                files: Set<String>,
                runOnlyForDeploymentPostprocessing: Int = 0,
                buildActionMask: Int = 2147483647) {
        self.files = files
        self.runOnlyForDeploymentPostprocessing = runOnlyForDeploymentPostprocessing
        self.buildActionMask = buildActionMask
        super.init(reference: reference)
    }
    
    public static var isa: String = "PBXResourcesBuildPhase"

    public override init(reference: String, dictionary: [String: Any]) throws {
        let unboxer = Unboxer(dictionary: dictionary)
        self.files = (unboxer.unbox(key: "files")) ?? []
        self.runOnlyForDeploymentPostprocessing = try unboxer.unbox(key: "runOnlyForDeploymentPostprocessing")
        self.buildActionMask = try unboxer.unbox(key: "buildActionMask")
        try super.init(reference: reference, dictionary: dictionary)
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
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXResourcesBuildPhase.isa))
        dictionary["buildActionMask"] = .string(CommentedString("\(buildActionMask)"))
        dictionary["files"] = .array(files.map({ (fileReference) -> PlistValue in
            let comment = proj.buildFileName(reference: reference).flatMap({"\($0) in Resources"})
            return .string(CommentedString(fileReference, comment: comment))
        }))
        dictionary["runOnlyForDeploymentPostprocessing"] = .string(CommentedString("\(runOnlyForDeploymentPostprocessing)"))
        return (key: CommentedString(self.reference,
                                                 comment: "Resources"),
                value: .dictionary(dictionary))
    }
    
}
