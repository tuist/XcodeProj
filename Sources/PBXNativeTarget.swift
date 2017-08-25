import Foundation
import Unbox

/// This is the element for a build target that produces a binary content (application or library).
public class PBXNativeTarget: PBXTarget {

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
                let comment: String? = proj.buildPhaseType(from: buildPhase)?.rawValue
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
