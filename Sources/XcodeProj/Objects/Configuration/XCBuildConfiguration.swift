import Foundation

/// This is the element for listing build configurations.
public final class XCBuildConfiguration: PBXObject {
    // MARK: - Attributes

    /// Base xcconfig file reference if the file belongs to a ``PBXGroup``.
    var baseConfigurationReference: PBXObjectReference?

    /// Base xcconfig file reference if the file belongs to a ``PBXGroup``.
    public var baseConfiguration: PBXFileReference? {
        get {
            baseConfigurationReference?.getObject()
        }
        set {
            if let newValue {
                baseConfigurationReference = newValue.reference
            }
        }
    }

    /// Reference to a ``PBXFileSystemSynchronizedRootGroup`` containing the base xcconfig file.
    var baseConfigurationReferenceAnchor: PBXObjectReference?

    /// Base xcconfig file path relative to the `baseConfigurationAnchor`.
    public var baseConfigurationReferenceRelativePath: String?

    /// ``PBXFileSystemSynchronizedRootGroup`` containing the base xcconfig file.
    public var baseConfigurationAnchor: PBXFileSystemSynchronizedRootGroup? {
        get {
            baseConfigurationReferenceAnchor?.getObject()
        }
        set {
            if let newValue {
                baseConfigurationReferenceAnchor = newValue.reference
            }
        }
    }

    /// A map of build settings.
    public var buildSettings: BuildSettings

    /// The configuration name.
    public var name: String

    // MARK: - Init

    /// Initializes a build configuration.
    ///
    /// - Parameters:
    ///   - name: build configuration name.
    ///   - baseConfiguration: base configuration reference belonging to a group.
    ///   - baseConfigurationAnchor: the leaf file system synchronized group that contains the base xcconfig file as a descendant.
    ///   - baseConfigurationRelativePath: relative path from `baseConfigurationAnchor` to the base xcconfig file.
    ///   - buildSettings: dictionary that contains the build settings for this configuration.
    ///
    /// - Important:
    ///     The `baseConfiguration` parameter should be used if the configuration file belongs to a``PBXGroup``.
    ///     If the configuration file belongs to a ``PBXFileSystemSynchronizedRootGroup``, use the `baseConfigurationAnchor`
    ///     and `baseConfigurationRelativePath` parameters to address the file instead.
    public init(name: String,
                baseConfiguration: PBXFileReference? = nil,
                baseConfigurationAnchor: PBXFileSystemSynchronizedRootGroup? = nil,
                baseConfigurationRelativePath: String? = nil,
                buildSettings: BuildSettings = [:]) {
        baseConfigurationReference = baseConfiguration?.reference
        baseConfigurationReferenceAnchor = baseConfigurationAnchor?.reference
        baseConfigurationReferenceRelativePath = baseConfigurationRelativePath
        self.buildSettings = buildSettings
        self.name = name
        super.init()
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case baseConfigurationReference
        case baseConfigurationReferenceAnchor
        case baseConfigurationReferenceRelativePath
        case buildSettings
        case name
    }

    public required init(from decoder: Decoder) throws {
        let objects = decoder.context.objects
        let objectReferenceRepository = decoder.context.objectReferenceRepository
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // configuration files may be reference by either a pair of PBXFileSystemSynchronizedRootGroup and relative path (Xcode 16)
        // or a PBXFileReference if the file belongs to a PBXGroup
        if let baseConfigurationReferenceAnchor: String = try container.decodeIfPresent(.baseConfigurationReferenceAnchor),
           let baseConfigurationReferenceRelativePath: String = try container.decodeIfPresent(.baseConfigurationReferenceRelativePath)
        {
            self.baseConfigurationReferenceAnchor = objectReferenceRepository.getOrCreate(reference: baseConfigurationReferenceAnchor, objects: objects)
            self.baseConfigurationReferenceRelativePath = baseConfigurationReferenceRelativePath
        } else if let baseConfigurationReference: String = try container.decodeIfPresent(.baseConfigurationReference) {
            self.baseConfigurationReference = objectReferenceRepository.getOrCreate(reference: baseConfigurationReference, objects: objects)
        }
        buildSettings = try container.decode(BuildSettings.self, forKey: .buildSettings)
        name = try container.decode(.name)
        try super.init(from: decoder)
    }

    // MARK: - Public

    /// Appends a value to the given setting.
    /// If the setting doesn't exist, it initializes it with the $(inherited) value and appends the given value to it.
    ///
    /// - Parameters:
    ///   - name: Setting to which the value will be appended.
    ///   - value: Value to be appended.
    public func append(setting name: String, value: String) {
        guard !value.isEmpty else { return }

        let existing: BuildSetting = buildSettings[name] ?? "$(inherited)"

        switch existing {
        case let .string(string) where string != value:
            let newValue = [string, value].joined(separator: " ")
            buildSettings[name] = .string(newValue)
        case let .array(array):
            var newValue = array
            newValue.append(value)
            buildSettings[name] = .array(newValue.uniqued())
        default:
            break
        }
    }

    override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? XCBuildConfiguration else { return false }
        return isEqual(to: rhs)
    }
}

// MARK: - PlistSerializable

extension XCBuildConfiguration: PlistSerializable {
    func plistKeyAndValue(proj _: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(XCBuildConfiguration.isa))
        dictionary["name"] = .string(CommentedString(name))
        dictionary["buildSettings"] = buildSettings.plist()
        if let baseConfigurationReferenceAnchor,
           let baseConfigurationReferenceRelativePath
        {
            let synchronizedGroup: PBXFileSystemSynchronizedRootGroup? = baseConfigurationReferenceAnchor.getObject()
            dictionary["baseConfigurationReferenceAnchor"] = .string(CommentedString(baseConfigurationReferenceAnchor.value, comment: synchronizedGroup?.path))
            dictionary["baseConfigurationReferenceRelativePath"] = .string(CommentedString(baseConfigurationReferenceRelativePath))
        } else if let baseConfigurationReference {
            let fileElement: PBXFileElement? = baseConfigurationReference.getObject()
            dictionary["baseConfigurationReference"] = .string(CommentedString(baseConfigurationReference.value, comment: fileElement?.fileName()))
        }
        return (key: CommentedString(reference, comment: name), value: .dictionary(dictionary))
    }
}
