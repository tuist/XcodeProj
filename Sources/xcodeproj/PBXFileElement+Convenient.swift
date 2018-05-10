import Basic
import Foundation

public extension PBXFileElement {
    /// Returns a file absolute path.
    ///
    /// - Parameter sourceRoot: project source root.
    /// - Returns: file element absolute path.
    /// - Throws: an error if the absolute path cannot be obtained.
    public func fullPath(sourceRoot: AbsolutePath) throws -> AbsolutePath? {
        let projectObjects = try objects()
        switch sourceTree {
        case .absolute?:
            return path.flatMap({ AbsolutePath($0) })
        case .sourceRoot?:
            return path.flatMap({ sourceRoot.appending(RelativePath($0)) })
        case .group?:
            guard let group = projectObjects.groups.first(where: { $0.value.children.contains(reference) }) else { return sourceRoot }
            guard let groupPath = try group.value.fullPath(sourceRoot: sourceRoot) else { return nil }
            guard let filePath = self is PBXVariantGroup ? try baseVariantGroupPath() : path else { return groupPath }
            return groupPath.appending(RelativePath(filePath))
        default:
            return nil
        }
    }

    /// Returns the path to the variant group base file.
    ///
    /// - Returns: path to the variant group base file.
    /// - Throws: an error if the path cannot be obtained.
    private func baseVariantGroupPath() throws -> String? {
        guard let variantGroup: PBXVariantGroup = try self.reference.object() else { return nil }
        guard let baseReference = try variantGroup.children.compactMap({ try $0.object() as PBXFileElement }).first(where: { $0.name == "Base" }) else { return nil }
        return baseReference.path
    }
}
