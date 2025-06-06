import Foundation
import PathKit

public typealias XCConfigInclude = (include: Path, config: XCConfig)

/// .xcconfig configuration file.
public final class XCConfig {
    // MARK: - Attributes

    /// Configuration file includes.
    public var includes: [XCConfigInclude]

    /// Build settings
    public var buildSettings: BuildSettings

    // MARK: - Init

    /// Initializes the XCConfig file with its attributes.
    ///
    /// - Parameters:
    ///   - includes: all the .xcconfig file includes. The order determines how the values get overriden.
    ///   - dictionary: dictionary that contains the config.
    public init(includes: [XCConfigInclude], buildSettings: BuildSettings = [:]) {
        self.includes = includes
        self.buildSettings = buildSettings
    }

    /// Initializes the XCConfig reading the content from the file at the given path and parsing it.
    ///
    /// - Parameter path: path where the .xcconfig file is.
    /// - Parameter projectPath: path where the .xcodeproj is, for resolving project-relative includes.
    /// - Throws: an error if the config file cannot be found or it has an invalid format.
    public init(path: Path, projectPath: Path? = nil) throws {
        if !path.exists { throw XCConfigError.notFound(path: path) }
        let fileLines = try path.read().components(separatedBy: "\n")
        includes = fileLines
            .compactMap(XCConfigParser.configFrom(path: path, projectPath: projectPath))
        var buildSettings: BuildSettings = [:]
        fileLines
            .compactMap(XCConfigParser.settingFrom)
            .forEach { buildSettings[$0.key] = .string($0.value) }
        self.buildSettings = buildSettings
    }
}

enum XCConfigParser {
    /// Given the path the line is being parsed from, it returns a function that parses a line,
    /// and returns the include path and the config that the include is pointing to.
    ///
    /// - Parameter path: path of the config file that the line belongs to.
    /// - Parameter projectPath: path where the .xcodeproj is, for resolving project-relative includes.
    /// - Returns: function that parses the line.
    static func configFrom(path: Path, projectPath: Path?) -> (String) -> (include: Path, config: XCConfig)? {
        { line in
            includeRegex.matches(in: line,
                                 options: [],
                                 range: NSRange(location: 0,
                                                length: line.count))
                .compactMap { match -> String? in
                    if match.numberOfRanges == 2 {
                        return NSString(string: line).substring(with: match.range(at: 1))
                    }
                    return nil
                }
                .compactMap { pathString -> (include: Path, config: XCConfig)? in
                    let includePath: Path = .init(pathString)
                    var config: XCConfig?
                    do {
                        // first try to load the included xcconfig relative to the current xcconfig
                        config = try XCConfig(path: path.parent() + includePath, projectPath: projectPath)
                    } catch XCConfigError.notFound(_) where projectPath != nil {
                        // if that fails, try to load the included xcconfig relative to the project
                        config = try? XCConfig(path: projectPath!.parent() + includePath, projectPath: projectPath)
                    } catch {
                        config = nil
                    }
                    return config.map { (includePath, $0) }
                }
                .first
        }
    }

    static func settingFrom(line: String) -> (key: String, value: String)? {
        settingRegex.matches(in: line,
                             options: [],
                             range: NSRange(location: 0,
                                            length: line.count))
            .compactMap { match -> (key: String, value: String)? in
                if match.numberOfRanges == 3 {
                    let key: String = NSString(string: line).substring(with: match.range(at: 1))
                    let value: String = NSString(string: line).substring(with: match.range(at: 2))
                    return (key, value)
                }
                return nil
            }
            .first
    }

    // swiftlint:disable:next force_try
    private static let includeRegex = try! NSRegularExpression(pattern: "#include\\s+\"(.+\\.xcconfig)\"", options: .caseInsensitive)
    // swiftlint:disable:next force_try
    private static let settingRegex = try! NSRegularExpression(pattern: "^([a-zA-Z0-9_\\[\\]=\\*~]+)\\s*=\\s*(\"?.*?\"?)\\s*(?:;\\s*)?(?=$|\\/\\/)", options: [])
}

// MARK: - XCConfig Extension (Equatable)

extension XCConfig: Equatable {
    public static func == (lhs: XCConfig, rhs: XCConfig) -> Bool {
        if lhs.includes.count != rhs.includes.count { return false }
        for index in 0 ..< lhs.includes.count {
            let lhsInclude = lhs.includes[index]
            let rhsInclude = rhs.includes[index]
            if lhsInclude.config != rhsInclude.config || lhsInclude.include != rhsInclude.include {
                return false
            }
        }
        return lhs.buildSettings == rhs.buildSettings
    }
}

// MARK: - XCConfig Extension (Helpers)

public extension XCConfig {
    /// It returns the build settings after flattening all the includes.
    ///
    /// - Returns: build settings flattening all the includes.
    func flattenedBuildSettings() -> [String: BuildSetting] {
        var content: [String: BuildSetting] = buildSettings
        includes
            .map(\.1)
            .flattened()
            .map(\.buildSettings)
            .forEach { configDictionary in
                for (key, value) in configDictionary {
                    if content[key] == nil { content[key] = value }
                }
            }
        return content
    }
}

// MARK: - XCConfig Extension (Writable)

extension XCConfig: Writable {
    public func write(path: Path, override: Bool) throws {
        let content = getContent()
        if override, path.exists {
            try path.delete()
        }
        try path.write(content)
    }

    public func dataRepresentation() throws -> Data? {
        getContent().data(using: .utf8)
    }

    private func getContent() -> String {
        var content = ""
        content.append(writeIncludes())
        content.append("\n")
        content.append(writeBuildSettings())
        return content
    }

    private func writeIncludes() -> String {
        var content = ""
        for include in includes {
            content.append("#include \"\(include.0.string)\"\n")
        }
        content.append("\n")
        return content
    }

    private func writeBuildSettings() -> String {
        var content = ""
        for (key, value) in buildSettings {
            content.append("\(key) = \(value)\n")
        }
        content.append("\n")
        return content
    }
}

// MARK: - Array Extension (XCConfig)

extension [XCConfig] {
    /// It returns an array with the XCConfig reversely flattened. It's useful for resolving the build settings.
    ///
    /// - Returns: flattened configurations array.
    func flattened() -> [XCConfig] {
        let reversed = reversed()
            .flatMap { config -> [XCConfig] in
                var configs = [XCConfig(includes: [], buildSettings: config.buildSettings)]
                configs.append(contentsOf: config.includes.map(\.1).flattened())
                return configs
            }
        return reversed
    }
}
