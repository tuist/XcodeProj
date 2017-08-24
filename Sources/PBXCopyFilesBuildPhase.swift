import Foundation
import Unbox

// This is the element for the copy file build phase.
public class PBXCopyFilesBuildPhase: PBXBuildPhase {

    public enum SubFolder: UInt, UnboxableEnum {
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
                buildActionMask: UInt = 2147483647,
                files: Set<String> = [],
                runOnlyForDeploymentPostprocessing: UInt = 0) {
        self.dstPath = dstPath
        self.dstSubfolderSpec = dstSubfolderSpec
        super.init(reference: reference, files: files, buildActionMask: buildActionMask, runOnlyForDeploymentPostprocessing: runOnlyForDeploymentPostprocessing)
    }

    public override init(reference: String, dictionary: [String: Any]) throws {
        let unboxer = Unboxer(dictionary: dictionary)
        self.dstPath = try unboxer.unbox(key: "dstPath")
        let dstSubFolderSpecInt: UInt = try unboxer.unbox(key: "dstSubfolderSpec")
        self.dstSubfolderSpec = SubFolder(rawValue: dstSubFolderSpecInt) ?? .other
        try super.init(reference: reference, dictionary: dictionary)
    }

    public static func == (lhs: PBXCopyFilesBuildPhase,
                           rhs: PBXCopyFilesBuildPhase) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.dstPath == rhs.dstPath &&
            lhs.buildActionMask == rhs.buildActionMask &&
            lhs.dstSubfolderSpec == rhs.dstSubfolderSpec &&
            lhs.files == rhs.files &&
            lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing
    }

}

// MARK: - PBXCopyFilesBuildPhase Extension (PlistSerializable)

extension PBXCopyFilesBuildPhase: PlistSerializable {

    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXCopyFilesBuildPhase.isa))
        dictionary["buildActionMask"] = .string(CommentedString("\(buildActionMask)"))
        dictionary["dstPath"] = .string(CommentedString(dstPath))
        dictionary["dstSubfolderSpec"] = .string(CommentedString("\(dstSubfolderSpec.rawValue)"))
        dictionary["files"] = .array(self.files
            .map { reference in
                let fileName = proj.buildFileName(reference: reference).flatMap { "\($0) in CopyFiles" }
                return PlistValue.string(CommentedString(reference, comment: fileName))
            })
        dictionary["runOnlyForDeploymentPostprocessing"] = .string(CommentedString("\(runOnlyForDeploymentPostprocessing)"))
        return (key: CommentedString(self.reference,
                                                 comment: "CopyFiles"),
                value: .dictionary(dictionary))
    }

}
