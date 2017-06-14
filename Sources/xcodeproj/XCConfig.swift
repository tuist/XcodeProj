import Foundation
import PathKit
import xcodeprojprotocols

/// .xcconfig configuration file.
public struct XCConfig {
    
    // MARK - Attributes
    
    /// Configuration file path.
    public let path: Path
    
    /// Configuration file includes.
    public let includes: [XCConfig]
    
    /// Build settings
    fileprivate let buildSettings: BuildSettings
 
    // MARK: - Init
    
    /// Initializes the XCConfig reading the content from the file at the given path and parsing it.
    ///
    /// - Parameter path: path where the .xcconfig file is.
    /// - Throws: an error if the config file cannot be found or it has an invalid format.
    public init(path: Path) throws {
        let fm = FileManager.default
        if !fm.fileExists(atPath: path.string) { throw XCConfigError.notFound(path: path) }
        self.path = path
        self.includes = []
        self.buildSettings = [:]
    }
    
    /// Initializes the XCConfig file with its attributes.
    ///
    /// - Parameters:
    ///   - path: path where the .xcconfig file is.
    ///   - includes: all the .xcconfig file includes. The order is very important since it determines how the values get overriden.
    ///   - dictionary: dictionary that contains the config.
    public init(path: Path, includes: [XCConfig], buildSettings: BuildSettings) {
        self.path = path
        self.includes = includes
        self.buildSettings = buildSettings
    }
    
}

// MARK: - XCConfig Extension (Helpers)

extension XCConfig {
    
    /// It returns the build settings after flattening all the includes.
    ///
    /// - Returns: build settings flattening all the includes.
    public func flattenedBuildSettings() -> BuildSettings {
        var content: [String: String] = buildSettings.dictionary
        includes.flattened()
            .map { $0.buildSettings.dictionary }
            .forEach { (configDictionary) in
                configDictionary.forEach { (key, value) in
                    if content[key] == nil { content[key] = value }
                }
        }
        return BuildSettings(dictionary: content)
    }
    
}

// MARK: - XCConfig Extension (Writable)

extension XCConfig: Writable {
    
    public func write(override: Bool) throws {
        var content = ""
        content.append(writeIncludes())
        content.append("\n")
        content.append(writeBuildSettings())
        let fm = FileManager.default
        if override && fm.fileExists(atPath: path.string) {
            try fm.removeItem(atPath: path.string)
        }
        try content.data(using: .utf8)?.write(to: path.url)
    }

    private func writeIncludes() -> String {
        var content = ""
        includes.forEach { (config) in
            //TODO
//            path.
            content.append("#include \"\";\n")
        }
        content.append("\n")
        return content
    }
    
    private func writeBuildSettings() -> String {
        var content = ""
        buildSettings.dictionary.forEach { (key, value) in
            content.append("\(key) = \(value);\n")
        }
        content.append("\n")
        return content
    }
    
}

// MARK: - Array Extension (XCConfig)

extension Array where Element == XCConfig {
    
    /// It returns an array with the XCConfig reversely flattened. It's useful for resolving the build settings.
    ///
    /// - Returns: flattened configurations array.
    func flattened() -> [XCConfig] {
        let reversed = self.reversed()
            .flatMap { (config) -> [XCConfig] in
                var configs = [XCConfig(path: config.path, includes: [], buildSettings: config.buildSettings)]
                configs.append(contentsOf: config.includes.flattened())
                return configs
            }
        return reversed
    }
    
}

// MARK: - XCConfigError

/// XCConfig errors.
///
/// - notFound: returned when the configuration file couldn't be found.
public enum XCConfigError: Error, CustomStringConvertible {
    case notFound(path: Path)
    public var description: String {
        switch self {
        case .notFound(let path):
            return "XCConfig file not found at \(path)"
        }
    }
}
