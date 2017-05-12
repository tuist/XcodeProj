import Foundation
import Unbox

// This is the element for the resources copy build phase.
public struct PBXResourcesBuildPhase: ProjectElement, Hashable {
    
    /// Element reference
    public let reference: UUID
    
    /// Element isa.
    public let isa: String = "PBXResourcesBuildPhase"
    
    /// Element build action mask.
    public let buildActionMask: Int = 2147483647
    
    /// Element files.
    public let files: Set<UUID>
    
    /// Element run only for deployment post processing value.
    public let runOnlyForDeploymentPostprocessing: Int
    
    /// Initializes the resources build phase with its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - files: element files.
    ///   - runOnlyForDeploymentPostprocessing: run only for deployment post processing value.
    public init(reference: String,
                files: Set<UUID>,
                runOnlyForDeploymentPostprocessing: Int = 0) {
        self.reference = reference
        self.files = files
        self.runOnlyForDeploymentPostprocessing = runOnlyForDeploymentPostprocessing
    }

    /// Initializes the resources build phase with the element 
    /// reference and the dictionary that contains its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: dictionary with its attributes
    public init(reference: String, dictionary: [String: Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.files = (unboxer.unbox(key: "files")) ?? []
        self.runOnlyForDeploymentPostprocessing = try unboxer.unbox(key: "runOnlyForDeploymentPostprocessing")
    }
    
    // MARK: - Public
    
    /// It returns a new resources build phase with a file added.
    ///
    /// - Parameter file: reference to the file.
    /// - Returns: new resources build phase with the file added.
    public func adding(file: UUID) -> PBXResourcesBuildPhase {
        var files = self.files
        files.update(with: file)
        return PBXResourcesBuildPhase(reference: self.reference,
                                      files: files)
    }
    
    /// It returns a new resources build phase with a file removed.
    ///
    /// - Parameter file: reference to the fil eto be removed.
    /// - Returns: new resources build phase with the file removed.
    public func removing(file: UUID) -> PBXResourcesBuildPhase {
        var files = self.files
        files.remove(file)
        return PBXResourcesBuildPhase(reference: self.reference,
                                      files: files)
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXResourcesBuildPhase,
                           rhs: PBXResourcesBuildPhase) -> Bool {
        return lhs.reference == rhs.reference &&
        lhs.isa == rhs.isa &&
        lhs.buildActionMask == rhs.buildActionMask &&
        lhs.files == rhs.files &&
        lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing
    }
    
    public var hashValue: Int { return self.reference.hashValue }

}
