import Foundation

/// An absctract class for all the build phase objects
public class PBXBuildPhase: PBXContainerItem {
    /// Default build action mask.
    public static let defaultBuildActionMask: UInt = 2_147_483_647

    /// Element build action mask.
    public var buildActionMask: UInt

    /// Element files references.
    public var filesReferences: [PBXObjectReference]

    /// Element run only for deployment post processing value.
    public var runOnlyForDeploymentPostprocessing: Bool

    /// The build phase type of the build phase
    public var buildPhase: BuildPhase {
        fatalError("This property must be overriden")
    }

    public init(filesReferences: [PBXObjectReference] = [],
                buildActionMask: UInt = defaultBuildActionMask,
                runOnlyForDeploymentPostprocessing: Bool = false) {
        self.filesReferences = filesReferences
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
        let objects = decoder.context.objects
        let objectReferenceRepository = decoder.context.objectReferenceRepository
        let container = try decoder.container(keyedBy: CodingKeys.self)
        buildActionMask = try container.decodeIntIfPresent(.buildActionMask) ?? PBXBuildPhase.defaultBuildActionMask
        let filesReferences: [String] = try container.decodeIfPresent(.files) ?? []
        self.filesReferences = filesReferences.map({ objectReferenceRepository.getOrCreate(reference: $0, objects: objects) })
        runOnlyForDeploymentPostprocessing = try container.decodeIntBool(.runOnlyForDeploymentPostprocessing)
        try super.init(from: decoder)
    }

    override func plistValues(proj: PBXProj, reference: String) throws -> [CommentedString: PlistValue] {
        var dictionary = try super.plistValues(proj: proj, reference: reference)
        dictionary["buildActionMask"] = .string(CommentedString("\(buildActionMask)"))
        dictionary["files"] = try .array(filesReferences.map { fileReference in
            let buildFile: PBXBuildFile = try fileReference.object()
            let name = try buildFile.fileName()
            let type = self.name()
            let fileName = name ?? "(null)"
            let comment = (type.flatMap { "\(fileName) in \($0)" }) ?? name
            return .string(CommentedString(fileReference.value, comment: comment))
        })
        dictionary["runOnlyForDeploymentPostprocessing"] = .string(CommentedString("\(runOnlyForDeploymentPostprocessing.int)"))
        return dictionary
    }

    // MARK: - References

    /// Referenced children objects. Those children are used by -fixReference to
    /// fix the reference of those objects as well.
    ///
    /// - Returns: object children references.
    override func referencedObjects() throws -> [PBXObjectReference] {
        var references = try super.referencedObjects()
        references.append(contentsOf: filesReferences)
        return references
    }
}

// MARK: - Public

public extension PBXBuildPhase {
    /// Adds a file to a build phase, creating a proxy build file that points to the given file reference.
    ///
    /// - Parameter reference: reference to the file element.
    /// - Returns: reference to the build file added to the build phase.
    /// - Throws: an error if the reference cannot be added
    public func addFile(_ reference: PBXObjectReference) throws -> PBXObjectReference {
        if let existing = try filesReferences.compactMap({ try $0.object() as PBXBuildFile }).first(where: { $0.fileReference == reference }) {
            return existing.reference
        }
        let projectObjects = try objects()
        let buildFile = PBXBuildFile(fileReference: reference)
        let buildFileReference = projectObjects.addObject(buildFile)
        filesReferences.append(buildFileReference)
        return buildFileReference
    }
}

// MARK: - Utils

extension PBXBuildPhase {
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
