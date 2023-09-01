import Foundation
import PathKit

public enum WorkspaceSettingsError: Error {
    /// thrown when the settings file was not found.
    case notFound(path: Path)
}

/// It represents the WorkspaceSettings.xcsettings file under a workspace data directory.
public class WorkspaceSettings: Codable, Equatable, Writable {
    public enum BuildSystem: String {
        /// Original build system
        case original = "Original"

        /// New build system
        case new
    }

    public enum DerivedDataLocationStyle: String {
        /// Default derived data
        case `default` = "Default"

        /// Absolute path
        case absolutePath = "AbsolutePath"

        /// Relative paht
        case workspaceRelativePath = "WorkspaceRelativePath"
    }

    /// Workspace build system.
    public var buildSystem: BuildSystem

    /// Workspace DerivedData directory.
    public var derivedDataLocationStyle: DerivedDataLocationStyle?

    /// Path to workspace DerivedData directory.
    public var derivedDataCustomLocation: String?

    /// When true, Xcode auto-creates schemes in the project.
    public var autoCreateSchemes: Bool?

    /// Decodable coding keys.
    ///
    /// - buildSystem: Build system.
    enum CodingKeys: String, CodingKey {
        case buildSystem = "BuildSystemType"
        case derivedDataLocationStyle = "DerivedDataLocationStyle"
        case derivedDataCustomLocation = "DerivedDataCustomLocation"
        case autoCreateSchemes = "IDEWorkspaceSharedSettings_AutocreateContextsIfNeeded"
    }

    /// Initializes the settings with its attributes.
    ///
    /// - Parameters:
    ///   - buildSystem: Workspace build system.
    ///   - derivedDataLocationStyle: Workspace DerivedData directory.
    ///   - derivedDataCustomLocation: Path to workspace DerivedData directory.
    ///   - autoCreateSchemes: When true, Xcode auto-creates schemes in the project.
    public init(buildSystem: BuildSystem = .new,
                derivedDataLocationStyle: DerivedDataLocationStyle? = nil,
                derivedDataCustomLocation: String? = nil,
                autoCreateSchemes: Bool? = nil)
    {
        self.buildSystem = buildSystem
        self.derivedDataLocationStyle = derivedDataLocationStyle
        self.derivedDataCustomLocation = derivedDataCustomLocation
        self.autoCreateSchemes = autoCreateSchemes
    }

    /// Initializes the settings decoding the values from the plist representation.
    ///
    /// - Parameter decoder: Property list decoder.
    /// - Throws: An error if required attributes are missing or have a wrong type.
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let buildSystemString: String = try container.decodeIfPresent(.buildSystem),
           let buildSystem = BuildSystem(rawValue: buildSystemString)
        {
            self.buildSystem = buildSystem
        } else {
            buildSystem = .new
        }
        if let derivedDataLocationStyleString: String = try container.decodeIfPresent(.derivedDataLocationStyle),
           let derivedDataLocationStyle = DerivedDataLocationStyle(rawValue: derivedDataLocationStyleString)
        {
            self.derivedDataLocationStyle = derivedDataLocationStyle
        } else {
            derivedDataLocationStyle = .default
        }
        derivedDataCustomLocation = try container.decodeIfPresent(.derivedDataCustomLocation)
        autoCreateSchemes = try container.decodeIfPresent(.autoCreateSchemes)
    }

    /// Encodes the settings into the given encoder.
    ///
    /// - Parameter encoder: Encoder where the settings will be encoded into.
    /// - Throws: An error if the settings can't be encoded.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if buildSystem == .original {
            try container.encode(buildSystem.rawValue, forKey: .buildSystem)
        }
        if let derivedDataLocationStyle = derivedDataLocationStyle {
            try container.encode(derivedDataLocationStyle.rawValue, forKey: .derivedDataLocationStyle)
        }
        if let derivedDataCustomLocation = derivedDataCustomLocation {
            try container.encode(derivedDataCustomLocation, forKey: .derivedDataCustomLocation)
        }
        if let autoCreateSchemes = autoCreateSchemes {
            try container.encode(autoCreateSchemes, forKey: .autoCreateSchemes)
        }
    }

    /// Initializes the settings reading the values from the WorkspaceSettings.xcsettings file.
    ///
    /// - Parameter path: Path to the WorkspaceSettings.xcsettings
    /// - Returns: The initialized workspace settings.
    /// - Throws: An error if the file doesn't exist or has an invalid format.
    public static func at(path: Path) throws -> WorkspaceSettings {
        if !path.exists {
            throw WorkspaceSettingsError.notFound(path: path)
        }
        let data = try Data(contentsOf: path.url)
        let plistDecoder = PropertyListDecoder()
        return try plistDecoder.decode(WorkspaceSettings.self, from: data)
    }

    /// Compares two instances of WorkspaceSettings and retrus true if the two instances are equal.
    ///
    /// - Parameters:
    ///   - lhs: First instance to be compared.
    ///   - rhs: Second instance to be compared.
    /// - Returns: True if the two instances are the same.
    public static func == (lhs: WorkspaceSettings, rhs: WorkspaceSettings) -> Bool {
        lhs.buildSystem == rhs.buildSystem &&
            lhs.autoCreateSchemes == rhs.autoCreateSchemes &&
            lhs.derivedDataLocationStyle == rhs.derivedDataLocationStyle &&
            lhs.derivedDataCustomLocation == rhs.derivedDataCustomLocation
    }

    /// Writes the workspace settings.
    ///
    /// - Parameter path: The path to write to
    /// - Parameter override: True if the content should be overriden if it already exists.
    /// - Throws: writing error if something goes wrong.
    public func write(path: Path, override: Bool) throws {
        guard let data = try dataRepresentation() else {
            return
        }
        if override, path.exists {
            try path.delete()
        }
        try path.write(data)
    }
    
    /// Get the workspace settings.
    ///
    /// - Throws: reading error if something goes wrong.
    public func dataRepresentation() throws -> Data? {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let data = try encoder.encode(self)
        return data
    }
}

extension WorkspaceSettings {
    static func path(_ path: Path) -> Path {
        path + "WorkspaceSettings.xcsettings"
    }
}
