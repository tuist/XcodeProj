import Foundation

/// This is the element for listing build configurations.
final public class XCConfigurationList: PBXObject, Equatable {
    
    // MARK: - Attributes
    
    /// Element build configurations.
    public var buildConfigurations: [String]
    
    /// Element default configuration is visible.
    public var defaultConfigurationIsVisible: UInt
    
    /// Element default configuration name
    public var defaultConfigurationName: String?
    
    // MARK: - Init
    
    /// Initializes the element with its properties.
    ///
    /// - Parameters:
    ///   - buildConfigurations: element build configurations.
    ///   - defaultConfigurationName: element default configuration name.
    ///   - defaultConfigurationIsVisible: default configuration is visible.
    public init(buildConfigurations: [String],
                defaultConfigurationName: String? = nil,
                defaultConfigurationIsVisible: UInt = 0) {
        self.buildConfigurations = buildConfigurations
        self.defaultConfigurationName = defaultConfigurationName
        self.defaultConfigurationIsVisible = defaultConfigurationIsVisible
        super.init()
    }

    public static func == (lhs: XCConfigurationList,
                           rhs: XCConfigurationList) -> Bool {
        return lhs.buildConfigurations == rhs.buildConfigurations &&
            lhs.defaultConfigurationIsVisible == rhs.defaultConfigurationIsVisible
    }

    // MARK: - Decodable
        
    fileprivate enum CodingKeys: String, CodingKey {
        case buildConfigurations
        case defaultConfigurationName
        case defaultConfigurationIsVisible
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.buildConfigurations = try container.decode(.buildConfigurations)
        let defaultConfigurationIsVisibleString: String? = try container.decodeIfPresent(.defaultConfigurationIsVisible)
        self.defaultConfigurationIsVisible = defaultConfigurationIsVisibleString.flatMap(UInt.init) ?? 0
        self.defaultConfigurationName = try container.decodeIfPresent(.defaultConfigurationName)
        try super.init(from: decoder)
    }
    
}

// MARK: - XCConfigurationList Extension (PlistSerializable)

extension XCConfigurationList: PlistSerializable {
    
    func plistKeyAndValue(proj: PBXProj, reference: String) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(XCConfigurationList.isa))
        dictionary["buildConfigurations"] = .array(buildConfigurations
            .map { .string(CommentedString($0, comment: proj.objects.configName(configReference: $0)))
        })
        dictionary["defaultConfigurationIsVisible"] = .string(CommentedString("\(defaultConfigurationIsVisible)"))
        if let defaultConfigurationName = defaultConfigurationName {
            dictionary["defaultConfigurationName"] = .string(CommentedString(defaultConfigurationName))
        }
        return (key: CommentedString(reference,comment: plistComment(proj: proj, reference: reference)),
                value: .dictionary(dictionary))
    }
    
    private func plistComment(proj: PBXProj, reference: String) -> String? {
        let object = proj.objects.objectWithConfigurationList(reference: reference)
        if let project = object as? PBXProject {
            return "Build configuration list for PBXProject \"\(project.name)\""
        } else if let target = object as? PBXNativeTarget {
            return "Build configuration list for PBXNativeTarget \"\(target.name)\""
        }
        return nil
    }

}
