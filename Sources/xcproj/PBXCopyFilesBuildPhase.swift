import Foundation

// This is the element for the copy file build phase.
public class PBXCopyFilesBuildPhase: PBXBuildPhase, Hashable {

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

    // MARK: - Attributes

    /// Element destination path
    public var dstPath: String

    /// Element destination subfolder spec
    public var dstSubfolderSpec: SubFolder
    
    /// Copy files build phase name
    public var name: String?

    // MARK: - Init

    /// Initializes the copy files build phase with its attributes.
    ///
    /// - Parameters:
    ///   - reference: reference.
    ///   - dstPath: destination path.
    ///   - dstSubfolderSpec: destination subfolder spec.
    ///   - buildActionMask: build action mask.
    ///   - files: files to copy.
    ///   - runOnlyForDeploymentPostprocessing: run only for deployment post processing.
    public init(reference: String,
                dstPath: String,
                dstSubfolderSpec: SubFolder,
                name: String? = nil,
                buildActionMask: UInt = 2147483647,
                files: [String] = [],
                runOnlyForDeploymentPostprocessing: UInt = 0) {
        self.dstPath = dstPath
        self.dstSubfolderSpec = dstSubfolderSpec
        self.name = name
        super.init(reference: reference,
                   files: files,
                   buildActionMask: buildActionMask,
                   runOnlyForDeploymentPostprocessing:
            runOnlyForDeploymentPostprocessing)
    }

    public static func == (lhs: PBXCopyFilesBuildPhase,
                           rhs: PBXCopyFilesBuildPhase) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.dstPath == rhs.dstPath &&
            lhs.name == rhs.name &&
            lhs.buildActionMask == rhs.buildActionMask &&
            lhs.dstSubfolderSpec == rhs.dstSubfolderSpec &&
            lhs.files == rhs.files &&
            lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing
    }
    
    // MARK: - Decodable
    
    fileprivate enum CodingKeys: String, CodingKey {
        case dstPath
        case dstSubfolderSpec
        case name
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dstPath = try container.decode(.dstPath)
        let dstSubfolderSpecString: String = try container.decode(.dstSubfolderSpec)
        self.dstSubfolderSpec = UInt(dstSubfolderSpecString).flatMap(SubFolder.init) ?? .other
        self.name = try container.decodeIfPresent(.name)
        try super.init(from: decoder)
    }

}

// MARK: - PBXCopyFilesBuildPhase Extension (PlistSerializable)

extension PBXCopyFilesBuildPhase: PlistSerializable {

    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = plistValues(proj: proj)
        dictionary["isa"] = .string(CommentedString(PBXCopyFilesBuildPhase.isa))
        dictionary["dstPath"] = .string(CommentedString(dstPath))
        if let name = name {
            dictionary["name"] = .string(CommentedString(name))
        }
        dictionary["dstSubfolderSpec"] = .string(CommentedString("\(dstSubfolderSpec.rawValue)"))
        return (key: CommentedString(self.reference, comment: self.name ?? "CopyFiles"), value: .dictionary(dictionary))
    }

}
