import Foundation
import Unbox

// This is the element for the resources copy build phase.
public struct PBXResourcesBuildPhase {
    
    /// Element reference
    public var reference: String
    
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
        self.reference = reference
        self.files = files
        self.runOnlyForDeploymentPostprocessing = runOnlyForDeploymentPostprocessing
        self.buildActionMask = buildActionMask
    }
    
}

// MARK: - PBXResourcesBuildPhase Extension (ProjectElement)

extension PBXResourcesBuildPhase: ProjectElement {
    
    public static var isa: String = "PBXResourcesBuildPhase"

    public init(reference: String, dictionary: [String: Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.files = (unboxer.unbox(key: "files")) ?? []
        self.runOnlyForDeploymentPostprocessing = try unboxer.unbox(key: "runOnlyForDeploymentPostprocessing")
        self.buildActionMask = try unboxer.unbox(key: "buildActionMask")
    }
    
    public static func == (lhs: PBXResourcesBuildPhase,
                           rhs: PBXResourcesBuildPhase) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.buildActionMask == rhs.buildActionMask &&
            lhs.files == rhs.files &&
            lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing
    }
    
    public var hashValue: Int { return self.reference.hashValue }
    
}

// MARK: - PBXResourcesBuildPhase Extension (Extras)

extension PBXResourcesBuildPhase {
    
    /// It returns a new resources build phase with a file added.
    ///
    /// - Parameter file: reference to the file.
    /// - Returns: new resources build phase with the file added.
    public func adding(file: String) -> PBXResourcesBuildPhase {
        var files = self.files
        files.update(with: file)
        return PBXResourcesBuildPhase(reference: self.reference,
                                      files: files)
    }
    
    /// It returns a new resources build phase with a file removed.
    ///
    /// - Parameter file: reference to the fil eto be removed.
    /// - Returns: new resources build phase with the file removed.
    public func removing(file: String) -> PBXResourcesBuildPhase {
        var files = self.files
        files.remove(file)
        return PBXResourcesBuildPhase(reference: self.reference,
                                      files: files)
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
