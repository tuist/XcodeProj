import Foundation
import Unbox

// This is the element for listing build configurations.
public struct XCBuildConfiguration {
   
    // MARK: - Attributes
    
    /// Build configuration reference.
    public let reference: String
    
    /// The path to a xcconfig file
    public let baseConfigurationReference: String?
    
    /// A map of build settings.
    public let buildSettings: BuildSettings
    
    /// The configuration name.
    public let name: String
    
    // MARK: - Init
    
    /// Initializes a build configuration.
    ///
    /// - Parameters:
    ///   - reference: build configuration reference.
    ///   - name: build configuration name.
    ///   - baseConfigurationReference: reference to the base configuration.
    ///   - buildSettings: dictionary that contains the build settings for this configuration.
    public init(reference: String,
                name: String,
                baseConfigurationReference: String? = nil,
                buildSettings: BuildSettings = [:]) {
        self.reference = reference
        self.baseConfigurationReference = baseConfigurationReference
        self.buildSettings = buildSettings
        self.name = name
    }
    
}

// MARK: - XCBuildConfiguration Extension (Extras)

extension XCBuildConfiguration {
    
    /// Returns a new build configuration adding the given setting.
    ///
    /// - Parameters:
    ///   - setting: setting to be added (key)
    ///   - value: setting to be added (value)
    /// - Returns: new build configuration after adding the value.
    public func addingBuild(setting: String, value: String) -> XCBuildConfiguration {
        var mutableSettings = self.buildSettings
        mutableSettings[setting] = value
        return XCBuildConfiguration(reference: self.reference,
                                    name: self.name,
                                    baseConfigurationReference: self.baseConfigurationReference,
                                    buildSettings: mutableSettings)
    }
    
    /// Returns a build configuration by removing the given build setting.
    ///
    /// - Parameter setting: build setting to be removed.
    /// - Returns: new build configuration after removing the build setting.
    public func removingBuild(setting: String) -> XCBuildConfiguration {
        var mutableSettings = self.buildSettings
        mutableSettings[setting] = nil
        return XCBuildConfiguration(reference: self.reference,
                                    name: self.name,
                                    baseConfigurationReference: self.baseConfigurationReference,
                                    buildSettings: mutableSettings)
    }
    
}

// MARK: - XCBuildConfiguration Extension (ProjectElement)

extension XCBuildConfiguration: ProjectElement {
    
    public static var isa: String = "XCBuildConfiguration"
    
    public var hashValue: Int { return self.reference.hashValue }
    
    public static func == (lhs: XCBuildConfiguration,
                           rhs: XCBuildConfiguration) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.baseConfigurationReference == rhs.baseConfigurationReference &&
            lhs.name == rhs.name &&
            NSDictionary(dictionary: lhs.buildSettings.dictionary).isEqual(to: rhs.buildSettings.dictionary)
    }
    
    public init(reference: String, dictionary: [String: Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.baseConfigurationReference = unboxer.unbox(key: "baseConfigurationReference")
        self.buildSettings = BuildSettings(dictionary: (dictionary["buildSettings"] as? [String: Any]) ?? [:])
        self.name = try unboxer.unbox(key: "name")
    }
    
}

// MARK: - XCBuildConfiguration Extension (PlistSerializable)

extension XCBuildConfiguration: PlistSerializable {
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(XCBuildConfiguration.isa))
        dictionary["name"] = .string(CommentedString(name))
        dictionary["buildSettings"] = buildSettings.dictionary.plist()
        return (key: CommentedString(self.reference,
                                                 comment: name),
                value: .dictionary(dictionary))
    }
    
}
