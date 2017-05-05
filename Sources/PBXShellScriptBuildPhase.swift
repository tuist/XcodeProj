import Foundation
import Unbox

// This is the element for the resources copy build phase.
public struct PBXShellScriptBuildPhase: Isa, Hashable {

    // MARK: - Attributes
    
    /// Element reference.
    public let reference: UUID
    
    /// Element isa.
    public let isa: String = "PBXShellScriptBuildPhase"
    
    /// Build action mask
    public let buildActionMask: Int = 2147483647

    /// Files references
    public let files: [UUID]

    /// Input paths
    public let inputPaths: [String]

    /// Output paths
    public let outputPaths: [String]

    /// Run only for deployment post processing attribute.
    public let runOnlyForDeploymentPostprocessing: Int = 0

    /// Path to the shell.
    public let shellPath: String

    /// Shell script.
    public let shellScript: String?

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
    init(reference: UUID,
         files: [UUID],
         inputPaths: [String],
         outputPaths: [String],
         shellPath: String,
         shellScript: String?) {
        self.reference = reference
        self.files = files
        self.inputPaths = inputPaths
        self.outputPaths = outputPaths
        self.shellPath = shellPath
        self.shellScript = shellScript
    }
    
    /// Initializes the shell script build phase with its reference and a dictionary that contains its attributes.
    ///
    /// - Parameters:
    ///   - reference: build phase reference.
    ///   - dictionary: dictionary with the build phase attributes.
    /// - Throws: throws an error in case any of the parameters is missing or it has the wrong type.
    public init(reference: UUID, dictionary: [String: Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.files = try unboxer.unbox(key: "files")
        self.inputPaths = (unboxer.unbox(key: "inputPaths")) ?? []
        self.outputPaths = (unboxer.unbox(key: "outputPaths")) ?? []
        self.shellPath = try unboxer.unbox(key: "shellPath")
        self.shellScript = unboxer.unbox(key: "shellScript")
    }
    
    // MARK: - Public
    
    /// Returns a new shell script build phase with a new file added.
    ///
    /// - Parameter file: reference file to be added.
    /// - Returns: new build phase with the file added.
    public func adding(file: UUID) -> PBXShellScriptBuildPhase {
        var files = self.files
        files.append(file)
        return PBXShellScriptBuildPhase(reference: reference,
                                        files: files,
                                        inputPaths: inputPaths,
                                        outputPaths: outputPaths,
                                        shellPath: shellPath,
                                        shellScript: shellScript)
    }
    
    /// Returns a new shell script build phase removing a file.
    ///
    /// - Parameter file: reference to the file to be removed.
    /// - Returns: new shell script build phase with the file removed.
    public func removing(file: UUID) -> PBXShellScriptBuildPhase {
        var files = self.files
        if let index = files.index(of: file) {
            files.remove(at: index)
        }
        return PBXShellScriptBuildPhase(reference: reference,
                                        files: files,
                                        inputPaths: inputPaths,
                                        outputPaths: outputPaths,
                                        shellPath: shellPath,
                                        shellScript: shellScript)
    }
    
    /// Returns a new shell script build phase adding a new input path.
    ///
    /// - Parameter inputPath: input path to be added.
    /// - Returns: new shell script build phase with the input path added.
    public func adding(inputPath: String) -> PBXShellScriptBuildPhase {
        var inputPaths = self.inputPaths
        inputPaths.append(inputPath)
        return PBXShellScriptBuildPhase(reference: reference,
                                        files: files,
                                        inputPaths: inputPaths,
                                        outputPaths: outputPaths,
                                        shellPath: shellPath,
                                        shellScript: shellScript)
    }
    
    /// Returns a new shell script build phase removing an input path/
    ///
    /// - Parameter inputPath: input path to be removed.
    /// - Returns: new shell script build phase with the input path removed.
    public func removing(inputPath: String) -> PBXShellScriptBuildPhase {
        var inputPaths = self.inputPaths
        if let index = inputPaths.index(of: inputPath) {
            inputPaths.remove(at: index)
        }
        return PBXShellScriptBuildPhase(reference: reference,
                                        files: files,
                                        inputPaths: inputPaths,
                                        outputPaths: outputPaths,
                                        shellPath: shellPath,
                                        shellScript: shellScript)
    }
    
    /// Returns a new shell script build phase adding an output path.
    ///
    /// - Parameter outputPath: output path to be added.
    /// - Returns: new shell script build phsae with the output path added.
    public func adding(outputPath: String) -> PBXShellScriptBuildPhase {
        var outputPaths = self.outputPaths
        outputPaths.append(outputPath)
        return PBXShellScriptBuildPhase(reference: reference,
                                        files: files,
                                        inputPaths: inputPaths,
                                        outputPaths: outputPaths,
                                        shellPath: shellPath,
                                        shellScript: shellScript)
    }
    
    /// Returns a new shell script build phase removing an output path.
    ///
    /// - Parameter outputPath: output path to be removed.
    /// - Returns: new shell script build phsae with the output path removed.
    public func removing(outputPath: String) -> PBXShellScriptBuildPhase {
        var outputPaths = self.outputPaths
        if let index = outputPaths.index(of: outputPath) {
            outputPaths.remove(at: index)
        }
        return PBXShellScriptBuildPhase(reference: reference,
                                        files: files,
                                        inputPaths: inputPaths,
                                        outputPaths: outputPaths,
                                        shellPath: shellPath,
                                        shellScript: shellScript)
    }

    // MARK: - Hashable
    
    public static func == (lhs: PBXShellScriptBuildPhase,
                           rhs: PBXShellScriptBuildPhase) -> Bool {
        return lhs.reference == rhs.reference &&
        lhs.isa == rhs.isa &&
        lhs.buildActionMask == rhs.buildActionMask &&
        lhs.files == rhs.files &&
        lhs.inputPaths == rhs.inputPaths &&
        lhs.outputPaths == rhs.outputPaths &&
        lhs.runOnlyForDeploymentPostprocessing == rhs.runOnlyForDeploymentPostprocessing &&
        lhs.shellPath == rhs.shellPath &&
        lhs.shellScript == rhs.shellScript
    }
    
    public var hashValue: Int { return self.reference.hashValue }

}
