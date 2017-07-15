import Foundation
import Unbox

// This is the element for the sources compilation build phase.
public struct PBXSourcesBuildPhase: ProjectElement, PBXProjPlistSerializable {
    
    // MARK: - Attributes
    
    /// Reference.
    public let reference: UUID
    
    /// Element isa.
    public static var isa: String = "PBXSourcesBuildPhase"
    
    /// Build action mask.
    public let buildActionMask: Int = 2147483647
    
    /// Files.
    public let files: Set<UUID>
    
    /// Run only for deployment post processing.
    public let runOnlyForDeploymentPostprocessing: Int = 0
    
    // MARK: - Init
    
    /// Initializes the build phase with the reference and the files.
    ///
    /// - Parameters:
    ///   - reference: build phase reference.
    ///   - files: build phase files.
    public init(reference: UUID,
                files: Set<UUID>) {
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
    
    // MARK: - Public
    
    /// Returns a new build phase removing the given file.
    ///
    /// - Parameter file: file to be removed.
    /// - Returns: build phase with the file removed.
    public func removing(file: UUID) -> PBXSourcesBuildPhase {
        var files = self.files
        files.remove(file)
        return PBXSourcesBuildPhase(reference: self.reference, files: files)
    }
    
    /// Returns a new build phase adding a file.
    ///
    /// - Parameter file: file to be added.
    /// - Returns: new build phase with the file added.
    public func adding(file: UUID) -> PBXSourcesBuildPhase {
        var files = self.files
        files.update(with: file)
        return PBXSourcesBuildPhase(reference: self.reference, files: files)
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXSourcesBuildPhase,
                           rhs: PBXSourcesBuildPhase) -> Bool {
        return lhs.reference == rhs.reference &&
        lhs.buildActionMask == rhs.buildActionMask &&
        lhs.files == rhs.files &&
        lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing
    }
    
    public var hashValue: Int { return self.reference.hashValue }
    
    // MARK: - PBXProjPlistSerializable
    
    func pbxProjPlistElement(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXSourcesBuildPhase.isa))
        dictionary["buildActionMask"] = .string(CommentedString("\(buildActionMask)"))
        dictionary["files"] = .array(files.map { file in
            var comment: String? = nil
            if let fileString = fileName(from: file, proj: proj) {
                comment = "\(fileString) in Sources"
            }
            return PlistValue.string(CommentedString(file, comment: comment))
        })
        
        dictionary["runOnlyForDeploymentPostprocessing"] = .string(CommentedString("\(runOnlyForDeploymentPostprocessing)"))
        return (key: CommentedString(self.reference,
                                                 comment: "Sources"),
                value: .dictionary(dictionary))
    }
    
    private func fileName(from reference: UUID, proj: PBXProj) -> String? {
        return proj.objects.buildFiles
            .filter { $0.reference == reference }
            .flatMap { buildFile in
                return proj.objects.fileReferences.filter { $0.reference == buildFile.fileRef }.first?.path
            }
            .first
    }
    
}
