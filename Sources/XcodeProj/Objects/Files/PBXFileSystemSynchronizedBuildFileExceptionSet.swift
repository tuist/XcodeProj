import Foundation

/// Class representing an element that may contain other elements.
public class PBXFileSystemSynchronizedBuildFileExceptionSet: PBXObject, PlistSerializable {
    // MARK: - Attributes

    /// A list of relative paths to children subfolders for which exceptions are applied.
    public var membershipExceptions: [String]?

    /// Changes the default header visibility (project) to public for the following headers.
    /// Every item in the list is the relative path inside the root synchronized group.
    public var publicHeaders: [String]?

    /// Changes the default header visibility (project) to private for the following headers.
    /// Every item in the list is the relative path inside the root synchronized group.
    public var privateHeaders: [String]?

    /// Additional compiler flags by relative path.
    /// Every item in the list is the relative path inside the root synchronized group.
    /// The value is the additional compiler flags.
    public var additionalCompilerFlagsByRelativePath: [String: String]?

    /// Attributes by relative path.
    /// Every item in the list is the relative path inside the root synchronized group.
    /// This is used for example when linking frameworks to specify that they are optional with the attribute "Weak"
    public var attributesByRelativePath: [String: [String]]?

    var targetReference: PBXObjectReference

    public var target: PBXTarget! {
        get {
            targetReference.getObject() as? PBXTarget
        }
        set {
            targetReference = newValue.reference
        }
    }

    // MARK: - Init

    public init(target: PBXTarget, membershipExceptions: [String]?, publicHeaders: [String]?, privateHeaders: [String]?, additionalCompilerFlagsByRelativePath: [String: String]?, attributesByRelativePath: [String: [String]]?) {
        targetReference = target.reference
        self.membershipExceptions = membershipExceptions
        self.publicHeaders = publicHeaders
        self.privateHeaders = privateHeaders
        self.additionalCompilerFlagsByRelativePath = additionalCompilerFlagsByRelativePath
        self.attributesByRelativePath = attributesByRelativePath
        super.init()
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case target
        case membershipExceptions
        case publicHeaders
        case privateHeaders
        case additionalCompilerFlagsByRelativePath
        case attributesByRelativePath
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let referenceRepository = decoder.context.objectReferenceRepository
        let objects = decoder.context.objects
        let targetReference: String = try container.decode(.target)
        self.targetReference = referenceRepository.getOrCreate(reference: targetReference, objects: objects)
        membershipExceptions = try container.decodeIfPresent(.membershipExceptions)
        publicHeaders = try container.decodeIfPresent(.publicHeaders)
        privateHeaders = try container.decodeIfPresent(.privateHeaders)
        additionalCompilerFlagsByRelativePath = try container.decodeIfPresent(.additionalCompilerFlagsByRelativePath)
        attributesByRelativePath = try container.decodeIfPresent(.attributesByRelativePath)
        try super.init(from: decoder)
    }

    // MARK: - Equatable

    override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXFileSystemSynchronizedBuildFileExceptionSet else { return false }
        return isEqual(to: rhs)
    }

    // MARK: - PlistSerializable

    func plistKeyAndValue(proj _: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXFileSystemSynchronizedBuildFileExceptionSet.isa))
        if let membershipExceptions {
            dictionary["membershipExceptions"] = .array(membershipExceptions.map { .string(CommentedString($0)) })
        }
        if let publicHeaders {
            dictionary["publicHeaders"] = .array(publicHeaders.map { .string(CommentedString($0)) })
        }
        if let privateHeaders {
            dictionary["privateHeaders"] = .array(privateHeaders.map { .string(CommentedString($0)) })
        }
        if let additionalCompilerFlagsByRelativePath {
            dictionary["additionalCompilerFlagsByRelativePath"] = .dictionary(Dictionary(uniqueKeysWithValues: additionalCompilerFlagsByRelativePath.map { key, value in
                (CommentedString(key), PlistValue.string(CommentedString(value)))
            }))
        }
        if let attributesByRelativePath {
            dictionary["attributesByRelativePath"] = .dictionary(Dictionary(uniqueKeysWithValues: attributesByRelativePath.map { key, value in
                (CommentedString(key), .array(value.map { .string(CommentedString($0)) }))
            }))
        }
        dictionary["target"] = .string(CommentedString(target.reference.value, comment: target.name))
        return (key: CommentedString(reference, comment: "PBXFileSystemSynchronizedBuildFileExceptionSet"), value: .dictionary(dictionary))
    }
}
