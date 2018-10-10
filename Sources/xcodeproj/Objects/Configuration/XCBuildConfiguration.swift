import Foundation

/// This is the element for listing build configurations.
public final class XCBuildConfiguration: PBXObject {
    // MARK: - Attributes

    /// Base xcconfig file reference.
    var baseConfigurationReference: PBXObjectReference?

    /// Base xcconfig file reference.
    public var baseConfiguration: PBXFileReference? {
        get {
            return baseConfigurationReference?.getObject()
        }
        set {
            if let newValue = newValue {
                baseConfigurationReference = newValue.reference
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
    ///   - baseConfiguration: base configuration.
    ///   - buildSettings: dictionary that contains the build settings for this configuration.
    public init(name: String,
                baseConfiguration: PBXFileReference? = nil,
                buildSettings: BuildSettings = [:]) {
        baseConfigurationReference = baseConfiguration?.reference
        self.buildSettings = buildSettings
        self.name = name
        super.init()
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case baseConfigurationReference
        case buildSettings
        case name
    }

    public required init(from decoder: Decoder) throws {
        let objects = decoder.context.objects
        let objectReferenceRepository = decoder.context.objectReferenceRepository
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let baseConfigurationReference: String = try container.decodeIfPresent(.baseConfigurationReference) {
            self.baseConfigurationReference = objectReferenceRepository.getOrCreate(reference: baseConfigurationReference, objects: objects)
        } else {
            baseConfigurationReference = nil
        }
        buildSettings = try container.decode([String: Any].self, forKey: .buildSettings)
        name = try container.decode(.name)
        try super.init(from: decoder)
    }
}

// MARK: - PlistSerializable

extension XCBuildConfiguration: PlistSerializable {
    func plistKeyAndValue(proj _: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(XCBuildConfiguration.isa))
        dictionary["name"] = .string(CommentedString(name))
        dictionary["buildSettings"] = buildSettings.plist()
        if let baseConfigurationReference = baseConfigurationReference {
            let fileElement: PBXFileElement? = baseConfigurationReference.getObject()
            dictionary["baseConfigurationReference"] = .string(CommentedString(baseConfigurationReference.value, comment: fileElement?.fileName()))
        }
        return (key: CommentedString(reference, comment: name), value: .dictionary(dictionary))
    }
}
