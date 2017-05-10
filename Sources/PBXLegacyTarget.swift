import Foundation
import Unbox

/// Legacy target.
public struct PBXLegacyTarget: PBXTarget {

    // MARK: - Properties
    
    /// Element isa.
    public let isa: String = "PBXLegacyTarget"
    
    /// Element reference.
    public let reference: UUID
    
    /// Target build argument string.
    public let buildArgumentsString: String
    
    /// Target build tool path.
    public let buildToolPath: String
    
    /// Target build working directory.
    public let buildWorkingDirectory: String

    /// Target pass build settings in environment flag.
    public let passBuildSettingsInEnvironment: UInt

    // MARK: - Init
    
    /// Initializes the legacy target with its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - buildArgumentsString: target build arguments string.
    ///   - buildToolPath: target build tool path.
    ///   - buildWorkingDirectory: target build working directory.
    ///   - passBuildSettingsInEnvironment: target pass build settings in environment flag.
    public init(reference: UUID,
                buildArgumentsString: String,
                buildToolPath: String,
                buildWorkingDirectory: String,
                passBuildSettingsInEnvironment: UInt) {
        self.reference = reference
        self.buildArgumentsString = buildArgumentsString
        self.buildToolPath = buildToolPath
        self.buildWorkingDirectory = buildWorkingDirectory
        self.passBuildSettingsInEnvironment = passBuildSettingsInEnvironment
    }
    
    /// Constructor that initializes the project element with the reference and a dictionary with its properties.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: dictionary with the element properties.
    /// - Throws: throws an error in case any of the propeties are missing or they have the wrong type.
    public init(reference: UUID, dictionary: [String : Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.buildArgumentsString = try unboxer.unbox(key: "buildArgumentsString")
        self.buildToolPath = try unboxer.unbox(key: "buildToolPath")
        self.buildWorkingDirectory = try unboxer.unbox(key: "buildWorkingDirectory")
        self.passBuildSettingsInEnvironment = try unboxer.unbox(key: "passBuildSettingsInEnvironment")
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXLegacyTarget,
                           rhs: PBXLegacyTarget) -> Bool {
        return lhs.isa == rhs.isa &&
        lhs.reference == rhs.reference &&
        lhs.buildArgumentsString == rhs.buildArgumentsString &&
        lhs.buildToolPath == rhs.buildToolPath &&
        lhs.buildWorkingDirectory == rhs.buildWorkingDirectory &&
        lhs.passBuildSettingsInEnvironment == rhs.passBuildSettingsInEnvironment
    }

    public var hashValue: Int { return self.reference.hashValue }
    
}
