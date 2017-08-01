import Foundation
import Unbox

// This is the element for listing build configurations.
public struct XCConfigurationList {
    
    // MARK: - Attributes
    
    /// Element reference.
    public var reference: String
    
    /// Element build configurations.
    public var buildConfigurations: Set<String>
    
    /// Element default configuration is visible.
    public var defaultConfigurationIsVisible: UInt
    
    /// Element default configuration name
    public var defaultConfigurationName: String
    
    // MARK: - Init
    
    /// Initializes the element with its properties.
    ///
    /// - Parameters:
    ///   - reference: element reference. Will be automatically generated if not specified
    ///   - buildConfigurations: element build configurations.
    ///   - defaultConfigurationName: element default configuration name.
    ///   - defaultConfigurationIsVisible: default configuration is visible.
    public init(reference: String? = nil,
                buildConfigurations: Set<String>,
                defaultConfigurationName: String,
                defaultConfigurationIsVisible: UInt = 0) {
        self.reference = reference ?? ReferenceGenerator.shared.generateReference(XCConfigurationList.self, buildConfigurations.joined())
        self.buildConfigurations = buildConfigurations
        self.defaultConfigurationName = defaultConfigurationName
        self.defaultConfigurationIsVisible = defaultConfigurationIsVisible
    }

}

// MARK: - XCConfigurationList Extension (PlistSerializable)

extension XCConfigurationList: PlistSerializable {
    
    public static var isa: String = "XCConfigurationList"
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(XCConfigurationList.isa))
        dictionary["buildConfigurations"] = .array(buildConfigurations
            .map { .string(CommentedString($0, comment: proj.objects.configName(from: $0)))
        })
        dictionary["defaultConfigurationIsVisible"] = .string(CommentedString("\(defaultConfigurationIsVisible)"))
        dictionary["defaultConfigurationName"] = .string(CommentedString(defaultConfigurationName))
        return (key: CommentedString(self.reference,
                                                 comment: plistComment(proj: proj)),
                value: .dictionary(dictionary))
    }
    
    private func plistComment(proj: PBXProj) -> String? {
        let project = proj.objects.projects.filter { $0.buildConfigurationList == self.reference }.first
        let target = proj.objects.nativeTargets.filter { $0.buildConfigurationList == self.reference }.first
        if project != nil {
            return "Build configuration list for PBXProject"
        } else if let target = target {
            return "Build configuration list for PBXNativeTarget \"\(target.name)\""
        }
        return nil
    }

}

// MARK: - XCConfigurationList Extension (ProjectElement)

extension XCConfigurationList: ProjectElement {
    
    public static func == (lhs: XCConfigurationList,
                           rhs: XCConfigurationList) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.buildConfigurations == rhs.buildConfigurations &&
            lhs.defaultConfigurationIsVisible == rhs.defaultConfigurationIsVisible
    }
    
    public var hashValue: Int { return self.reference.hashValue }
    
    public init(reference: String, dictionary: [String : Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.buildConfigurations = try unboxer.unbox(key: "buildConfigurations")
        self.defaultConfigurationIsVisible = try unboxer.unbox(key: "defaultConfigurationIsVisible")
        self.defaultConfigurationName = try unboxer.unbox(key: "defaultConfigurationName")
    }
    
}
