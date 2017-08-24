import Foundation
import Unbox

// This is the element for a build target that aggregates several others.
public class PBXAggregateTarget: PBXTarget {

}

// MARK: - PBXAggregateTarget Extension (PlistSerializable)

extension PBXAggregateTarget: PlistSerializable {
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXAggregateTarget.isa))
        let buildConfigurationListComment = "Build configuration list for PBXAggregateTarget \"\(name)\""
        dictionary["buildConfigurationList"] = .string(CommentedString(PBXNativeTarget.isa,
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
