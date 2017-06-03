import Foundation
import Unbox

// This is the element for listing build configurations.
public struct XCConfigurationList: ProjectElement {
    
    // MARK: - Attributes
    
    /// Element reference.
    public let reference: UUID
    
    /// Element isa.
    public static var isa: String = "XCConfigurationList"
    
    /// Element build configurations.
    public let buildConfigurations: Set<UUID>
    
    /// Element default configuration is visible.
    public let defaultConfigurationIsVisible: UInt
    
    /// Element default configuration name
    public let defaultConfigurationName: String
    
    // MARK: - Init
    
    /// Initializes the element with its properties.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - buildConfigurations: element build configurations.
    ///   - defaultConfigurationName: element default configuration name.
    ///   - defaultConfigurationIsVisible: default configuration is visible.
    public init(reference: UUID,
                buildConfigurations: Set<UUID>,
                defaultConfigurationName: String,
                defaultConfigurationIsVisible: UInt = 0) {
        self.reference = reference
        self.buildConfigurations = buildConfigurations
        self.defaultConfigurationName = defaultConfigurationName
        self.defaultConfigurationIsVisible = defaultConfigurationIsVisible
    }
    
    /// Initializes the element with the reference and a dictionary that contains its properties.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: dictionary that contains its properties.
    /// - Throws: an error if any of the attributes is missing or the type is wrong.
    public init(reference: UUID, dictionary: [String : Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.buildConfigurations = try unboxer.unbox(key: "buildConfigurations")
        self.defaultConfigurationIsVisible = try unboxer.unbox(key: "defaultConfigurationIsVisible")
        self.defaultConfigurationName = try unboxer.unbox(key: "defaultConfigurationName")
    }
    
    // MARK: - Public
    
    /// Returns a new configuration list adding a configuration.
    ///
    /// - Parameter configuration: refrence to the configuration to be added.
    /// - Returns: new configuration list with the configuration added.
    public func adding(configuration: UUID) -> XCConfigurationList {
        var buildConfigurations = self.buildConfigurations
        buildConfigurations.update(with: configuration)
        return XCConfigurationList(reference: self.reference,
                                   buildConfigurations: buildConfigurations,
                                   defaultConfigurationName: self.defaultConfigurationName)
    }
    
    /// Returns a new configuration list removing a configuration.
    ///
    /// - Parameter configuration: reference to the configuration to be removed.
    /// - Returns: new configuration list with the configuration removed.
    public func removing(configuration: UUID) -> XCConfigurationList {
        var buildConfigurations = self.buildConfigurations
        buildConfigurations.remove(configuration)
        return XCConfigurationList(reference: self.reference,
                                   buildConfigurations: buildConfigurations,
                                   defaultConfigurationName: self.defaultConfigurationName)

    }
    
    public func withDefaultConfigurationName(name: String) -> XCConfigurationList {
        return XCConfigurationList(reference: self.reference,
                                   buildConfigurations: self.buildConfigurations,
                                   defaultConfigurationName: name)
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: XCConfigurationList,
                           rhs: XCConfigurationList) -> Bool {
        return lhs.reference == rhs.reference &&
        lhs.buildConfigurations == rhs.buildConfigurations &&
        lhs.defaultConfigurationIsVisible == rhs.defaultConfigurationIsVisible
    }
    
    public var hashValue: Int { return self.reference.hashValue }

}
