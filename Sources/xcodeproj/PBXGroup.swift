import Foundation

public class PBXGroup: PBXFileElement {

    // MARK: - Attributes

    /// Element children.
    public var children: [PBXObjectReference]

    // MARK: - Init

    /// Initializes the group with its attributes.
    ///
    /// - Parameters:
    ///   - children: group children.
    ///   - sourceTree: group source tree.
    ///   - name: group name.
    ///   - path: group relative path from `sourceTree`, if different than `name`.
    ///   - includeInIndex: should the IDE index the files in the group?
    ///   - wrapsLines: should the IDE wrap lines for files in the group?
    ///   - usesTabs: group uses tabs.
    ///   - indentWidth: the number of positions to indent blocks of code
    ///   - tabWidth: the visual width of tab characters
    public init(children: [PBXObjectReference] = [],
                sourceTree: PBXSourceTree? = nil,
                name: String? = nil,
                path: String? = nil,
                includeInIndex: Bool? = nil,
                wrapsLines: Bool? = nil,
                usesTabs: Bool? = nil,
                indentWidth: UInt? = nil,
                tabWidth: UInt? = nil) {
        self.children = children
        super.init(sourceTree: sourceTree,
                   path: path,
                   name: name,
                   includeInIndex: includeInIndex,
                   usesTabs: usesTabs,
                   indentWidth: indentWidth,
                   tabWidth: tabWidth,
                   wrapsLines: wrapsLines)
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case children
    }

    public required init(from decoder: Decoder) throws {
        let objects = decoder.context.objects
        let objectReferenceRepository = decoder.context.objectReferenceRepository
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let childrenReferences: [String] = (try container.decodeIfPresent(.children)) ?? []
        children = childrenReferences.map({ objectReferenceRepository.getOrCreate(reference: $0, objects: objects) })
        try super.init(from: decoder)
    }

    // MARK: - PlistSerializable

    override func plistKeyAndValue(proj: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = try super.plistKeyAndValue(proj: proj, reference: reference).value.dictionary ?? [:]
        dictionary["isa"] = .string(CommentedString(type(of: self).isa))
        dictionary["children"] = try .array(children.map({ (fileReference) -> PlistValue in
            let fileElement: PBXFileElement = try fileReference.object()
            return .string(CommentedString(fileReference.value, comment: fileElement.fileName()))
        }))

        return (key: CommentedString(reference,
                                     comment: name ?? path),
                value: .dictionary(dictionary))
    }
}
