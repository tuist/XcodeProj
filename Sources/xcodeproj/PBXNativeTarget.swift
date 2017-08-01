import Foundation
import Unbox

/// This is the element for a build target that produces a binary content (application or library).
public struct PBXNativeTarget: PBXTarget {
    
    /// Element reference.
    public var reference: String

    /// Target build configuration list.
    public var buildConfigurationList: String
    
    /// Target build phases.
    public var buildPhases: [String]
    
    /// Target build rules.
    public var buildRules: [String]
    
    /// Target dependencies.
    public var dependencies: [String]
    
    /// Target name.
    public var name: String
    
    /// Target product name.
    public var productName: String?
    
    /// Target product reference.
    public var productReference: String?
    
    /// Target product type.
    public var productType: PBXProductType?
    
    // MARK: - Init
    
    /// Initializes the native target with its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference. Will be automatically generated if not specified
    ///   - buildConfigurationList: target build configuration list.
    ///   - buildPhases: target build phases.
    ///   - buildRules: target build rules.
    ///   - dependencies: target dependencies.
    ///   - name: target name.
    ///   - productName: target product name.
    ///   - productReference: target product reference.
    ///   - productType: target product type.
    public init(reference: String? = nil,
                buildConfigurationList: String,
                buildPhases: [String],
                buildRules: [String],
                dependencies: [String],
                name: String,
                productName: String? = nil,
                productReference: String? = nil,
                productType: PBXProductType? = nil) {
        self.reference = reference ?? ReferenceGenerator.shared.generateReference(PBXNativeTarget.self, name + String(describing: productType))
        self.buildConfigurationList = buildConfigurationList
        self.buildPhases = buildPhases
        self.buildRules = buildRules
        self.dependencies = dependencies
        self.name = name
        self.productName = productName
        self.productReference = productReference
        self.productType = productType
    }
    
}

// MARK: - PBXNativeTarget Extension (ProjectElement)

extension PBXNativeTarget: ProjectElement {
    
    public static var isa: String = "PBXNativeTarget"
    
    public static func == (lhs: PBXNativeTarget,
                           rhs: PBXNativeTarget) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.buildConfigurationList == rhs.buildConfigurationList &&
            lhs.buildPhases == rhs.buildPhases &&
            lhs.buildRules == rhs.buildRules &&
            lhs.dependencies == rhs.dependencies &&
            lhs.name == rhs.name &&
            lhs.productName == rhs.productName &&
            lhs.productReference == rhs.productReference &&
            lhs.productType == rhs.productType
    }
    
    public var hashValue: Int { return self.reference.hashValue }
    
    public init(reference: String, dictionary: [String : Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.buildConfigurationList = try unboxer.unbox(key: "buildConfigurationList")
        self.buildPhases = try unboxer.unbox(key: "buildPhases")
        self.buildRules = try unboxer.unbox(key: "buildRules")
        self.dependencies = try unboxer.unbox(key: "dependencies")
        self.name = try unboxer.unbox(key: "name")
        self.productName = unboxer.unbox(key: "productName")
        self.productReference = unboxer.unbox(key: "productReference")
        self.productType = unboxer.unbox(key: "productType")
    }
}

// MARK: - PBXNativeTarget Extension (PlistSerializable)

extension PBXNativeTarget: PlistSerializable {
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        
        dictionary["isa"] = .string(CommentedString(PBXNativeTarget.isa))
        let buildConfigurationListComment = "Build configuration list for PBXNativeTarget \"\(name)\""
        dictionary["buildConfigurationList"] = .string(CommentedString(buildConfigurationList,
                                                                                   comment: buildConfigurationListComment))
        dictionary["buildPhases"] = .array(buildPhases
            .map { buildPhase in
                let comment: String? = proj.buildPhaseType(from: buildPhase)
                return .string(CommentedString(buildPhase, comment: comment))
        })
        dictionary["buildRules"] = .array(buildRules.map {.string(CommentedString($0))})
        dictionary["dependencies"] = .array(dependencies.map {.string(CommentedString($0,
                                                                                                  comment: "PBXTargetDependency"))})
        dictionary["name"] = .string(CommentedString(name))
        if let productName = productName {
            dictionary["productName"] = .string(CommentedString(productName))
        }
        if let productType = productType {
            dictionary["productType"] = .string(CommentedString("\"\(productType.rawValue)\""))
        }
        if let productReference = productReference {
            let productReferenceComment = proj.buildFileName(reference: productReference)
            dictionary["productReference"] = .string(CommentedString(productReference,
                                                                                 comment: productReferenceComment))
        }
        return (key: CommentedString(self.reference, comment: name),
                value: .dictionary(dictionary))
    }
    
}
