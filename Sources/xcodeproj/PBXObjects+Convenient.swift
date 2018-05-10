import Basic
import Foundation

// MARK: - PBXObjects Extension (Public)

public extension PBXObjects {
    @available(*, deprecated, message: "Will be deleted")
    public func getFileElement(reference: String) -> PBXFileElement? {
        return PBXObjectsHelpers.getFileElement(reference: reference, objects: self)
    }

    /// Returns all the targets with the given name.
    ///
    /// - Parameter name: target name.
    /// - Returns: all existing targets with the given name.
    public func targets(named name: String) -> [PBXTarget] {
        return PBXObjectsHelpers.targets(named: name, objects: self)
    }

    @available(*, deprecated, message: "Will be deleted")
    public func sourcesBuildPhase(target: PBXTarget) -> PBXSourcesBuildPhase? {
        return PBXObjectsHelpers.sourcesBuildPhase(target: target, objects: self)
    }

    @available(*, deprecated, message: "Will be deleted")
    public func sourceFiles(target: PBXTarget) -> [PBXFileElement] {
        return PBXObjectsHelpers.sourceFiles(target: target, objects: self)
    }

    @available(*, deprecated, message: "Will be deleted")
    public func group(named groupName: String, inGroup: PBXGroup) -> PBXGroup? {
        return PBXObjectsHelpers.group(named: groupName, inGroup: inGroup, objects: self)
    }

    /// Adds new group with the give name to the given parent group.
    /// Group name can be a path with components separated by `/`.
    /// Will create new groups for intermediate path components or use existing groups.
    /// Returns all new or existing groups in the path and their references.
    ///
    /// - Parameters:
    ///   - groupName: group name, can be a path with components separated by `/`
    ///   - toGroup: parent group
    ///   - options: additional options, default is empty set.
    /// - Returns: all new or existing groups in the path and their references.

    // TODO:
//    public func addGroup(named groupName: String, to toGroup: PBXGroup, options: GroupAddingOptions = []) -> [PBXReferencedObject<PBXGroup>] {
//        return addGroups(groupName.components(separatedBy: "/"), to: toGroup, options: options)
//    }
//
//    private func addGroups(_ groupNames: [String], to toGroup: PBXGroup, options: GroupAddingOptions) -> [PBXReferencedObject<PBXGroup>] {
//        guard !groupNames.isEmpty else { return [] }
//        let newGroup = createOrGetGroup(named: groupNames[0], in: toGroup, options: options)
//        return [newGroup] + addGroups(Array(groupNames.dropFirst()), to: newGroup.object, options: options)
//    }
//
//    private func createOrGetGroup(named groupName: String, in parentGroup: PBXGroup, options: GroupAddingOptions) -> PBXReferencedObject<PBXGroup> {
//        if let existingGroup = group(named: groupName, inGroup: parentGroup) {
//            return existingGroup
//        }
//
//        let newGroup = PBXGroup(
//            children: [],
//            sourceTree: .group,
//            name: groupName,
//            path: options.contains(.withoutFolder) ? nil : groupName
//        )
//        let reference = addObject(newGroup)
//        parentGroup.children.append(reference.value)
//        return PBXReferencedObject(reference: reference.value, object: newGroup)
//    }

    /// Adds file at the give path to the project and given group or returns existing file and its reference.
    ///
    /// - Parameters:
    ///   - filePath: path to the file.
    ///   - toGroup: group to add file to.
    ///   - sourceTree: file sourceTree, default is `.group`
    ///   - sourceRoot: path to project's source root.
    /// - Returns: new or existing file and its reference.
    public func addFile(
        at filePath: AbsolutePath,
        toGroup: PBXGroup,
        sourceTree: PBXSourceTree = .group,
        sourceRoot: AbsolutePath) throws -> PBXReferencedObject<PBXFileReference> {
        guard filePath.exists else {
            throw XCodeProjEditingError.fileNotExists(path: filePath)
        }

        guard let groupReference = groups.first(where: { $0.value == toGroup })?.key else {
            throw XCodeProjEditingError.groupNotFound(group: toGroup)
        }
        let groupPath = fullPath(fileElement: toGroup, reference: groupReference.value, sourceRoot: sourceRoot)

        if let existingFileReference = fileReferences.referencedObjects.first(where: {
            filePath == fullPath(fileElement: $0.object, reference: $0.reference, sourceRoot: sourceRoot)
        }) {
            if !toGroup.children.contains(existingFileReference.reference) {
                existingFileReference.object.path = groupPath.flatMap { filePath.relative(to: $0) }?.asString
                toGroup.children.append(existingFileReference.reference)
            }
            return existingFileReference
        }

        let path: String?
        switch sourceTree {
        case .group:
            path = groupPath.map({ filePath.relative(to: $0) })?.asString
        case .sourceRoot:
            path = filePath.relative(to: sourceRoot).asString
        case .absolute:
            path = filePath.asString
        default:
            path = nil
        }

        let fileReference = PBXFileReference(
            sourceTree: sourceTree,
            name: filePath.lastComponent,
            explicitFileType: PBXFileReference.fileType(path: filePath),
            lastKnownFileType: PBXFileReference.fileType(path: filePath),
            path: path
        )
        let reference = addObject(fileReference)
        if !toGroup.children.contains(reference.value) {
            toGroup.children.append(reference.value)
        }
        return PBXReferencedObject(reference: reference.value, object: fileReference)
    }

    /// Adds file to the given target's sources build phase or returns existing build file and its reference.
    /// If target's sources build phase can't be found returns nil.
    ///
    /// - Parameter target: target object
    /// - Parameter reference: file reference
    /// - Returns: new or existing build file and its reference
    public func addBuildFile(toTarget target: PBXTarget, reference: String) -> PBXReferencedObject<PBXBuildFile>? {
        guard let sourcesBuildPhase = sourcesBuildPhase(target: target) else { return nil }
        if let existingBuildFile = buildFiles.referencedObjects.first(where: { $0.object.fileRef == reference }) {
            return existingBuildFile
        }

        let buildFile = PBXBuildFile(fileRef: reference)
        let reference = addObject(buildFile)
        sourcesBuildPhase.files.append(reference.value)
        return PBXReferencedObject(reference: reference.value, object: buildFile)
    }

    /// Returns full path of the file element.
    ///
    /// - Parameters:
    ///   - fileElement: a file element
    ///   - reference: a reference to this file element
    ///   - sourceRoot: path to the project's sourceRoot
    /// - Returns: fully qualified file element path
    public func fullPath(fileElement: PBXFileElement, reference: String, sourceRoot: AbsolutePath) -> AbsolutePath? {
        switch fileElement.sourceTree {
        case .absolute?:
            return fileElement.path.flatMap({ AbsolutePath($0) })
        case .sourceRoot?:
            return fileElement.path.flatMap({ sourceRoot.appending(RelativePath($0)) })
        case .group?:
            guard let group = groups.first(where: { $0.value.children.contains(reference) }) else { return sourceRoot }
            guard let groupPath = fullPath(fileElement: group.value, reference: group.key.value, sourceRoot: sourceRoot) else { return nil }
            guard let filePath = fileElement is PBXVariantGroup ? baseVariantGroupPath(for: reference) : fileElement.path else { return groupPath }
            return groupPath.appending(RelativePath(filePath))
        default:
            return nil
        }
    }

    private func baseVariantGroupPath(for reference: String) -> String? {
        guard let variantGroup = variantGroups.getReference(reference),
            let baseReference = variantGroup.children.first(where: { fileReferences.getReference($0)?.name == "Base" }),
            let baseVariant = fileReferences.getReference(baseReference) else { return nil }

        return baseVariant.path
    }
}
