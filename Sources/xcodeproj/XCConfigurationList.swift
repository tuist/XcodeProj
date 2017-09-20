import Foundation
import Unbox

// This is the element for listing build configurations.
public class XCConfigurationList: PBXObject, Hashable {
    
    // MARK: - Attributes
    
    /// Element build configurations.
    public var buildConfigurations: [String]
    
    /// Element default configuration is visible.
    public var defaultConfigurationIsVisible: UInt
    
    /// Element default configuration name
    public var defaultConfigurationName: String
    
    // MARK: - Init
    
    /// Initializes the element with its properties.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - buildConfigurations: element build configurations.
    ///   - defaultConfigurationName: element default configuration name.
    ///   - defaultConfigurationIsVisible: default configuration is visible.
    public init(reference: String,
                buildConfigurations: [String],
                defaultConfigurationName: String,
                defaultConfigurationIsVisible: UInt = 0) {
        self.buildConfigurations = buildConfigurations
        self.defaultConfigurationName = defaultConfigurationName
        self.defaultConfigurationIsVisible = defaultConfigurationIsVisible
        super.init(reference: reference)
    }

    public static func == (lhs: XCConfigurationList,
                           rhs: XCConfigurationList) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.buildConfigurations == rhs.buildConfigurations &&
            lhs.defaultConfigurationIsVisible == rhs.defaultConfigurationIsVisible
    }

    public override init(reference: String, dictionary: [String: Any]) throws {
        let unboxer = Unboxer(dictionary: dictionary)
        self.buildConfigurations = try unboxer.unbox(key: "buildConfigurations")
        self.defaultConfigurationIsVisible = try unboxer.unbox(key: "defaultConfigurationIsVisible")
        self.defaultConfigurationName = try unboxer.unbox(key: "defaultConfigurationName")
        try super.init(reference: reference, dictionary: dictionary)
    }

}

// MARK: - XCConfigurationList Extension (PlistSerializable)

extension XCConfigurationList: PlistSerializable {
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(XCConfigurationList.isa))
        dictionary["buildConfigurations"] = .array(buildConfigurations
            .map { .string(CommentedString($0, comment: proj.configName(from: $0)))
        })
        dictionary["defaultConfigurationIsVisible"] = .string(CommentedString("\(defaultConfigurationIsVisible)"))
        dictionary["defaultConfigurationName"] = .string(CommentedString(defaultConfigurationName))
        return (key: CommentedString(self.reference,
                                                 comment: plistComment(proj: proj)),
                value: .dictionary(dictionary))
    }
    
    private func plistComment(proj: PBXProj) -> String? {
        let project = proj.projects.filter { $0.buildConfigurationList == self.reference }.first
        let target = proj.nativeTargets.filter { $0.buildConfigurationList == self.reference }.first
        if project != nil {
            return "Build configuration list for PBXProject"
        } else if let target = target {
            return "Build configuration list for PBXNativeTarget \"\(target.name)\""
        }
        return nil
    }

}
