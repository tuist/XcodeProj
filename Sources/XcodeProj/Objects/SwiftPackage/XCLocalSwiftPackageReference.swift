import Foundation

/// This element is an abstract parent for specialized targets.
public class XCLocalSwiftPackageReference: PBXContainerItem, PlistSerializable {
    /// Repository url.
    public var relativePath: String

    /// Enabled package traits. Requires Xcode 26.4+.
    public var traits: [String]?

    /// Initializes the local swift package reference with its attributes.
    ///
    /// - Parameters:
    ///   - relativePath: Package relative path.
    ///   - traits: Enabled package traits.
    public init(relativePath: String,
                traits: [String]? = nil) {
        self.relativePath = relativePath
        self.traits = traits
        super.init()
    }

    enum CodingKeys: String, CodingKey {
        case relativePath
        case traits
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        relativePath = try container.decode(String.self, forKey: .relativePath)
        traits = try container.decodeIfPresent([String].self, forKey: .traits)

        try super.init(from: decoder)
    }

    /// It returns the name of the package reference.
    public var name: String? {
        relativePath
    }

    func plistKeyAndValue(proj: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary = try super.plistValues(proj: proj, reference: reference)
        dictionary["isa"] = .string(CommentedString(XCLocalSwiftPackageReference.isa))
        dictionary["relativePath"] = .string(.init(relativePath))
        if let traits {
            dictionary["traits"] = .array(traits.map { .string(.init($0)) })
        }
        return (key: CommentedString(reference, comment: "XCLocalSwiftPackageReference \"\(name ?? "")\""),
                value: .dictionary(dictionary))
    }

    override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? XCLocalSwiftPackageReference else { return false }
        return isEqual(to: rhs)
    }
}
