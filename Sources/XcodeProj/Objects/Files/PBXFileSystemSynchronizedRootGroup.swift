import Foundation
import PathKit

public class PBXFileSystemSynchronizedRootGroup: PBXFileElement {
    /// It maps relative paths inside the synchronized root group to a particular file type.
    /// If a path doesn't have a particular file type specified, Xcode defaults to the default file type
    /// based on the extension of the file.
    public var explicitFileTypes: [String: String]

    /// Returns the references of the exceptions.
    var exceptionsReferences: [PBXObjectReference]?

    /// It returns a list of exception objects that override the configuration for some children
    /// in the synchronized root group.
    public var exceptions: [PBXFileSystemSynchronizedBuildFileExceptionSet]? {
        set {
            exceptionsReferences = newValue?.references()
        }
        get {
            exceptionsReferences?.objects()
        }
    }

    /// A list of relative paths to children folder whose configuration is overriden.
    public var explicitFolders: [String]

    /// Initializes the file element with its properties.
    ///
    /// - Parameters:
    ///   - sourceTree: file source tree.
    ///   - path: object relative path from `sourceTree`, if different than `name`.
    ///   - name: object name.
    ///   - includeInIndex: should the IDE index the object?
    ///   - usesTabs: object uses tabs.
    ///   - indentWidth: the number of positions to indent blocks of code
    ///   - tabWidth: the visual width of tab characters
    ///   - wrapsLines: should the IDE wrap lines when editing the object?
    ///   - explicitFileTypes: It maps relative paths inside the synchronized root group to a particular file type.
    ///   - exceptions: It returns a list of exception objects that override the configuration for some children in the synchronized root group.
    ///   - explicitFolders: A list of relative paths to children folder whose configuration is overriden.
    public init(sourceTree: PBXSourceTree? = nil,
                path: String? = nil,
                name: String? = nil,
                includeInIndex: Bool? = nil,
                usesTabs: Bool? = nil,
                indentWidth: UInt? = nil,
                tabWidth: UInt? = nil,
                wrapsLines: Bool? = nil,
                explicitFileTypes: [String: String] = [:],
                exceptions: [PBXFileSystemSynchronizedBuildFileExceptionSet] = [],
                explicitFolders: [String] = []) {
        self.explicitFileTypes = explicitFileTypes
        exceptionsReferences = exceptions.references()
        self.explicitFolders = explicitFolders
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
        case explicitFileTypes
        case exceptions
        case explicitFolders
    }

    public required init(from decoder: Decoder) throws {
        let objects = decoder.context.objects
        let objectReferenceRepository = decoder.context.objectReferenceRepository
        let container = try decoder.container(keyedBy: CodingKeys.self)
        explicitFileTypes = try (container.decodeIfPresent(.explicitFileTypes)) ?? [:]
        let exceptionsReferences: [String] = try (container.decodeIfPresent(.exceptions)) ?? []
        self.exceptionsReferences = exceptionsReferences.map { objectReferenceRepository.getOrCreate(reference: $0, objects: objects) }
        explicitFolders = try (container.decodeIfPresent(.explicitFolders)) ?? []
        try super.init(from: decoder)
    }

    // MARK: - PlistSerializable

    override var multiline: Bool { false }

    override func plistKeyAndValue(proj: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = try super.plistKeyAndValue(proj: proj, reference: reference).value.dictionary ?? [:]
        dictionary["isa"] = .string(CommentedString(type(of: self).isa))
        if let exceptionsReferences, !exceptionsReferences.isEmpty {
            dictionary["exceptions"] = .array(exceptionsReferences.map { exceptionReference in
                .string(CommentedString(exceptionReference.value, comment: "PBXFileSystemSynchronizedBuildFileExceptionSet"))
            })
        }
        dictionary["explicitFileTypes"] = .dictionary(Dictionary(uniqueKeysWithValues: explicitFileTypes.map { relativePath, fileType in
            (CommentedString(relativePath), .string(CommentedString(fileType)))
        }))
        dictionary["explicitFolders"] = .array(explicitFolders.map { .string(CommentedString($0)) })
        return (key: CommentedString(reference,
                                     comment: name ?? path),
                value: .dictionary(dictionary))
    }

    override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXFileSystemSynchronizedRootGroup else { return false }
        return isEqual(to: rhs)
    }
}
