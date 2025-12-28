import Foundation

/// This is the element for the copy file build phase.
public final class PBXCopyFilesBuildPhase: PBXBuildPhase {
    
    @available(*, deprecated, renamed: "SubFolder", message: "May become obsolete in the future in favor of dstSubfolder")
    public enum SubFolderSpec: UInt, Decodable {
        case absolutePath = 0
        case productsDirectory = 16
        case wrapper = 1
        case executables = 6
        case resources = 7
        case javaResources = 15
        case frameworks = 10
        case sharedFrameworks = 11
        case sharedSupport = 12
        case plugins = 13
        case other
    }
  
    public enum SubFolder: String, Decodable {
        case absolutePath = "AbsolutePath"
        case productsDirectory = "ProductsDirectory"
        case wrapper = "Wrapper"
        case executables = "Executables"
        case resources = "Resources"
        case javaResources = "JavaResources"
        case frameworks = "Frameworks"
        case sharedFrameworks = "SharedFrameworks"
        case sharedSupport = "SharedSupport"
        case plugins = "PlugIns"
        case other = "Other"
        case product = "Product"
        case none = "None"
    }

    // MARK: - Attributes

    /// Element destination path
    public var dstPath: String?

    /// Element destination subfolder spec
    public var dstSubfolderSpec: SubFolderSpec?
  
    public var dstSubfolder: SubFolder?

    /// Copy files build phase name
    public var name: String?

    override public var buildPhase: BuildPhase {
        .copyFiles
    }

    // MARK: - Init

    /// Initializes the copy files build phase with its attributes.
    ///
    /// - Parameters:
    ///   - dstPath: Destination path.
    ///   - dstSubfolderSpec: Destination subfolder spec.
    ///   - buildActionMask: Build action mask.
    ///   - files: Build files to copy.
    ///   - runOnlyForDeploymentPostprocessing: Run only for deployment post processing.
    public init(dstPath: String? = nil,
                dstSubfolderSpec: SubFolderSpec? = nil,
                dstSubfolder: SubFolder? = nil,
                name: String? = nil,
                buildActionMask: UInt = defaultBuildActionMask,
                files: [PBXBuildFile] = [],
                runOnlyForDeploymentPostprocessing: Bool = false) {
        self.dstPath = dstPath
        self.dstSubfolderSpec = dstSubfolderSpec
        self.dstSubfolder = dstSubfolder
        self.name = name
        super.init(files: files,
                   buildActionMask: buildActionMask,
                   runOnlyForDeploymentPostprocessing:
                   runOnlyForDeploymentPostprocessing)
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case dstPath
        case dstSubfolderSpec
        case dstSubfolder
        case name
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dstPath = try container.decodeIfPresent(.dstPath)
        dstSubfolderSpec = try container.decodeIntIfPresent(.dstSubfolderSpec).flatMap(SubFolderSpec.init)
        dstSubfolder = try container.decodeIfPresent(.dstSubfolder)
        name = try container.decodeIfPresent(.name)
        try super.init(from: decoder)
    }

    override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXCopyFilesBuildPhase else { return false }
        return isEqual(to: rhs)
    }
}

// MARK: - PBXCopyFilesBuildPhase Extension (PlistSerializable)

extension PBXCopyFilesBuildPhase: PlistSerializable {
    func plistKeyAndValue(proj: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = try plistValues(proj: proj, reference: reference)
        dictionary["isa"] = .string(CommentedString(PBXCopyFilesBuildPhase.isa))
        if let dstPath {
            dictionary["dstPath"] = .string(CommentedString(dstPath))
        }
        if let name {
            dictionary["name"] = .string(CommentedString(name))
        }
        if let dstSubfolderSpec {
            dictionary["dstSubfolderSpec"] = .string(CommentedString("\(dstSubfolderSpec.rawValue)"))
        }
        if let dstSubfolder {
            dictionary["dstSubfolder"] = .string(CommentedString("\(dstSubfolder.rawValue)"))
        }
        return (key: CommentedString(reference, comment: name ?? "CopyFiles"), value: .dictionary(dictionary))
    }
}
