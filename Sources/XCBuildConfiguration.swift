import Foundation

// This is the element for listing build configurations.
public struct XCBuildConfiguration: Isa {
   
    // MARK: - Attributes
    
    /// Build configuration reference.
    public let reference: UUID
    
    // Build Configuration isa.
    public let isa: String = "XCBuildConfiguration"
    
    /// The path to a xcconfig file
    public let baseConfigurationReference: UUID?
    
    /// A map of build settings.
    public let buildSettings: [String: Any]
    
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
    public init(reference: UUID,
                name: String,
                baseConfigurationReference: UUID? = nil,
                buildSettings: [String: Any] = [:]) {
        self.reference = reference
        self.baseConfigurationReference = baseConfigurationReference
        self.buildSettings = buildSettings
        self.name = name
    }
    
    // MARK: - Public
    
    /// Returns a new build configuration adding the given setting.
    ///
    /// - Parameters:
    ///   - setting: setting to be added (key)
    ///   - value: setting to be added (value)
    /// - Returns: new build configuration after adding the value.
    public func addingBuild(setting: String, value: Any) -> XCBuildConfiguration {
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
        mutableSettings.removeValue(forKey: setting)
        return XCBuildConfiguration(reference: self.reference,
                                    name: self.name,
                                    baseConfigurationReference: self.baseConfigurationReference,
                                    buildSettings: mutableSettings)
    }
}
