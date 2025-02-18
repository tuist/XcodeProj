import Foundation

public class PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet: PBXFileSystemSynchronizedExceptionSet, PlistSerializable {
    // MARK: - Attributes

    /// A list of relative paths to children subfolders for which exceptions are applied.
    public var membershipExceptions: [String]?

    /// Build phase that this exception set applies to.
    public var buildPhase: PBXBuildPhase! {
        get {
            buildPhaseReference.getObject() as? PBXBuildPhase
        }
        set {
            buildPhaseReference = newValue.reference
        }
    }

    /// Attributes by relative path.
    /// Every item in the list is the relative path inside the root synchronized group.
    /// For example `RemoveHeadersOnCopy` and  `CodeSignOnCopy`.
    public var attributesByRelativePath: [String: [String]]?

    var buildPhaseReference: PBXObjectReference

    // MARK: - Init

    public init(
        buildPhase: PBXBuildPhase,
        membershipExceptions: [String]?,
        attributesByRelativePath: [String: [String]]?
    ) {
        buildPhaseReference = buildPhase.reference
        self.membershipExceptions = membershipExceptions
        self.attributesByRelativePath = attributesByRelativePath
        super.init()
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case buildPhase
        case membershipExceptions
        case attributesByRelativePath
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let referenceRepository = decoder.context.objectReferenceRepository
        let objects = decoder.context.objects
        let buildPhaseReference: String = try container.decode(.buildPhase)
        self.buildPhaseReference = referenceRepository.getOrCreate(reference: buildPhaseReference, objects: objects)
        membershipExceptions = try container.decodeIfPresent(.membershipExceptions)
        attributesByRelativePath = try container.decodeIfPresent(.attributesByRelativePath)
        try super.init(from: decoder)
    }

    // MARK: - Equatable

    override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet else {
            return false
        }
        return isEqual(to: rhs)
    }

    // MARK: - PlistSerializable

    func plistKeyAndValue(proj _: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(type(of: self).isa))
        if let membershipExceptions {
            dictionary["membershipExceptions"] = .array(membershipExceptions.map { .string(CommentedString($0)) })
        }
        if let attributesByRelativePath {
            dictionary["attributesByRelativePath"] = .dictionary(Dictionary(uniqueKeysWithValues: attributesByRelativePath.map { key, value in
                (CommentedString(key), .array(value.map { .string(CommentedString($0)) }))
            }))
        }
        dictionary["buildPhase"] = .string(CommentedString(buildPhase.reference.value, comment: buildPhase.name() ?? "CopyFiles"))
        return (key: CommentedString(reference, comment: "PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet"), value: .dictionary(dictionary))
    }
}
