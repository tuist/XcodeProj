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
    }

    public enum DstSubfolder: Equatable, Decodable {
        case absolutePath
        case productsDirectory
        case wrapper
        case executables
        case resources
        case javaResources
        case frameworks
        case sharedFrameworks
        case sharedSupport
        case plugins
        case other
        case product
        case none
        case unknown(String)

        public init(rawValue: String) {
            switch rawValue {
            case "AbsolutePath": self = .absolutePath
            case "ProductsDirectory": self = .productsDirectory
            case "Wrapper": self = .wrapper
            case "Executables": self = .executables
            case "Resources": self = .resources
            case "JavaResources": self = .javaResources
            case "Frameworks": self = .frameworks
            case "SharedFrameworks": self = .sharedFrameworks
            case "SharedSupport": self = .sharedSupport
            case "PlugIns": self = .plugins
            case "Other": self = .other
            case "Product": self = .product
            case "None": self = .none
            default: self = .unknown(rawValue)
            }
        }

        public var rawValue: String {
            switch self {
            case .absolutePath: "AbsolutePath"
            case .productsDirectory: "ProductsDirectory"
            case .wrapper: "Wrapper"
            case .executables: "Executables"
            case .resources: "Resources"
            case .javaResources: "JavaResources"
            case .frameworks: "Frameworks"
            case .sharedFrameworks: "SharedFrameworks"
            case .sharedSupport: "SharedSupport"
            case .plugins: "PlugIns"
            case .other: "Other"
            case .product: "Product"
            case .none: "None"
            case let .unknown(rawValue): rawValue
            }
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            self = .init(rawValue: rawValue)
        }
    }

    // MARK: - Attributes

    /// Element destination path
    public var dstPath: String?

    /// Element destination subfolder spec
    public var dstSubfolderSpec: SubFolder?

    public var dstSubfolder: DstSubfolder?

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
    ///   - dstSubfolder: Destination subfolder.
    ///   - buildActionMask: Build action mask.
    ///   - files: Build files to copy.
    ///   - runOnlyForDeploymentPostprocessing: Run only for deployment post processing.
    public init(dstPath: String? = nil,
                dstSubfolderSpec: SubFolder? = nil,
                dstSubfolder: DstSubfolder? = nil,
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
        dstSubfolderSpec = try container.decodeIntIfPresent(.dstSubfolderSpec).flatMap(SubFolder.init)
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
