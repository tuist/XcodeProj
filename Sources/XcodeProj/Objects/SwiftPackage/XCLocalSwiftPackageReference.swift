import Foundation

/// This element is an abstract parent for specialized targets.
public class XCLocalSwiftPackageReference: PBXContainerItem, PlistSerializable {
    /// Repository url.
    public var repositoryPath: String?

    /// Initializes the local swift package reference with its attributes.
    ///
    /// - Parameters:
    ///   - repositoryPath: Package repository path.
    public init(repositoryPath: String) {
        self.repositoryPath = repositoryPath
        super.init()
    }

    enum CodingKeys: String, CodingKey {
        case repositoryPath
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        repositoryPath = try container.decodeIfPresent(String.self, forKey: .repositoryPath)

        try super.init(from: decoder)
    }

    /// It returns the name of the package reference.
    public var name: String? {
        repositoryPath?.split(separator: "/").last.map(String.init)
    }

    func plistKeyAndValue(proj: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary = try super.plistValues(proj: proj, reference: reference)
        dictionary["isa"] = .string(CommentedString(XCLocalSwiftPackageReference.isa))
        if let repositoryPath = repositoryPath {
            dictionary["repositoryPath"] = .string(.init(repositoryPath))
        }
        return (key: CommentedString(reference, comment: "XCLocalSwiftPackageReference \"\(name ?? "")\""),
                value: .dictionary(dictionary))
    }

    override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? XCLocalSwiftPackageReference else { return false }
        return isEqual(to: rhs)
    }
}
