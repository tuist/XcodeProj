import Foundation

// This is the element for the resources copy build phase.
public class PBXShellScriptBuildPhase: PBXBuildPhase, Hashable {

    // MARK: - Attributes

    /// Build phase name.
    public var name: String?

    /// Input paths
    public var inputPaths: [String]

    /// Output paths
    public var outputPaths: [String]

    /// Path to the shell.
    public var shellPath: String

    /// Shell script.
    public var shellScript: String?

    /// Show environment variables in the logs.
    public var showEnvVarsInLog: UInt?

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
                files: [String],
                name: String? = nil,
                inputPaths: [String],
                outputPaths: [String],
                shellPath: String = "/bin/sh",
                shellScript: String?,
                buildActionMask: UInt = 2147483647,
                runOnlyForDeploymentPostprocessing: UInt = 0,
                showEnvVarsInLog: UInt? = nil) {
        self.name = name
        self.inputPaths = inputPaths
        self.outputPaths = outputPaths
        self.shellPath = shellPath
        self.shellScript = shellScript
        self.showEnvVarsInLog = showEnvVarsInLog
        super.init(reference: reference,
                   files: files,
                   buildActionMask: buildActionMask,
                   runOnlyForDeploymentPostprocessing: runOnlyForDeploymentPostprocessing)
    }

    // MARK: - Decodable
    
    fileprivate enum CodingKeys: String, CodingKey {
        case name
        case inputPaths
        case outputPaths
        case shellPath
        case shellScript
        case showEnvVarsInLog
        case reference
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(.name)
        self.inputPaths = (try container.decodeIfPresent(.inputPaths)) ?? []
        self.outputPaths = (try container.decodeIfPresent(.outputPaths)) ?? []
        self.shellPath = try container.decode(.shellPath)
        self.shellScript = try container.decodeIfPresent(.shellScript)
        self.showEnvVarsInLog = try container.decodeIfPresent(.showEnvVarsInLog)
        try super.init(from: decoder)
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
            lhs.shellScript == rhs.shellScript &&
            lhs.showEnvVarsInLog == rhs.showEnvVarsInLog
    }

}

// MARK: - PBXShellScriptBuildPhase Extension (PlistSerializable)

extension PBXShellScriptBuildPhase: PlistSerializable {

    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = plistValues(proj: proj)
        dictionary["isa"] = .string(CommentedString(PBXShellScriptBuildPhase.isa))
        dictionary["shellPath"] = .string(CommentedString(shellPath))
        dictionary["inputPaths"] = .array(inputPaths.map({.string(CommentedString($0))}))
        if let name = name {
            dictionary["name"] = .string(CommentedString(name))
        }
        dictionary["outputPaths"] = .array(outputPaths.map({.string(CommentedString($0))}))
        if let shellScript = shellScript {
            dictionary["shellScript"] = .string(CommentedString(shellScript))
        }
        if let showEnvVarsInLog = showEnvVarsInLog {
            dictionary["showEnvVarsInLog"] = .string(CommentedString("\(showEnvVarsInLog)"))
        }
        return (key: CommentedString(self.reference, comment: self.name ?? "ShellScript"), value: .dictionary(dictionary))
    }

}
