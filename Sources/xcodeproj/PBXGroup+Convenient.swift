import Foundation

/// Options passed when adding new groups.
public struct GroupAddingOptions: OptionSet {
    /// Raw value.
    public let rawValue: Int

    /// Initializes the options with the raw value.
    ///
    /// - Parameter rawValue: raw value.
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Create group without reference to folder
    public static let withoutFolder = GroupAddingOptions(rawValue: 1 << 0)
}

public extension PBXGroup {
    /// Returns group with the given name contained in the given parent group.
    ///
    /// - Parameter groupName: group name.
    /// - Returns: group with the given name contained in the given parent group.
    public func group(named name: String) -> PBXGroup? {
        return children
            .compactMap({ try? $0.object() as PBXGroup })
            .first(where: { $0.name == name })
    }

    /// Creates a group with the given name and returns it.
    ///
    /// - Parameters:
    ///   - groupName: group name.
    ///   - options: creation options.
    /// - Returns: created groups.
    public func addGroup(named groupName: String, options: GroupAddingOptions = []) throws -> [PBXGroup] {
        let objects = try self.objects()
        return groupName.components(separatedBy: "/").reduce(into: [PBXGroup](), { groups, name in
            let group = groups.last ?? self
            let newGroup = PBXGroup(children: [], sourceTree: .group, name: name, path: options.contains(.withoutFolder) ? nil : name)
            group.children.append(newGroup.reference)
            objects.addObject(newGroup)
            groups.append(newGroup)
        })
    }

//    /// Adds file at the give path to the project and given group or returns existing file and its reference.
//    ///
//    /// - Parameters:
//    ///   - filePath: path to the file.
//    ///   - toGroup: group to add file to.
//    ///   - sourceTree: file sourceTree, default is `.group`
//    ///   - sourceRoot: path to project's source root.
//    /// - Returns: new or existing file and its reference.
//    public func addFile(
//        at filePath: AbsolutePath,
//        toGroup: PBXGroup,
//        sourceTree: PBXSourceTree = .group,
//        sourceRoot: AbsolutePath) throws -> PBXReferencedObject<PBXFileReference> {
//        guard filePath.exists else {
//            throw XCodeProjEditingError.fileNotExists(path: filePath)
//        }
//
//        guard let groupReference = groups.first(where: { $0.value == toGroup })?.key else {
//            throw XCodeProjEditingError.groupNotFound(group: toGroup)
//        }
//        let groupPath = fullPath(fileElement: toGroup, reference: groupReference.value, sourceRoot: sourceRoot)
//
//        if let existingFileReference = fileReferences.referencedObjects.first(where: {
//            filePath == fullPath(fileElement: $0.object, reference: $0.reference, sourceRoot: sourceRoot)
//        }) {
//            if !toGroup.children.contains(existingFileReference.reference) {
//                existingFileReference.object.path = groupPath.flatMap { filePath.relative(to: $0) }?.asString
//                toGroup.children.append(existingFileReference.reference)
//            }
//            return existingFileReference
//        }
//
//        let path: String?
//        switch sourceTree {
//        case .group:
//            path = groupPath.map({ filePath.relative(to: $0) })?.asString
//        case .sourceRoot:
//            path = filePath.relative(to: sourceRoot).asString
//        case .absolute:
//            path = filePath.asString
//        default:
//            path = nil
//        }
//
//        let fileReference = PBXFileReference(
//            sourceTree: sourceTree,
//            name: filePath.lastComponent,
//            explicitFileType: PBXFileReference.fileType(path: filePath),
//            lastKnownFileType: PBXFileReference.fileType(path: filePath),
//            path: path
//        )
//        let reference = addObject(fileReference)
//        if !toGroup.children.contains(reference.value) {
//            toGroup.children.append(reference.value)
//        }
//        return PBXReferencedObject(reference: reference.value, object: fileReference)
//    }
}
