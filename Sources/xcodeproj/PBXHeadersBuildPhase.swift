import Foundation
import Unbox

// This is the element for the framewrok link build phase.
public struct PBXHeadersBuildPhase {
    
    /// Element reference.
    public let reference: UUID
    
    /// Element build action mask
    public let buildActionMask: UInt
    
    /// Element files.
    public let files: Set<UUID>
    
    /// Element runOnlyForDeploymentPostprocessing
    public let runOnlyForDeploymentPostprocessing: UInt
    
    // MARK: - Init
    
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
    
}

// MARK: - PBXHeadersBuildPhase Extension (Extras)

extension PBXHeadersBuildPhase {
    
    /// Returns a new headers build phase with a file added.
    ///
    /// - Parameter file: file to be added.
    /// - Returns: new headers build phase with the file added.
    public func adding(file: UUID) -> PBXHeadersBuildPhase {
        var files = self.files
        files.insert(file)
        return PBXHeadersBuildPhase(reference: reference,
                                    buildActionMask: buildActionMask,
                                    files: files,
                                    runOnlyForDeploymentPostprocessing: runOnlyForDeploymentPostprocessing)
    }
    
    /// Returns a new headers build phase with the file removed.
    ///
    /// - Parameter file: file to be removed.
    /// - Returns: new headers build phase with the file removed.
    public func removing(file: UUID) -> PBXHeadersBuildPhase {
        var files = self.files
        files.remove(file)
        return PBXHeadersBuildPhase(reference: reference,
                                    buildActionMask: buildActionMask,
                                    files: files,
                                    runOnlyForDeploymentPostprocessing: runOnlyForDeploymentPostprocessing)
    }
    
}

// MARK: - PBXHeadersBuildPhase Extension (ProjectElement)

extension PBXHeadersBuildPhase: ProjectElement {
    
    public static var isa: String = "PBXHeadersBuildPhase"

    public static func == (lhs: PBXHeadersBuildPhase,
                           rhs: PBXHeadersBuildPhase) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.buildActionMask == rhs.buildActionMask &&
            lhs.files == rhs.files &&
            lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing
    }
    
    public var hashValue: Int { return self.reference.hashValue }
    
    public init(reference: UUID,
                buildActionMask: UInt = 2147483647,
                files: Set<UUID> = Set(),
                runOnlyForDeploymentPostprocessing: UInt = 0) {
        self.reference = reference
        self.buildActionMask = buildActionMask
        self.files = files
        self.runOnlyForDeploymentPostprocessing = runOnlyForDeploymentPostprocessing
    }
}

// MARK: - PBXHeadersBuildPhase Extension (PBXProjPlistSerializable)

extension PBXHeadersBuildPhase: PBXProjPlistSerializable {
    
    func pbxProjPlistElement(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXFrameworksBuildPhase.isa))
        dictionary["buildActionMask"] = .string(CommentedString("\(buildActionMask)"))
        dictionary["files"] = .array(files.map({ (fileReference) -> PlistValue in
            let comment = proj.buildFileName(reference: reference).flatMap({"\($0) in Headers"})
            return .string(CommentedString(fileReference, comment: comment))
        }))
        dictionary["runOnlyForDeploymentPostprocessing"] = .string(CommentedString("\(runOnlyForDeploymentPostprocessing)"))
        return (key: CommentedString(self.reference,
                                                 comment: "Frameworks"),
                value: .dictionary(dictionary))
    }
    
}
