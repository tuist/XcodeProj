import Foundation
import Unbox

// This is the element for the framewrok link build phase.
public struct PBXHeadersBuildPhase: ProjectElement, Hashable {
    
    /// Element reference.
    public let reference: UUID
    
    /// Element isa.
    public let isa: String = "PBXHeadersBuildPhase"
    
    /// Element build action mask
    public let buildActionMask: UInt
    
    /// Element files.
    public let files: Set<UUID>
    
    /// Element runOnlyForDeploymentPostprocessing
    public let runOnlyForDeploymentPostprocessing: UInt
    
    // MARK: - Init
    
    /// Initializes the headers build phase.
    ///
    /// - Parameters:
    ///   - reference: reference.
    ///   - isa: isa.
    ///   - buildActionMask: build action mask.
    ///   - files: files.
    ///   - runOnlyForDeploymentPostprocessing: run only for deployment post processing.
    public init(reference: UUID,
                buildActionMask: UInt = 2147483647,
                files: Set<UUID> = Set(),
                runOnlyForDeploymentPostprocessing: UInt = 0) {
        self.reference = reference
        self.buildActionMask = buildActionMask
        self.files = files
        self.runOnlyForDeploymentPostprocessing = runOnlyForDeploymentPostprocessing
    }
    
    /// Initializes the headers build phase element with the reference and a dictionary that contains its properties.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: element dictionary that contains the properties.
    /// - Throws: an error if any of the attributes is missing or has the wrong type.
    public init(reference: UUID, dictionary: [String : Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.buildActionMask = try unboxer.unbox(key: "buildActionMask")
        self.files = try unboxer.unbox(key: "files")
        self.runOnlyForDeploymentPostprocessing = try unboxer.unbox(key: "runOnlyForDeploymentPostprocessing")
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXHeadersBuildPhase,
                           rhs: PBXHeadersBuildPhase) -> Bool {
        return lhs.reference == rhs.reference &&
        lhs.isa == rhs.isa &&
        lhs.buildActionMask == rhs.buildActionMask &&
        lhs.files == rhs.files &&
        lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing
    }
    
    public var hashValue: Int { return self.reference.hash }
    
}
