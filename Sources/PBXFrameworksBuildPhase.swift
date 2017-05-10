import Foundation
import Unbox

// This is the element for the framewrok link build phase.
public struct PBXFrameworksBuildPhase: ProjectElement {

    // MARK: - Properties
    
    /// Element isa.
    public let isa: String = "PBXFrameworksBuildPhase"
    
    /// Element reference.
    public let reference: UUID
    
    /// Framework build phase files.
    public let files: Set<UUID>
    
    /// Build phase run only for deployment post processing.
    public let runOnlyForDeploymentPostprocessing: UInt

    // MARK: - Init
    
    /// Initializes the frameworks build phase with its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - files: frameworks build phase files.
    ///   - runOnlyForDeploymentPostprocessing: run only for deployment pos processing value.
    public init(reference: UUID,
                files: Set<UUID>,
                runOnlyForDeploymentPostprocessing: UInt) {
        self.reference = reference
        self.files = files
        self.runOnlyForDeploymentPostprocessing = runOnlyForDeploymentPostprocessing
    }
    
    /// Initializes the frameworks build phase with the reference and a dictionary with its properties.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: dictionary with the attributes.
    /// - Throws: an error in case any of the attributes is missing or it has the wrong type.
    public init(reference: UUID, dictionary: [String : Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.files = try unboxer.unbox(key: "files")
        self.runOnlyForDeploymentPostprocessing = try unboxer.unbox(key: "runOnlyForDeploymentPostprocessing")
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXFrameworksBuildPhase,
                           rhs: PBXFrameworksBuildPhase) -> Bool {
        return lhs.isa == rhs.isa &&
        lhs.reference == rhs.reference &&
        lhs.files == rhs.files &&
        lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing
    }
    
    public var hashValue: Int { return self.reference.hashValue }
    
}
