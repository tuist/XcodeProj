import Foundation
import Unbox

// This is the element for the resources copy build phase.
public class PBXShellScriptBuildPhase: PBXBuildPhase, Hashable {

    // MARK: - Attributes

    /// Build phase name.
    public var name: String

    /// Input paths
    public var inputPaths: Set<String>

    /// Output paths
    public var outputPaths: Set<String>

    /// Path to the shell.
    public var shellPath: String

    /// Shell script.
    public var shellScript: String?

    // MARK: - Init

    /// Initializes the shell script build phase with its attributes.
    ///
    /// - Parameters:
    ///   - reference: references.
    ///   - files: shell script files.
    ///   - inputPaths: input paths.
    ///   - outputPaths: output paths.
    ///   - shellPath: shell path.
    ///   - shellScript: shell script.
    ///   - buildActionMask: build action mask.
    public init(reference: String,
                files: Set<String>,
                name: String,
                inputPaths: Set<String>,
                outputPaths: Set<String>,
                shellPath: String = "bin/sh",
                shellScript: String?,
                buildActionMask: UInt = 2147483647,
                runOnlyForDeploymentPostprocessing: UInt = 0) {
        self.name = name
        self.inputPaths = inputPaths
        self.outputPaths = outputPaths
        self.shellPath = shellPath
        self.shellScript = shellScript
        super.init(reference: reference, files: files, buildActionMask: buildActionMask, runOnlyForDeploymentPostprocessing: runOnlyForDeploymentPostprocessing)
    }

    public override init(reference: String, dictionary: [String: Any]) throws {
        let unboxer = Unboxer(dictionary: dictionary)
        self.name = try unboxer.unbox(key: "name")
        self.inputPaths = (unboxer.unbox(key: "inputPaths")) ?? []
        self.outputPaths = (unboxer.unbox(key: "outputPaths")) ?? []
        self.shellPath = try unboxer.unbox(key: "shellPath")
        self.shellScript = unboxer.unbox(key: "shellScript")
        try super.init(reference: reference, dictionary: dictionary)
    }

    public static func == (lhs: PBXShellScriptBuildPhase,
                           rhs: PBXShellScriptBuildPhase) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.buildActionMask == rhs.buildActionMask &&
            lhs.files == rhs.files &&
            lhs.name == rhs.name &&
            lhs.inputPaths == rhs.inputPaths &&
            lhs.outputPaths == rhs.outputPaths &&
            lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing &&
            lhs.shellPath == rhs.shellPath &&
            lhs.shellScript == rhs.shellScript
    }

}

// MARK: - PBXShellScriptBuildPhase Extension (PlistSerializable)

extension PBXShellScriptBuildPhase: PlistSerializable {

    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = plistValues(proj: proj)
        dictionary["isa"] = .string(CommentedString(PBXShellScriptBuildPhase.isa))
        dictionary["shellPath"] = .string(CommentedString(shellPath))
        dictionary["inputPaths"] = .array(inputPaths.map({.string(CommentedString($0))}))
        dictionary["name"] = .string(CommentedString(name))
        dictionary["outputPaths"] = .array(outputPaths.map({.string(CommentedString($0))}))
        if let shellScript = shellScript {
            dictionary["shellScript"] = .string(CommentedString(shellScript))
        }
        return (key: CommentedString(self.reference, comment: "Run Script"), value: .dictionary(dictionary))
    }

}
