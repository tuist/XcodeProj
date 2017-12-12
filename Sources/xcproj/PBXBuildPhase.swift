import Foundation

/// An absctract class for all the build phase objects
public class PBXBuildPhase: PBXObject, Equatable {
    
    /// Default build action mask.
    public static let defaultBuildActionMask: UInt = 2147483647

    /// Default runOnlyForDeploymentPostprocessing value.
    public static let defaultRunOnlyForDeploymentPostprocessing: UInt = 0

    /// Element build action mask.
    public var buildActionMask: UInt

    /// Element files.
    public var files: [String]

    /// Element run only for deployment post processing value.
    public var runOnlyForDeploymentPostprocessing: UInt

    /// The build phase type of the build phase
    public var buildPhase: BuildPhase {
        fatalError("This property must be override")
    }

    public init(files: [String] = [],
                buildActionMask: UInt = defaultBuildActionMask,
                runOnlyForDeploymentPostprocessing: UInt = 0) {
        self.files = files
        self.buildActionMask = buildActionMask
        self.runOnlyForDeploymentPostprocessing = runOnlyForDeploymentPostprocessing
        super.init()
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case buildActionMask
        case files
        case runOnlyForDeploymentPostprocessing
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let buildActionMaskString: String? = try container.decodeIfPresent(.buildActionMask)
        self.buildActionMask = buildActionMaskString.flatMap(UInt.init) ?? PBXBuildPhase.defaultBuildActionMask
        self.files = try container.decodeIfPresent(.files) ?? []
        let runOnlyForDeploymentPostprocessingString: String? = try container.decodeIfPresent(.runOnlyForDeploymentPostprocessing)
        self.runOnlyForDeploymentPostprocessing = runOnlyForDeploymentPostprocessingString.flatMap(UInt.init) ?? 0
        try super.init(from: decoder)
    }

    public static func == (lhs: PBXBuildPhase,
                           rhs: PBXBuildPhase) -> Bool {
        return lhs.files == rhs.files &&
            lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing
    }

    func plistValues(proj: PBXProj, reference: String) -> [CommentedString: PlistValue] {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["buildActionMask"] = .string(CommentedString("\(buildActionMask)"))
        dictionary["files"] = .array(files.map { fileReference in
            let name = proj.objects.fileName(buildFileReference: fileReference)
            let type = proj.objects.buildPhaseName(buildFileReference: fileReference)
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
        dictionary["runOnlyForDeploymentPostprocessing"] = .string(CommentedString("\(runOnlyForDeploymentPostprocessing)"))
        return dictionary
    }
}
