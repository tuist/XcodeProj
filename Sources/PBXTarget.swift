import Foundation
import Unbox

// This element is an abstract parent for specialized targets.
public class PBXTarget: PBXObject, Hashable {

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

    public init(reference: String,
                buildConfigurationList: String,
                buildPhases: [String],
                buildRules: [String],
                dependencies: [String],
                name: String,
                productName: String? = nil,
                productReference: String? = nil,
                productType: PBXProductType? = nil) {
        self.buildConfigurationList = buildConfigurationList
        self.buildPhases = buildPhases
        self.buildRules = buildRules
        self.dependencies = dependencies
        self.name = name
        self.productName = productName
        self.productReference = productReference
        self.productType = productType
        super.init(reference: reference)
    }

    public override init(reference: String, dictionary: [String: Any]) throws {
        let unboxer = Unboxer(dictionary: dictionary)
        self.buildConfigurationList = try unboxer.unbox(key: "buildConfigurationList")
        self.buildPhases = try unboxer.unbox(key: "buildPhases")
        self.buildRules = try unboxer.unbox(key: "buildRules")
        self.dependencies = try unboxer.unbox(key: "dependencies")
        self.name = try unboxer.unbox(key: "name")
        self.productName = unboxer.unbox(key: "productName")
        self.productReference = unboxer.unbox(key: "productReference")
        self.productType = unboxer.unbox(key: "productType")
        try super.init(reference: reference, dictionary: dictionary)
    }

    public static func == (lhs: PBXTarget,
                           rhs: PBXTarget) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.buildConfigurationList == rhs.buildConfigurationList &&
            lhs.buildPhases == rhs.buildPhases &&
            lhs.buildRules == rhs.buildRules &&
            lhs.dependencies == rhs.dependencies &&
            lhs.name == rhs.name &&
            lhs.productReference == rhs.productReference &&
            lhs.productType == rhs.productType
    }

    func plistValues(proj: PBXProj, isa: String) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(isa))
        let buildConfigurationListComment = "Build configuration list for \(isa) \"\(name)\""
        dictionary["buildConfigurationList"] = .string(CommentedString(buildConfigurationList, comment: buildConfigurationListComment))
        dictionary["buildPhases"] = .array(buildPhases
            .map { buildPhase in
                let comment = proj.buildPhaseName(buildPhaseReference: buildPhase)
                return .string(CommentedString(buildPhase, comment: comment))
        })
        dictionary["buildRules"] = .array(buildRules.map {.string(CommentedString($0))})
        dictionary["dependencies"] = .array(dependencies.map {.string(CommentedString($0, comment: PBXTargetDependency.isa))})
        dictionary["name"] = .string(CommentedString(name))
        if let productName = productName {
            dictionary["productName"] = .string(CommentedString(productName))
        }
        if let productType = productType {
            dictionary["productType"] = .string(CommentedString("\"\(productType.rawValue)\""))
        }
        if let productReference = productReference {
            let productReferenceComment = proj.fileName(buildFileReference: productReference)
            dictionary["productReference"] = .string(CommentedString(productReference, comment: productReferenceComment))
        }
        return (key: CommentedString(self.reference, comment: name),
                value: .dictionary(dictionary))
    }
    
}
