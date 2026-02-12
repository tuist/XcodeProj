import Foundation

/// This is the element for the copy file build phase.
public final class PBXCopyFilesBuildPhase: PBXBuildPhase {
    public enum SubFolder: UInt, Decodable {
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

        /// Human-readable string representation used in Xcode 16+
        public var stringValue: String {
            switch self {
            case .absolutePath: return "AbsolutePath"
            case .productsDirectory: return "ProductsDirectory"
            case .wrapper: return "Wrapper"
            case .executables: return "Executables"
            case .resources: return "Resources"
            case .javaResources: return "JavaResources"
            case .frameworks: return "Frameworks"
            case .sharedFrameworks: return "SharedFrameworks"
            case .sharedSupport: return "SharedSupport"
            case .plugins: return "Plugins"
            case .other: return "Other"
            }
        }

        /// Initialize from string value (Xcode 16+ format)
        public init?(string: String) {
            switch string {
            case "AbsolutePath": self = .absolutePath
            case "ProductsDirectory": self = .productsDirectory
            case "Wrapper": self = .wrapper
            case "Executables": self = .executables
            case "Resources": self = .resources
            case "JavaResources": self = .javaResources
            case "Frameworks": self = .frameworks
            case "SharedFrameworks": self = .sharedFrameworks
            case "SharedSupport": self = .sharedSupport
            case "Plugins": self = .plugins
            default: return nil
            }
        }
    }

    // MARK: - Attributes

    /// Element destination path
    public var dstPath: String?

    /// Element destination subfolder (Xcode 16+ format, human-readable string)
    public var dstSubfolder: SubFolder?

    /// Element destination subfolder spec
    @available(*, deprecated, renamed: "dstSubfolder")
    public var dstSubfolderSpec: SubFolder? {
        get { dstSubfolder }
        set { dstSubfolder = newValue }
    }

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
    ///   - dstSubfolder: Destination subfolder.
    ///   - buildActionMask: Build action mask.
    ///   - files: Build files to copy.
    ///   - runOnlyForDeploymentPostprocessing: Run only for deployment post processing.
    public init(dstPath: String? = nil,
                dstSubfolder: SubFolder? = nil,
                name: String? = nil,
                buildActionMask: UInt = defaultBuildActionMask,
                files: [PBXBuildFile] = [],
                runOnlyForDeploymentPostprocessing: Bool = false) {
        self.dstPath = dstPath
        self.dstSubfolder = dstSubfolder
        self.name = name
        super.init(files: files,
                   buildActionMask: buildActionMask,
                   runOnlyForDeploymentPostprocessing:
                   runOnlyForDeploymentPostprocessing)
    }

    /// Initializes the copy files build phase with its attributes (deprecated parameter name).
    @available(*, deprecated, renamed: "init(dstPath:dstSubfolder:name:buildActionMask:files:runOnlyForDeploymentPostprocessing:)")
    public convenience init(dstPath: String? = nil,
                            dstSubfolderSpec: SubFolder?,
                            name: String? = nil,
                            buildActionMask: UInt = defaultBuildActionMask,
                            files: [PBXBuildFile] = [],
                            runOnlyForDeploymentPostprocessing: Bool = false) {
        self.init(dstPath: dstPath,
                  dstSubfolder: dstSubfolderSpec,
                  name: name,
                  buildActionMask: buildActionMask,
                  files: files,
                  runOnlyForDeploymentPostprocessing: runOnlyForDeploymentPostprocessing)
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case dstPath
        case dstSubfolder
        case dstSubfolderSpec
        case name
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dstPath = try container.decodeIfPresent(.dstPath)
        // Try to decode dstSubfolder (Xcode 16+ string format) first, fallback to dstSubfolderSpec (legacy integer format)
        if let dstSubfolderString: String = try container.decodeIfPresent(.dstSubfolder) {
            dstSubfolder = SubFolder(string: dstSubfolderString)
        } else {
            dstSubfolder = try container.decodeIntIfPresent(.dstSubfolderSpec).flatMap(SubFolder.init)
        }
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
        if let dstSubfolder {
            // Write using the new Xcode 16+ format (dstSubfolder with string value)
            dictionary["dstSubfolder"] = .string(CommentedString(dstSubfolder.stringValue))
        }
        return (key: CommentedString(reference, comment: name ?? "CopyFiles"), value: .dictionary(dictionary))
    }
}
