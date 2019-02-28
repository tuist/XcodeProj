import Foundation
import PathKit

/// This element is an abstract parent for file and group elements.
public class PBXFileElement: PBXContainerItem, PlistSerializable {
    // MARK: - Attributes

    /// Element source tree.
    public var sourceTree: PBXSourceTree?

    /// Element path.
    public var path: String?

    /// Element name.
    public var name: String?

    /// Element include in index.
    public var includeInIndex: Bool?

    /// Element uses tabs.
    public var usesTabs: Bool?

    /// Element indent width.
    public var indentWidth: UInt?

    /// Element tab width.
    public var tabWidth: UInt?

    /// Element wraps lines.
    public var wrapsLines: Bool?

    // MARK: - Init

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
    public init(sourceTree: PBXSourceTree? = nil,
                path: String? = nil,
                name: String? = nil,
                includeInIndex: Bool? = nil,
                usesTabs: Bool? = nil,
                indentWidth: UInt? = nil,
                tabWidth: UInt? = nil,
                wrapsLines: Bool? = nil) {
        self.sourceTree = sourceTree
        self.path = path
        self.name = name
        self.includeInIndex = includeInIndex
        self.usesTabs = usesTabs
        self.indentWidth = indentWidth
        self.tabWidth = tabWidth
        self.wrapsLines = wrapsLines
        super.init()
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case sourceTree
        case name
        case path
        case includeInIndex
        case usesTabs
        case indentWidth
        case tabWidth
        case wrapsLines
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sourceTree = try container.decodeIfPresent(String.self, forKey: .sourceTree).map { PBXSourceTree(value: $0) }
        name = try container.decodeIfPresent(.name)
        path = try container.decodeIfPresent(.path)
        includeInIndex = try container.decodeIntBoolIfPresent(.includeInIndex)
        usesTabs = try container.decodeIntBoolIfPresent(.usesTabs)
        indentWidth = try container.decodeIntIfPresent(.indentWidth)
        tabWidth = try container.decodeIntIfPresent(.tabWidth)
        wrapsLines = try container.decodeIntBoolIfPresent(.wrapsLines)
        try super.init(from: decoder)
    }

    // MARK: - PlistSerializable

    var multiline: Bool { return true }

    func plistKeyAndValue(proj _: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXFileElement.isa))
        if let name = name {
            dictionary["name"] = .string(CommentedString(name))
        }
        if let path = path {
            dictionary["path"] = .string(CommentedString(path))
        }
        if let sourceTree = sourceTree {
            dictionary["sourceTree"] = sourceTree.plist()
        }

        if let includeInIndex = includeInIndex {
            dictionary["includeInIndex"] = .string(CommentedString("\(includeInIndex.int)"))
        }
        if let usesTabs = usesTabs {
            dictionary["usesTabs"] = .string(CommentedString("\(usesTabs.int)"))
        }
        if let indentWidth = indentWidth {
            dictionary["indentWidth"] = .string(CommentedString("\(indentWidth)"))
        }
        if let tabWidth = tabWidth {
            dictionary["tabWidth"] = .string(CommentedString("\(tabWidth)"))
        }
        if let wrapsLines = wrapsLines {
            dictionary["wrapsLines"] = .string(CommentedString("\(wrapsLines.int)"))
        }
        return (key: CommentedString(reference,
                                     comment: name),
                value: .dictionary(dictionary))
    }

    /// Returns the name that should be used for comments.
    ///
    /// - Returns: file name.
    func fileName() -> String? {
        return name ?? path
    }
}

// MARK: - Helpers

public extension PBXFileElement {
    /// Returns a file absolute path.
    ///
    /// - Parameter sourceRoot: project source root.
    /// - Returns: file element absolute path.
    /// - Throws: an error if the absolute path cannot be obtained.
    func fullPath(sourceRoot: Path) throws -> Path? {
        let projectObjects = try objects()
        switch sourceTree {
        case .absolute?:
            return path.flatMap { Path($0) }
        case .sourceRoot?:
            return path.flatMap { sourceRoot + $0 }
        case .group?:
            guard let group = projectObjects.groups.first(where: { $0.value.childrenReferences.contains(reference) }) else { return sourceRoot }
            guard let groupPath = try group.value.fullPath(sourceRoot: sourceRoot) else { return nil }
            guard let filePath = self is PBXVariantGroup ? try baseVariantGroupPath() : path else { return groupPath }
            return groupPath + filePath
        default:
            return nil
        }
    }

    /// Returns the path to the variant group base file.
    ///
    /// - Returns: path to the variant group base file.
    /// - Throws: an error if the path cannot be obtained.
    private func baseVariantGroupPath() throws -> String? {
        guard let variantGroup: PBXVariantGroup = self.reference.getObject() else { return nil }
        guard let baseReference = try variantGroup
            .childrenReferences
            .compactMap({ try $0.getThrowingObject() as PBXFileElement })
            .first(where: { $0.name == "Base" }) else { return nil }
        return baseReference.path
    }
}
