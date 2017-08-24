import Foundation
import Unbox
import PathKit

// This is the element for the framewrok link build phase.
public final class PBXHeadersBuildPhase {
    
    /// Element reference.
    public var reference: String
    
    /// Element build action mask
    public var buildActionMask: UInt
    
    /// Element files.
    public var files: Set<String>
    
    /// Element runOnlyForDeploymentPostprocessing
    public var runOnlyForDeploymentPostprocessing: UInt
    
    // MARK: - Init
    
    public init(reference: String,
                buildActionMask: UInt = 2147483647,
                files: Set<String> = Set(),
                runOnlyForDeploymentPostprocessing: UInt = 0) {
        self.reference = reference
        self.buildActionMask = buildActionMask
        self.files = files
        self.runOnlyForDeploymentPostprocessing = runOnlyForDeploymentPostprocessing
    }
    
}

// MARK: - PBXHeadersBuildPhase Extension (Extras)

extension PBXHeadersBuildPhase {
    
    /// Returns if the path refers to a header file.
    ///
    /// - Parameter path: path to be checked.
    /// - Returns: true if the path points to a header file.
    static func isHeader(path: Path) -> Bool {
        return path.extension.flatMap({isHeader(fileExtension: $0)}) ?? false
    }
    
    /// Returns if the given extension is a header.
    ///
    /// - Parameter fileExtension: file extension to be checked.
    /// - Returns: true if the file represents a header.
    static func isHeader(fileExtension: String) -> Bool {
        let headersExtensions = ["h", "hh", "hpp", "ipp", "tpp", "hxx", "def"]
        return headersExtensions.contains(fileExtension)
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
    
    /// Initializes the headers build phase element with the reference and a dictionary that contains its properties.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: element dictionary that contains the properties.
    /// - Throws: an error if any of the attributes is missing or has the wrong type.
    public convenience init(reference: String, dictionary: [String : Any]) throws {
        let unboxer = Unboxer(dictionary: dictionary)
        self.init(reference: reference,
                  buildActionMask: try unboxer.unbox(key: "buildActionMask"),
                  files: try unboxer.unbox(key: "files"),
                  runOnlyForDeploymentPostprocessing: try unboxer.unbox(key: "runOnlyForDeploymentPostprocessing"))
    }
    
}

// MARK: - PBXHeadersBuildPhase Extension (PlistSerializable)

extension PBXHeadersBuildPhase: PlistSerializable {
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXHeadersBuildPhase.isa))
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
