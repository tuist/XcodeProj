import Foundation

/// This element is an abstract parent for specialized targets.
public class XCRemoteSwiftPackageReference: PBXContainerItem {
    
    /// Repository url.
    var repositoryURL: String
    

    public init(repositoryURL: String) {
        self.repositoryURL = repositoryURL
        super.init()
    }
    
    var name: String {
        return "TODO"
    }
    
    // MARK: - Decodable
    
//    fileprivate enum CodingKeys: String, CodingKey {

//    }
    
    public required init(from decoder: Decoder) throws {
//        let objectReferenceRepository = decoder.context.objectReferenceRepository
//        let objects = decoder.context.objects
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        name = try container.decode(.name)
//        if let buildConfigurationListReference: String = try container.decodeIfPresent(.buildConfigurationList) {
//            self.buildConfigurationListReference = objectReferenceRepository.getOrCreate(reference: buildConfigurationListReference, objects: objects)
//        } else {
//            buildConfigurationListReference = nil
//        }
//        let buildPhaseReferences: [String] = try container.decodeIfPresent(.buildPhases) ?? []
//        self.buildPhaseReferences = buildPhaseReferences.map { objectReferenceRepository.getOrCreate(reference: $0, objects: objects) }
//        let buildRuleReferences: [String] = try container.decodeIfPresent(.buildRules) ?? []
//        self.buildRuleReferences = buildRuleReferences.map { objectReferenceRepository.getOrCreate(reference: $0, objects: objects) }
//        let dependencyReferences: [String] = try container.decodeIfPresent(.dependencies) ?? []
//        self.dependencyReferences = dependencyReferences.map { objectReferenceRepository.getOrCreate(reference: $0, objects: objects) }
//        productName = try container.decodeIfPresent(.productName)
//        if let productReferenceString: String = try container.decodeIfPresent(.productReference) {
//            productReference = objectReferenceRepository.getOrCreate(reference: productReferenceString, objects: objects)
//        } else {
//            productReference = nil
//        }
//        productType = try container.decodeIfPresent(.productType)
        try super.init(from: decoder)
    }
    
    func plistValues(proj: PBXProj, isa: String, reference: String) throws -> (key: CommentedString, value: PlistValue) {
//        var dictionary = try super.plistValues(proj: proj, reference: reference)
//        dictionary["isa"] = .string(CommentedString(isa))
//        let buildConfigurationListComment = "Build configuration list for \(isa) \"\(name)\""
//        if let buildConfigurationListReference = buildConfigurationListReference {
//            dictionary["buildConfigurationList"] = .string(CommentedString(buildConfigurationListReference.value,
//                                                                           comment: buildConfigurationListComment))
//        }
//        dictionary["buildPhases"] = .array(buildPhaseReferences
//            .map { (buildPhaseReference: PBXObjectReference) in
//                let buildPhase: PBXBuildPhase? = buildPhaseReference.getObject()
//                return .string(CommentedString(buildPhaseReference.value, comment: buildPhase?.name()))
//        })
//
//        // Xcode doesn't write PBXAggregateTarget buildRules or empty PBXLegacyTarget buildRules
//        if !(self is PBXAggregateTarget), !(self is PBXLegacyTarget) || !buildRuleReferences.isEmpty {
//            dictionary["buildRules"] = .array(buildRuleReferences.map { .string(CommentedString($0.value, comment: PBXBuildRule.isa)) })
//        }
//
//        dictionary["dependencies"] = .array(dependencyReferences.map { .string(CommentedString($0.value, comment: PBXTargetDependency.isa)) })
//        dictionary["name"] = .string(CommentedString(name))
//        if let productName = productName {
//            dictionary["productName"] = .string(CommentedString(productName))
//        }
//        if let productType = productType {
//            dictionary["productType"] = .string(CommentedString(productType.rawValue))
//        }
//        if let productReference = productReference {
//            let fileElement: PBXFileElement? = productReference.getObject()
//            dictionary["productReference"] = .string(CommentedString(productReference.value, comment: fileElement?.fileName()))
//        }
//        return (key: CommentedString(reference, comment: name),
//                value: .dictionary(dictionary))
    }
}
