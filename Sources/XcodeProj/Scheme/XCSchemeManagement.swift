import Foundation
import PathKit

public enum XCSchemeManagementError: Error, Equatable, LocalizedError, CustomStringConvertible {
    /// Thrown when the user tries to initialize a XCSchemeManagement instace passing a path to a file that doesn't exist.
    case notFound(path: Path)
    
    public var description: String {
        switch self {
        case let .notFound(path):
            return "Couldn't initialize XCSchemeManagement because the file at path \(path.string) was not found."
        }
    }
    
    public var errorDescription: String? {
        return description
    }
}

/// This struct represents the xcschememanagement.plist file that is generated by Xcode
/// to attach metdata to schemes such as the order of schemes orwhether a scheme is shared or no.
/// The file is formatted as a property list file.
public struct XCSchemeManagement: Codable, Equatable, Writable {
    public struct AutocreationBuildable: Equatable, Codable {
        var primary: Bool
    }
    
    /// Scheme configuration object.
    public struct UserStateScheme: Equatable, Codable {
        
        /// Coding keys
        public enum CodingKeys: String, CodingKey {
            case shared
            case orderHint
            case isShown
            case name
        }

        /// Name of the scheme (with the .xcscheme extension)
        public var name: String
        
        /// True if the scheme should be shared.
        public var shared: Bool
        
        /// Attribute used by Xcode to sort the schemes.
        public var orderHint: Int?
        
        /// True if the scheme should be shown in the list of schemes.
        public var isShown: Bool?
        
        /// The key that should be used when encoding the scheme configuration.
        var key: String {
               var key = name
               if shared {
                   key.append("_^#shared#^_")
               }
               return key
           }
           
        /// It initializes the scheme configuration with its attributes.
        /// - Parameters:
        ///   - name: Name of the scheme (with the .xcscheme extension)
        ///   - shared: True if the scheme should be shared.
        ///   - orderHint: Attribute used by Xcode to sort the schemes.
        ///   - isShown: True if the scheme should be shown in the list of schemes.
        public init(name: String,
                    shared: Bool = false,
                    orderHint: Int? = nil,
                    isShown: Bool? = nil) {
            self.name = name
            self.shared = shared
            self.orderHint = orderHint
            self.isShown = isShown
        }
        
        // MARK: - Codable
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.orderHint = try container.decodeIfPresent(.orderHint)
            self.isShown = try container.decodeIfPresent(.isShown)
            self.shared = try container.decodeIfPresent(.shared) ?? false
            self.name = try container.decode(.name)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            if let orderHint = orderHint {
                try container.encode(orderHint, forKey: .orderHint)
            }
            if let isShown = isShown {
                try container.encode(isShown, forKey: .isShown)
            }
        }
    }

    /// Coding keys.
    public enum CodingKeys: String, CodingKey {
        case schemeUserState = "SchemeUserState"
        case suppressBuildableAutocreation = "SuppressBuildableAutocreation"
    }
    
    /// An array that contains the configuration of the schemes.
    public var schemeUserState: [XCSchemeManagement.UserStateScheme]?
    
    /// A dictionary where the key is the object reference of the target, and the value the configuration for auto-creating schemes.
    public var suppressBuildableAutocreation: [String: XCSchemeManagement.AutocreationBuildable]?

    /// Default constructor.
    /// - Parameters:
    ///   - schemeUserState: An array that contains the configuration of the schemes.
    ///   - suppressBuildableAutocreation: A dictionary where the key is the object reference of the target, and the value the configuration for auto-creating schemes.
    public init(schemeUserState: [XCSchemeManagement.UserStateScheme]? = nil,
                suppressBuildableAutocreation: [String: XCSchemeManagement.AutocreationBuildable]? = nil) {
        self.schemeUserState = schemeUserState
        self.suppressBuildableAutocreation = suppressBuildableAutocreation
    }
    
    /// Initializes the XCSchemeManagement instance by parsing an existing xcschememanagement.plist
    /// - Parameter path: Path to the xcschememanagement.plist file.
    /// - Throws: An error if the file is malformated.
    public init(path: Path) throws {
        if !path.exists {
            throw XCSchemeManagementError.notFound(path: path)
        }
        let decoder = XcodeprojPropertyListDecoder()
        self = try decoder.decode(XCSchemeManagement.self, from: try path.read())
    }
    
    /// Converts the object into a property list and writes it at the given path.
    /// - Parameter path: Path to the file where it should be written.
    /// - Parameter override: if project should be overridden. Default is false.
    ///   If true will remove all existing data before writing.
    ///   If false will throw error iff file exists at the given path.
    /// - Throws: An error if the write fails.
    public func write(path: Path, override: Bool = false) throws {
        if override, path.exists {
            try path.delete()
        }

        let encoder = getEncoder()
        try encoder.encode(self).write(to: path.url)
    }
    
    /// Gets the data representation of the property list representation of the object.
    ///
    /// - Throws: Error if encoding fails.
    public func dataRepresentation() throws -> Data? {
        return try getEncoder().encode(self)
    }

    private func getEncoder() -> PropertyListEncoder {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        return encoder
    }

    // MARK: - Codable

    public init(from decoder: Decoder) throws {
        let plistDecoder = XcodeprojPropertyListDecoder()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.suppressBuildableAutocreation = try container.decodeIfPresent(.suppressBuildableAutocreation)
        if let schemeUserStateDictionary = try container.decodeIfPresent([String: Any].self, forKey: .schemeUserState) {
            self.schemeUserState = try schemeUserStateDictionary
                .sorted(by: { $0.key < $1.key })
                .compactMap({ (key, value) -> XCSchemeManagement.UserStateScheme? in
                var name = key
                guard var valueDictionary = value as? [String: Any] else { return nil }
                if key.contains("_^#shared#^_") {
                    valueDictionary["shared"] = true
                    name = key.replacingOccurrences(of: "_^#shared#^_", with: "")
                }
                valueDictionary["name"] = name
                
                let data = try PropertyListSerialization.data(fromPropertyList: valueDictionary, format: .xml, options: 0)
                return try plistDecoder.decode(XCSchemeManagement.UserStateScheme.self, from: data)
            })
        } else {
            self.suppressBuildableAutocreation = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let suppressBuildableAutocreation = suppressBuildableAutocreation {
            try container.encode(suppressBuildableAutocreation, forKey: .suppressBuildableAutocreation)
        }
        
        if let schemeUserState = schemeUserState {
            let encodableSchemeUserState = schemeUserState
                .reduce(into: [String: XCSchemeManagement.UserStateScheme]()) { $0[$1.key] = $1 }
            try container.encode(encodableSchemeUserState, forKey: .schemeUserState)
        }
    }
}

extension XCSchemeManagement {
    /// Returns scheme management file path relative to the given path.
    ///
    /// - Parameter path: schemes folder
    /// - Returns: scheme management plist path relative to the given path.
    static func path(_ path: Path) -> Path {
        path + "xcschememanagement.plist"
    }
}
