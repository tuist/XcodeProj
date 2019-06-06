import Foundation

/// This element is an abstract parent for specialized targets.
public class XCSwiftPackageProductDependency: PBXContainerItem {
    /// Product name.
    public var productName: String

    /// Package reference.
    var packageReference: PBXObjectReference?

    /// Package the product dependency refers to.
    var package: XCRemoteSwiftPackageReference? {
        get {
            return packageReference?.getObject()
        }
        set {
            packageReference = newValue?.reference
        }
    }

    // MARK: - Init

    init(productName: String,
         package: XCRemoteSwiftPackageReference? = nil) {
        self.productName = productName
        packageReference = package?.reference
        super.init()
    }

    public required init(from decoder: Decoder) throws {
        let objects = decoder.context.objects
        let repository = decoder.context.objectReferenceRepository
        let container = try decoder.container(keyedBy: CodingKeys.self)
        productName = try container.decode(String.self, forKey: .productName)
        if let packageString: String = try container.decodeIfPresent(.package) {
            packageReference = repository.getOrCreate(reference: packageString, objects: objects)
        } else {
            packageReference = nil
        }
        try super.init(from: decoder)
    }

    override func plistValues(proj: PBXProj, reference: String) throws -> [CommentedString: PlistValue] {
        var dictionary = try super.plistValues(proj: proj, reference: reference)
        if let package = package {
            dictionary["package"] = .string(.init(package.reference.value, comment: "XCRemoteSwiftPackageReference \"\(package.name ?? "")\""))
        }
        dictionary["productName"] = .string(.init(productName))
        return dictionary
    }

    // MARK: - Codable

    fileprivate enum CodingKeys: String, CodingKey {
        case productName
        case package
    }

    // MARK: - Equatable

    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? XCSwiftPackageProductDependency else { return false }
        if packageReference != rhs.packageReference { return false }
        if productName != rhs.productName { return false }
        return super.isEqual(to: rhs)
    }
}
