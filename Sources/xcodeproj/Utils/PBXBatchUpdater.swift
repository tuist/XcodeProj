import Foundation
import PathKit

// This is a helper class for quickly adding a large number of files.
// It is forbidden to add a file to a group one by one using the PBXGroup method addFile(...) while you are working with this class.
public final class PBXBatchUpdater {
    private let objects: PBXObjects
    private let sourceRoot: Path
    private var references: [Path: PBXObjectReference]?

    init(objects: PBXObjects, sourceRoot: Path) {
        self.objects = objects
        self.sourceRoot = sourceRoot
    }

    /// Adds file at the give path to the project or returns existing file and its reference.
    ///
    /// - Parameters:
    ///   - fileName: file name.
    ///   - sourceTree: file sourceTree, default is `.group`
    ///   - sourceRoot: path to project's source root.
    /// - Returns: new or existing file and its reference.
    @discardableResult
    public func addFile(
        to group: PBXGroup,
        fileName: String,
        sourceTree: PBXSourceTree = .group
    ) throws -> PBXFileReference {
        let groupPath = try group.fullPath(sourceRoot: sourceRoot)
        let filePath = (groupPath ?? sourceRoot) + Path(fileName)

        let objectReferences = try lazilyInstantiateObjectReferences()
        if let existingObjectReference = objectReferences[filePath],
            let existingFileReference = objects.fileReferences[existingObjectReference] {
            if !group.childrenReferences.contains(existingObjectReference) {
                existingFileReference.path = groupPath.flatMap({ filePath.relative(to: $0) })?.string
                group.childrenReferences.append(existingObjectReference)
                return existingFileReference
            }
        }

        let path: String?
        switch sourceTree {
        case .group:
            path = groupPath.map({ filePath.relative(to: $0) })?.string
        case .sourceRoot:
            path = filePath.relative(to: sourceRoot).string
        case .absolute:
            path = filePath.string
        default:
            path = nil
        }
        let fileReference = PBXFileReference(
            sourceTree: sourceTree,
            name: filePath.lastComponent,
            explicitFileType: filePath.extension.flatMap(Xcode.filetype),
            lastKnownFileType: filePath.extension.flatMap(Xcode.filetype),
            path: path
        )
        objects.add(object: fileReference)
        fileReference.parent = group
        references?[filePath] = fileReference.reference
        if !group.childrenReferences.contains(fileReference.reference) {
            group.childrenReferences.append(fileReference.reference)
        }
        return fileReference
    }

    private func lazilyInstantiateObjectReferences()
        throws -> [Path: PBXObjectReference] {
        let objectReferences: [Path: PBXObjectReference]
        if let references = self.references {
            objectReferences = references
        } else {
            objectReferences = Dictionary(uniqueKeysWithValues:
                try objects.fileReferences.compactMap({
                    let fullPath = try $0.value.fullPath(sourceRoot: sourceRoot)!
                    return (fullPath, $0.key)
            }))
            references = objectReferences
        }
        return objectReferences
    }
}
