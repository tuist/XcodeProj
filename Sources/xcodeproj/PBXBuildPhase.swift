import Foundation

/// An absctract class for all the build phase objects
public class PBXBuildPhase: PBXContainerItem {
    /// Default build action mask.
    public static let defaultBuildActionMask: UInt = 2_147_483_647

    /// Element build action mask.
    public var buildActionMask: UInt

    /// Element files.
    public var files: [PBXObjectReference]

    /// Element run only for deployment post processing value.
    public var runOnlyForDeploymentPostprocessing: Bool

    /// The build phase type of the build phase
    public var buildPhase: BuildPhase {
        fatalError("This property must be override")
    }

    public init(files: [PBXObjectReference] = [],
                buildActionMask: UInt = defaultBuildActionMask,
                runOnlyForDeploymentPostprocessing: Bool = false) {
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
        buildActionMask = try container.decodeIntIfPresent(.buildActionMask) ?? PBXBuildPhase.defaultBuildActionMask
        files = try container.decodeIfPresent(.files) ?? []
        runOnlyForDeploymentPostprocessing = try container.decodeIntBool(.runOnlyForDeploymentPostprocessing)
        try super.init(from: decoder)
    }

    override func plistValues(proj: PBXProj, reference: String) -> [CommentedString: PlistValue] {
        var dictionary = super.plistValues(proj: proj, reference: reference)
        dictionary["buildActionMask"] = .string(CommentedString("\(buildActionMask)"))
        dictionary["files"] = .array(files.map { fileReference in
            let name = proj.objects.fileName(buildFileReference: fileReference)
            let type = proj.objects.buildPhaseName(buildFileReference: fileReference)
            let fileName = name ?? "(null)"
            let comment = (type.flatMap { "\(fileName) in \($0)" }) ?? name
            return .string(CommentedString(fileReference, comment: comment))
        })
        dictionary["runOnlyForDeploymentPostprocessing"] = .string(CommentedString("\(runOnlyForDeploymentPostprocessing.int)"))
        return dictionary
    }

    /// Returns the build phase type.
    ///
    /// - Returns: build phase type.
    public func type() -> BuildPhase? {
        if self is PBXSourcesBuildPhase {
            return .sources
        } else if self is PBXFrameworksBuildPhase {
            return .frameworks
        } else if self is PBXResourcesBuildPhase {
            return .resources
        } else if self is PBXCopyFilesBuildPhase {
            return .copyFiles
        } else if self is PBXShellScriptBuildPhase {
            return .runScript
        } else if self is PBXHeadersBuildPhase {
            return .headers
        } else if self is PBXRezBuildPhase {
            return .carbonResources
        } else {
            return nil
        }
    }

    /// Build phase name.
    ///
    /// - Returns: build phase name.
    func name() -> String? {
        if self is PBXSourcesBuildPhase {
            return "Sources"
        } else if self is PBXFrameworksBuildPhase {
            return "Frameworks"
        } else if self is PBXResourcesBuildPhase {
            return "Resources"
        } else if let phase = self as? PBXCopyFilesBuildPhase {
            return phase.name ?? "CopyFiles"
        } else if let phase = self as? PBXShellScriptBuildPhase {
            return phase.name ?? "ShellScript"
        } else if self is PBXHeadersBuildPhase {
            return "Headers"
        } else if self is PBXRezBuildPhase {
            return "Rez"
        }
        return nil
    }
}
