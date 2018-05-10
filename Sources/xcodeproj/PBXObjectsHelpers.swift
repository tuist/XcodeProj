import Basic
import Foundation

/// PBXObject Helpers.
class PBXObjectsHelpers {
    @available(*, deprecated, message: "Will be deleted")
    static func getTarget(reference: String, objects: PBXObjects) -> PBXTarget? {
        return objects.aggregateTargets.getReference(reference) ??
            objects.nativeTargets.getReference(reference) ??
            objects.legacyTargets.getReference(reference)
    }

    @available(*, deprecated, message: "Will be deleted")
    static func getFileElement(reference: String, objects: PBXObjects) -> PBXFileElement? {
        return objects.fileReferences.getReference(reference) ??
            objects.groups.getReference(reference) ??
            objects.variantGroups.getReference(reference) ??
            objects.versionGroups.getReference(reference)
    }

    /// Returns all the targets with the given name.
    ///
    /// - Parameters:
    ///   - name: target name.
    ///   - objects: project objects.
    /// - Returns: targets with the given name.
    static func targets(named name: String, objects: PBXObjects) -> [PBXTarget] {
        var targets: [PBXTarget] = []
        targets.append(contentsOf: objects.nativeTargets.values.map({ $0 as PBXTarget }))
        targets.append(contentsOf: objects.legacyTargets.values.map({ $0 as PBXTarget }))
        targets.append(contentsOf: objects.aggregateTargets.values.map({ $0 as PBXTarget }))
        return targets.filter { $0.name == name }
    }

    /// Returns all files in target's sources build phase.
    ///
    /// - Parameters:
    ///   - target: target.
    ///   - objects: project objects.
    /// - Returns: all files in target's sources build phase, or empty array if sources build phase is not found.
    static func sourceFiles(target: PBXTarget, objects: PBXObjects) -> [PBXFileElement] {
        return sourcesBuildPhase(target: target, objects: objects)?.files
            .compactMap { objects.buildFiles.getReference($0)?.fileRef }
            .compactMap { fileRef in getFileElement(reference: fileRef, objects: objects) }
            ?? []
    }
}

public enum XCodeProjEditingError: Error, CustomStringConvertible {
    case fileNotExists(path: AbsolutePath)
    case groupNotFound(group: PBXGroup)

    public var description: String {
        switch self {
        case let .fileNotExists(path):
            return "\(path.asString) does not exist"
        case let .groupNotFound(group):
            return "Group not found in project: \(group)"
        }
    }
}

// MARK: - PBXObjects Extension (Internal)

extension PBXObjects {
//
//    /// Returns the object with the given configuration list (project or target)
//    ///
//    /// - Parameter reference: configuration list reference.
//    /// - Returns: target or project with the given configuration list.
//    func objectWithConfigurationList(reference: String) -> PBXReferencedObject<PBXObject>? {
//        return projects.first(where: { $0.value.buildConfigurationList == reference }).flatMap({ PBXReferencedObject(reference: $0.key.value, object: $0.value) }) ??
//            nativeTargets.first(where: { $0.value.buildConfigurationList == reference }).flatMap({ PBXReferencedObject(reference: $0.key.value, object: $0.value) }) ??
//            aggregateTargets.first(where: { $0.value.buildConfigurationList == reference }).flatMap({ PBXReferencedObject(reference: $0.key.value, object: $0.value) }) ??
//            legacyTargets.first(where: { $0.value.buildConfigurationList == reference }).flatMap({ PBXReferencedObject(reference: $0.key.value, object: $0.value) })
//    }
}
