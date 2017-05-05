import Foundation
import Unbox

// This is the element for the sources compilation build phase.
public struct PBXSourcesBuildPhase: Hashable {
    
    // MARK: - Attributes
    
    /// Reference.
    public let reference: UUID
    
    /// Element isa.
    public let isa: String = "PBXSourcesBuildPhase"
    
    /// Build action mask.
    public let buildActionMask: Int = 2147483647
    
    /// Files.
    public let files: [UUID]
    
    /// Run only for deployment post processing.
    public let runOnlyForDeploymentPostprocessing: Int = 0
    
    // MARK: - Init
    
    /// Initializes the build phase with the reference and the files.
    ///
    /// - Parameters:
    ///   - reference: build phase reference.
    ///   - files: build phase files.
    public init(reference: UUID,
                files: [UUID]) {
        self.reference = reference
        self.files = files
    }
    
    /// Initializes the build phase with the element reference and a dictionary with its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: dictionary with the build phase attributes.
    /// - Throws: throws an error in case any of the attributes is missing or it has the wrong type.
    public init(reference: UUID, dictionary: [String: Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.files = try unboxer.unbox(key: "files")
    }
    
    // MARK - Public
    
    /// Returns a new build phase removing the given file.
    ///
    /// - Parameter file: file to be removed.
    /// - Returns: build phase with the file removed.
    public func removing(file: UUID) -> PBXSourcesBuildPhase {
        var files = self.files
        if let index = files.index(of: file) {
            files.remove(at: index)
        }
        return PBXSourcesBuildPhase(reference: self.reference, files: files)
    }
    
    /// Returns a new build phase adding a file.
    ///
    /// - Parameter file: file to be added.
    /// - Returns: new build phase with the file added.
    public func adding(file: UUID) -> PBXSourcesBuildPhase {
        var files = self.files
        files.append(file)
        return PBXSourcesBuildPhase(reference: self.reference, files: files)
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXSourcesBuildPhase,
                           rhs: PBXSourcesBuildPhase) -> Bool {
        return lhs.reference == rhs.reference &&
        lhs.isa == lhs.isa &&
        lhs.buildActionMask == rhs.buildActionMask &&
        lhs.files == rhs.files &&
        lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing
    }
    
    public var hashValue: Int { return self.reference.hashValue }
    
}
