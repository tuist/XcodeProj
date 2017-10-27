import Foundation

/// An absctract class for all the build phase objects
public class PBXBuildPhase: PBXObject {
    
    /// Default build action mask.
    public static let defaultBuildActionMask: UInt = 2147483647

    /// Element build action mask.
    public var buildActionMask: UInt?

    /// Element files.
    public var files: [String]

    /// Element run only for deployment post processing value.
    public var runOnlyForDeploymentPostprocessing: UInt?

    public init(reference: String,
                files: [String] = [],
                buildActionMask: UInt? = defaultBuildActionMask,
                runOnlyForDeploymentPostprocessing: UInt? = nil) {
        self.files = files
        self.buildActionMask = buildActionMask
        self.runOnlyForDeploymentPostprocessing = runOnlyForDeploymentPostprocessing
        super.init(reference: reference)
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case buildActionMask
        case files
        case runOnlyForDeploymentPostprocessing
        case reference
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let buildActionMaskString: String? = try container.decodeIfPresent(.buildActionMask)
        self.buildActionMask = buildActionMaskString.flatMap(UInt.init) ?? PBXBuildPhase.defaultBuildActionMask
        self.files = try container.decodeIfPresent(.files) ?? []
        let runOnlyForDeploymentPostprocessingString: String? = try container.decodeIfPresent(.runOnlyForDeploymentPostprocessing)
        self.runOnlyForDeploymentPostprocessing = runOnlyForDeploymentPostprocessingString.flatMap(UInt.init)
        try super.init(from: decoder)
    }

    public static func == (lhs: PBXBuildPhase,
                           rhs: PBXBuildPhase) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.files == rhs.files &&
            lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing
    }

    func plistValues(proj: PBXProj) -> [CommentedString: PlistValue] {
        var dictionary: [CommentedString: PlistValue] = [:]
        if let buildActionMask = buildActionMask  {
            dictionary["buildActionMask"] = .string(CommentedString("\(buildActionMask)"))
        }
        dictionary["files"] = .array(files.map { fileReference in
            let name = proj.fileName(buildFileReference: fileReference)
            let type = proj.buildPhaseType(buildFileReference: fileReference)?.rawValue
            let comment = name
                .flatMap({ fileName -> String? in
                    if let type = type {
                        return "\(fileName) in \(type)"
                    } else {
                        return fileName
                    }
                })
            return .string(CommentedString(fileReference, comment: comment))
        })
        if let runOnlyForDeploymentPostprocessing = runOnlyForDeploymentPostprocessing {
            dictionary["runOnlyForDeploymentPostprocessing"] = .string(CommentedString("\(runOnlyForDeploymentPostprocessing)"))
        }
        return dictionary
    }
}
