import Foundation

/// This is the element for a build target that produces a binary content (application or library).
public final class PBXNativeTarget: PBXTarget {
    // Target product install path.
    public var productInstallPath: String?

    public init(name: String,
                buildConfigurationList: String? = nil,
                buildPhases: [PBXObjectReference] = [],
                buildRules: [PBXObjectReference] = [],
                dependencies: [PBXObjectReference] = [],
                productInstallPath: String? = nil,
                productName: String? = nil,
                productReference: PBXObjectReference? = nil,
                productType: PBXProductType? = nil) {
        self.productInstallPath = productInstallPath
        super.init(name: name,
                   buildConfigurationList: buildConfigurationList,
                   buildPhases: buildPhases,
                   buildRules: buildRules,
                   dependencies: dependencies,
                   productName: productName,
                   productReference: productReference,
                   productType: productType)
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case productInstallPath
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        productInstallPath = try container.decodeIfPresent(.productInstallPath)
        try super.init(from: decoder)
    }

    override func plistValues(proj: PBXProj, isa: String, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        let (key, value) = try super.plistValues(proj: proj, isa: isa, reference: reference)
        guard case var PlistValue.dictionary(dict) = value else {
            fatalError("Expected super to give a dictionary")
        }
        if let productInstallPath = productInstallPath {
            dict["productInstallPath"] = .string(CommentedString(productInstallPath))
        }
        return (key: key, value: .dictionary(dict))
    }
}

// MARK: - PBXNativeTarget Extension (PlistSerializable)

extension PBXNativeTarget: PlistSerializable {
    func plistKeyAndValue(proj: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        return try plistValues(proj: proj, isa: PBXNativeTarget.isa, reference: reference)
    }
}
