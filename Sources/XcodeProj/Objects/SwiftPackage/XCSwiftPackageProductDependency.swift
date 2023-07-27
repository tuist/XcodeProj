import Foundation

/// This element is an abstract parent for specialized targets.
public class XCSwiftPackageProductDependency: PBXContainerItem, PlistSerializable {
    /// Product name.
    public var productName: String

    /// Package reference.
    var packageReference: PBXObjectReference?

    /// Package the product dependency refers to.
    public var package: XCRemoteSwiftPackageReference? {
        get {
            packageReference?.getObject()
        }
        set {
            packageReference = newValue?.reference
        }
    }

    /// Is it a Plugin.
    var isPlugin: Bool

    // MARK: - Init

    public init(productName: String,
                package: XCRemoteSwiftPackageReference? = nil,
                isPlugin: Bool = false) {
        self.productName = productName
        packageReference = package?.reference
        self.isPlugin = isPlugin
        super.init()
    }

    public required init(from decoder: Decoder) throws {
        let objects = decoder.context.objects
        let repository = decoder.context.objectReferenceRepository
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawProductName = try container.decode(String.self, forKey: .productName)
        let pluginPrefix = "plugin:"
        if rawProductName.hasPrefix(pluginPrefix) {
            productName = String(rawProductName.dropFirst(pluginPrefix.count))
            isPlugin = true
        } else {
            productName = rawProductName
            isPlugin = false
        }

        if let packageString: String = try container.decodeIfPresent(.package) {
            packageReference = repository.getOrCreate(reference: packageString, objects: objects)
        } else {
            packageReference = nil
        }
        try super.init(from: decoder)
    }

    func plistKeyAndValue(proj: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary = try super.plistValues(proj: proj, reference: reference)
        dictionary["isa"] = .string(CommentedString(XCSwiftPackageProductDependency.isa))
        if let package = package {
            dictionary["package"] = .string(.init(package.reference.value, comment: "XCRemoteSwiftPackageReference \"\(package.name ?? "")\""))
        }
        if isPlugin {
            dictionary["productName"] = .string(.init("plugin:" + productName))
        } else {
            dictionary["productName"] = .string(.init(productName))
        }

        return (key: CommentedString(reference, comment: productName),
                value: .dictionary(dictionary))
    }

    // MARK: - Codable

    fileprivate enum CodingKeys: String, CodingKey {
        case productName
        case package
    }

    override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? XCSwiftPackageProductDependency else { return false }
        return isEqual(to: rhs)
    }
}
