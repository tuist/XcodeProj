import Foundation
import Unbox

// This is the element for the sources compilation build phase.
public struct PBXSourcesBuildPhase: ProjectElement, PlistSerializable {
    
    // MARK: - Attributes
    
    /// Reference.
    public var reference: String
    
    /// Element isa.
    public static var isa: String = "PBXSourcesBuildPhase"
    
    /// Build action mask.
    public var buildActionMask: Int = 2147483647
    
    /// Files.
    public var files: Set<String>
    
    /// Run only for deployment post processing.
    public var runOnlyForDeploymentPostprocessing: Int = 0
    
    // MARK: - Init
    
    /// Initializes the build phase with the reference and the files.
    ///
    /// - Parameters:
    ///   - reference: build phase reference. Will be automatically generated if not specified
    ///   - files: build phase files.
    public init(reference: String? = nil,
                files: Set<String>) {
        self.reference = reference ?? ReferenceGenerator.shared.generateReference(PBXSourcesBuildPhase.self, files.joined())
        self.files = files
    }
    
    /// Initializes the build phase with the element reference and a dictionary with its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: dictionary with the build phase attributes.
    /// - Throws: throws an error in case any of the attributes is missing or it has the wrong type.
    public init(reference: String, dictionary: [String: Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.files = try unboxer.unbox(key: "files")
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
    
    // MARK: - PlistSerializable
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
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
    
    private func fileName(from reference: String, proj: PBXProj) -> String? {
        return proj.objects.buildFiles
            .filter { $0.reference == reference }
            .flatMap { buildFile in
                return proj.objects.fileReferences.filter { $0.reference == buildFile.fileRef }.first?.path
            }
            .first
    }
    
}
