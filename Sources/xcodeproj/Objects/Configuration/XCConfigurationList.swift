import Foundation

/// This is the element for listing build configurations.
public final class XCConfigurationList: PBXObject {

    // MARK: - Attributes

    /// Element build configurations.
    public var buildConfigurationReferences: [PBXObjectReference]

    /// Element default configuration is visible.
    public var defaultConfigurationIsVisible: Bool

    /// Element default configuration name
    public var defaultConfigurationName: String?

    // MARK: - Init

    /// Initializes the element with its properties.
    ///
    /// - Parameters:
    ///   - buildConfigurationReferences: element build configurations.
    ///   - defaultConfigurationName: element default configuration name.
    ///   - defaultConfigurationIsVisible: default configuration is visible.
    public init(buildConfigurationReferences: [PBXObjectReference] = [],
                defaultConfigurationName: String? = nil,
                defaultConfigurationIsVisible: Bool = false) {
        self.buildConfigurationReferences = buildConfigurationReferences
        self.defaultConfigurationName = defaultConfigurationName
        self.defaultConfigurationIsVisible = defaultConfigurationIsVisible
        super.init()
    }

    // MARK: - Public

    /// Returns the build configurations.
    ///
    /// - Returns: build configurations.
    /// - Throws: an error if the build configurations are not defined in the project
    /// to which the configuration list belongs.
    public func buildConfigurations() throws -> [XCBuildConfiguration] {
        return try buildConfigurationReferences.map({ try $0.object() })
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case buildConfigurations
        case defaultConfigurationName
        case defaultConfigurationIsVisible
    }

    public required init(from decoder: Decoder) throws {
        let objects = decoder.context.objects
        let objectReferenceRepository = decoder.context.objectReferenceRepository
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let buildConfigurationReferencesStrings: [String] = try container.decode(.buildConfigurations)
        buildConfigurationReferences = buildConfigurationReferencesStrings
            .map({ objectReferenceRepository.getOrCreate(reference: $0, objects: objects) })
        defaultConfigurationIsVisible = try container.decodeIntBool(.defaultConfigurationIsVisible)
        defaultConfigurationName = try container.decodeIfPresent(.defaultConfigurationName)
        try super.init(from: decoder)
    }
}

// MARK: - XCConfigurationList Utils

extension XCConfigurationList {
    /// Returns the build configuration with the given name (if it exists)
    ///
    /// - Parameter name: configuration name.
    /// - Returns: build configuration if it exists.
    public func configuration(name: String) throws -> XCBuildConfiguration? {
        return try buildConfigurations().first(where: { $0.name == name })
    }

    /// Adds the default configurations, debug and release
    ///
    /// - Returns: the created configurations.
    public func addDefaultConfigurations() throws -> [XCBuildConfiguration] {
        var configurations: [XCBuildConfiguration] = []
        try configurations.append(add(configuration: "Debug"))
        try configurations.append(add(configuration: "Release"))
        return configurations
    }

    /// Adds a build configuration with the given name.
    /// If a configuration with the given name exists, it returns that one.
    ///
    /// - Parameters:
    ///   - configuration: build configuration name.
    ///   - baseConfigurationReference: reference to the base configuration.
    ///   - buildSettings: dictionary that contains the build settings for this configuration.
    /// - Returns: build configuration.
    public func add(configuration: String,
                    baseConfigurationReference: PBXObjectReference? = nil,
                    buildSettings: BuildSettings = [:]) throws -> XCBuildConfiguration {
        let buildConfigurations = try self.buildConfigurations()
        let projectObjects = try objects()

        if let buildConfiguration = buildConfigurations.first(where: { $0.name == configuration }) {
            return buildConfiguration
        }

        let buildConfiguration = XCBuildConfiguration(name: configuration,
                                                      baseConfigurationReference: baseConfigurationReference,
                                                      buildSettings: buildSettings)
        let reference = projectObjects.addObject(buildConfiguration)
        buildConfigurationReferences.append(reference)

        return buildConfiguration
    }

    /// Returns the object with the given configuration list (project or target)
    ///
    /// - Parameter reference: configuration list reference.
    /// - Returns: target or project with the given configuration list.
    public func objectWithConfigurationList() throws -> PBXObject? {
        let projectObjects = try objects()
        return projectObjects.projects.first(where: { $0.value.buildConfigurationListReference == reference })?.value ??
            projectObjects.nativeTargets.first(where: { $0.value.buildConfigurationListReference == reference })?.value ??
            projectObjects.aggregateTargets.first(where: { $0.value.buildConfigurationListReference == reference })?.value ??
            projectObjects.legacyTargets.first(where: { $0.value.buildConfigurationListReference == reference })?.value
    }
}

// MARK: - XCConfigurationList Extension (PlistSerializable)

extension XCConfigurationList: PlistSerializable {
    func plistKeyAndValue(proj _: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(XCConfigurationList.isa))
        dictionary["buildConfigurations"] = .array(buildConfigurationReferences
            .map { configReference in
                let config: XCBuildConfiguration? = try? configReference.object()
                return .string(CommentedString(configReference.value, comment: config?.name))
        })
        dictionary["defaultConfigurationIsVisible"] = .string(CommentedString("\(defaultConfigurationIsVisible.int)"))
        if let defaultConfigurationName = defaultConfigurationName {
            dictionary["defaultConfigurationName"] = .string(CommentedString(defaultConfigurationName))
        }
        return (key: CommentedString(reference, comment: try plistComment()),
                value: .dictionary(dictionary))
    }

    private func plistComment() throws -> String? {
        let object = try objectWithConfigurationList()
        if let project = object as? PBXProject {
            return "Build configuration list for PBXProject \"\(project.name)\""
        } else if let target = object as? PBXTarget {
            return "Build configuration list for \(type(of: target).isa) \"\(target.name)\""
        }
        return nil
    }
}
