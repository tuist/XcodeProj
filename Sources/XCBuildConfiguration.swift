import Foundation

// This is the element for listing build configurations.
public struct XCBuildConfiguration: Isa {
   
    // MARK: - Attributes
    
    let reference: String
    
    public let isa: String = "XCBuildConfiguration"
    
    /// The path to a xcconfig file
    let baseConfigurationReference: String?
    
    /// A map of build settings.
    let buildSettings: [String: String]
    
    /// The configuration name.
    let name: String
    
    // MARK: - Init
    
    public init(reference: String,
                baseConfigurationReference: String? = nil,
                buildSettings: [String: String],
                name: String) {
        self.reference = reference
        self.baseConfigurationReference = baseConfigurationReference
        self.buildSettings = buildSettings
        self.name = name
    }
    
    // MARK: - Public
    
    public func addingBuild(setting: String, value: String) -> XCBuildConfiguration {
        var mutableSettings = self.buildSettings
        mutableSettings[setting] = value
        return XCBuildConfiguration(reference: self.reference,
                                    baseConfigurationReference: self.baseConfigurationReference,
                                    buildSettings: mutableSettings,
                                    name: self.name)
    }
    
    public func removingBuild(setting: String) -> XCBuildConfiguration {
        var mutableSettings = self.buildSettings
        mutableSettings.removeValue(forKey: setting)
        return XCBuildConfiguration(reference: self.reference,
                                    baseConfigurationReference: self.baseConfigurationReference,
                                    buildSettings: mutableSettings,
                                    name: self.name)
    }
}
