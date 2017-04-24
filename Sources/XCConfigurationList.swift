import Foundation

// This is the element for listing build configurations.
public struct XCConfigurationList: Isa {
    
    // MARK: - Attributes
    
    public let reference: UUID
    
    public let isa: String = "XCConfigurationList"
    
    public let buildConfigurations: Set<UUID>
    
    public let defaultConfigurationIsVisible: Int = 0
    
    public let defaultConfigurationName: String
    
    // MARK: - Init
    
    public init(reference: UUID,
                buildConfigurations: Set<UUID>,
                defaultConfigurationName: String) {
        self.reference = reference
        self.buildConfigurations = buildConfigurations
        self.defaultConfigurationName = defaultConfigurationName
    }
    
    // MARK: - Public
    
    public func adding(configuration: UUID) -> XCConfigurationList {
        var buildConfigurations = self.buildConfigurations
        buildConfigurations.update(with: configuration)
        return XCConfigurationList(reference: self.reference,
                                   buildConfigurations: buildConfigurations,
                                   defaultConfigurationName: self.defaultConfigurationName)
    }
    
    public func removing(configuration: UUID) -> XCConfigurationList {
        var buildConfigurations = self.buildConfigurations
        if let index = buildConfigurations.index(of: configuration) {
            buildConfigurations.remove(at: index)
        }
        return XCConfigurationList(reference: self.reference,
                                   buildConfigurations: buildConfigurations,
                                   defaultConfigurationName: self.defaultConfigurationName)

    }
    
    public func withDefaultConfigurationName(name: String) -> XCConfigurationList {
        return XCConfigurationList(reference: self.reference,
                                   buildConfigurations: self.buildConfigurations,
                                   defaultConfigurationName: name)
    }
    
}
