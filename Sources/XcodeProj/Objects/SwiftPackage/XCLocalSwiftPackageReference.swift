import Foundation

/// This element is an abstract parent for specialized targets.
public class XCLocalSwiftPackageReference: PBXContainerItem, PlistSerializable {
    /// Repository url.
    public var relativePath: String

    /// Initializes the local swift package reference with its attributes.
    ///
    /// - Parameters:
    ///   - repositoryPath: Package repository path.
    public init(relativePath: String) {
        self.relativePath = relativePath
        super.init()
    }

    enum CodingKeys: String, CodingKey {
        case relativePath
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        relativePath = try container.decode(String.self, forKey: .relativePath)

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
        return (key: CommentedString(reference, comment: "XCLocalSwiftPackageReference \"\(name ?? "")\""),
                value: .dictionary(dictionary))
    }

    override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? XCLocalSwiftPackageReference else { return false }
        return isEqual(to: rhs)
    }
}
