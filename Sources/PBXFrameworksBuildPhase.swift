import Foundation
import Unbox

// This is the element for the framewrok link build phase.
public final class PBXFrameworksBuildPhase {
    
    // MARK: - Properties
    
    /// Element reference.
    public var reference: String
    
    /// Framework build phase files.
    public var files: Set<String>
    
    /// Build phase build action mask.
    public var buildActionMask: Int
    
    /// Build phase run only for deployment post processing.
    public var runOnlyForDeploymentPostprocessing: UInt
    
    // MARK: - Init
    
    /// Initializes the frameworks build phase with its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - files: frameworks build phase files.
    ///   - runOnlyForDeploymentPostprocessing: run only for deployment pos processing value.
    public init(reference: String,
                files: Set<String>,
                runOnlyForDeploymentPostprocessing: UInt,
                buildActionMask: Int = 2147483647) {
        self.reference = reference
        self.files = files
        self.runOnlyForDeploymentPostprocessing = runOnlyForDeploymentPostprocessing
        self.buildActionMask = buildActionMask
    }
    
}

// MARK: - PBXFrameworksBuildPhase Extension (ProjectElement)

extension PBXFrameworksBuildPhase: ProjectElement {
    
    public static var isa: String = "PBXFrameworksBuildPhase"

    public static func == (lhs: PBXFrameworksBuildPhase,
                           rhs: PBXFrameworksBuildPhase) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.files == rhs.files &&
            lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing
    }
    
    public var hashValue: Int { return self.reference.hashValue }
    
    public convenience init(reference: String, dictionary: [String : Any]) throws {
        let unboxer = Unboxer(dictionary: dictionary)
        self.init(reference: reference,
                  files:  try unboxer.unbox(key: "files"),
                  runOnlyForDeploymentPostprocessing: try unboxer.unbox(key: "runOnlyForDeploymentPostprocessing"),
                  buildActionMask: try unboxer.unbox(key: "buildActionMask"))
    }
}

// MARK: - PBXFrameworksBuildPhase Extension (PlistSerializable)

extension PBXFrameworksBuildPhase: PlistSerializable {
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXFrameworksBuildPhase.isa))
        dictionary["buildActionMask"] = .string(CommentedString("\(buildActionMask)"))
        dictionary["files"] = .array(files.map({ (fileReference) -> PlistValue in
            let comment = proj.buildFileName(reference: reference).flatMap({"\($0) in Frameworks"})
            return .string(CommentedString(fileReference, comment: comment))
        }))
        dictionary["runOnlyForDeploymentPostprocessing"] = .string(CommentedString("\(runOnlyForDeploymentPostprocessing)"))
        return (key: CommentedString(self.reference,
                                                 comment: "Frameworks"),
                value: .dictionary(dictionary))
    }
    
}
