import Foundation
import PathKit

public enum WorkspaceSettingsError: Error {
    /// thrown when the settings file was not found.
    case notFound(path: Path)
}

/// It represents the WorkspaceSettings.xcsettings file under a workspace data directory.
public class WorkspaceSettings: Decodable {
    /// Workspace build system.
    public let buildSystem: String?

    /// Decodable coding keys.
    ///
    /// - buildSystem: Build system.
    enum CodingKeys: String, CodingKey {
        case buildSystem = "BuildSystemType"
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
}
