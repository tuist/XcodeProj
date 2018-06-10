import Foundation

/// This is the element for a build target that according to Xcode is an "External Build System". You can use this target to run a script.
public final class PBXLegacyTarget: PBXTarget {
    /// Path to the build tool that is invoked (required)
    public var buildToolPath: String?

    /// Build arguments to be passed to the build tool.
    public var buildArgumentsString: String?

    /// Whether or not to pass Xcode build settings as environment variables down to the tool when invoked
    public var passBuildSettingsInEnvironment: Bool

    /// The directory where the build tool will be invoked during a build
    public var buildWorkingDirectory: String?

    public init(name: String,
                buildToolPath: String? = nil,
                buildArgumentsString: String? = nil,
                passBuildSettingsInEnvironment: Bool = false,
                buildWorkingDirectory: String? = nil,
                buildConfigurationListRef: PBXObjectReference? = nil,
                buildPhases: [PBXObjectReference] = [],
                buildRules: [PBXObjectReference] = [],
                dependencies: [PBXObjectReference] = [],
                productName: String? = nil,
                productReference: PBXObjectReference? = nil,
                productType: PBXProductType? = nil) {
        self.buildToolPath = buildToolPath
        self.buildArgumentsString = buildArgumentsString
        self.passBuildSettingsInEnvironment = passBuildSettingsInEnvironment
        self.buildWorkingDirectory = buildWorkingDirectory
        super.init(name: name,
                   buildConfigurationListRef: buildConfigurationListRef,
                   buildPhases: buildPhases,
                   buildRules: buildRules,
                   dependencies: dependencies,
                   productName: productName,
                   productReference: productReference,
                   productType: productType)
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case buildToolPath
        case buildArgumentsString
        case passBuildSettingsInEnvironment
        case buildWorkingDirectory
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        buildToolPath = try container.decodeIfPresent(.buildToolPath)
        buildArgumentsString = try container.decodeIfPresent(.buildArgumentsString)
        passBuildSettingsInEnvironment = try container.decodeIntBool(.passBuildSettingsInEnvironment)
        buildWorkingDirectory = try container.decodeIfPresent(.buildWorkingDirectory)
        try super.init(from: decoder)
    }

    override func plistValues(proj: PBXProj, isa _: String, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        let (key, value) = try super.plistValues(proj: proj, isa: PBXLegacyTarget.isa, reference: reference)
        var dict: [CommentedString: PlistValue]!
        switch value {
        case let .dictionary(dictValue):
            dict = dictValue
            if let buildToolPath = buildToolPath {
                dict["buildToolPath"] = PlistValue.string(CommentedString(buildToolPath))
            }
            if let buildArgumentsString = buildArgumentsString {
                dict["buildArgumentsString"] =
                    PlistValue.string(CommentedString(buildArgumentsString))
            }
            dict["passBuildSettingsInEnvironment"] =
                PlistValue.string(CommentedString(passBuildSettingsInEnvironment.int.description))
            if let buildWorkingDirectory = buildWorkingDirectory {
                dict["buildWorkingDirectory"] =
                    PlistValue.string(CommentedString(buildWorkingDirectory))
            }
        default:
            throw XcodeprojWritingError.invalidType(class: String(describing: type(of: self)), expected: "Dictionary")
        }
        return (key: key, value: .dictionary(dict))
    }
}

// MARK: - PBXNativeTarget Extension (PlistSerializable)

extension PBXLegacyTarget: PlistSerializable {
    func plistKeyAndValue(proj: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        return try plistValues(proj: proj, isa: PBXLegacyTarget.isa, reference: reference)
    }
}
