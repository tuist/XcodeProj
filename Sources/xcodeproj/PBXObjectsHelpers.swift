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

    /// Returns the target's sources build phase.
    ///
    /// - Parameters:
    ///   - target: target.
    ///   - objects: project objects.
    /// - Returns: target's sources build phase, if found.
    static func sourcesBuildPhase(target: PBXTarget, objects: PBXObjects) -> PBXSourcesBuildPhase? {
        return objects.sourcesBuildPhases.first(where: { target.buildPhases.contains($0.key.value) })?.value
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

    /// Returns group with the given name contained in the given parent group and its reference.
    ///
    /// - Parameter groupName: group name.
    /// - Parameter inGroup: parent group.
    ///   - objects: project objects.
    /// - Returns: group with the given name contained in the given parent group and its reference.
    static func group(named groupName: String, inGroup: PBXGroup, objects: PBXObjects) -> PBXGroup? {
        let children = inGroup.children
        return objects.groups.first {
            children.contains($0.key.value) && ($0.value.name == groupName || $0.value.path == groupName)
        }?.value
    }
}

public struct GroupAddingOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Create group without reference to folder
    public static let withoutFolder = GroupAddingOptions(rawValue: 1 << 0)
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
    /// Returns the file name from a build file reference.
    ///
    /// - Parameter buildFileReference: file reference.
    /// - Returns: build file name.
    func fileName(buildFileReference: String) -> String? {
        guard let buildFile: PBXBuildFile = buildFiles.getReference(buildFileReference),
            let fileReference = buildFile.fileRef else {
            return nil
        }
        return fileName(fileReference: fileReference)
    }

    /// Returns the file name from a file reference.
    ///
    /// - Parameter fileReference: file reference.
    /// - Returns: file name.
    func fileName(fileReference: String) -> String? {
        guard let fileElement = getFileElement(reference: fileReference) else {
            return nil
        }
        return fileElement.name ?? fileElement.path
    }

    /// Returns the configNamefile reference.
    ///
    /// - Parameter configReference: reference of the XCBuildConfiguration.
    /// - Returns: config name.
    func configName(configReference: String) -> String? {
        return buildConfigurations.getReference(configReference)?.name
    }

    /// Returns the build phase a file is in.
    ///
    /// - Parameter reference: reference of the file whose type will be returned.
    /// - Returns: String with the type of file.
    func buildPhaseType(buildFileReference: String) -> BuildPhase? {
        if sourcesBuildPhases.contains(where: { _, val in val.files.contains(buildFileReference) }) {
            return .sources
        } else if frameworksBuildPhases.contains(where: { _, val in val.files.contains(buildFileReference) }) {
            return .frameworks
        } else if resourcesBuildPhases.contains(where: { _, val in val.files.contains(buildFileReference) }) {
            return .resources
        } else if copyFilesBuildPhases.contains(where: { _, val in val.files.contains(buildFileReference) }) {
            return .copyFiles
        } else if headersBuildPhases.contains(where: { _, val in val.files.contains(buildFileReference) }) {
            return .headers
        } else if carbonResourcesBuildPhases.contains(where: { _, val in val.files.contains(buildFileReference) }) {
            return .carbonResources
        }
        return nil
    }

    /// Returns the build phase type from its reference.
    ///
    /// - Parameter reference: build phase reference.
    /// - Returns: string with the build phase type.
    func buildPhaseType(buildPhaseReference: String) -> BuildPhase? {
        if sourcesBuildPhases.contains(reference: buildPhaseReference) {
            return .sources
        } else if frameworksBuildPhases.contains(reference: buildPhaseReference) {
            return .frameworks
        } else if resourcesBuildPhases.contains(reference: buildPhaseReference) {
            return .resources
        } else if copyFilesBuildPhases.contains(reference: buildPhaseReference) {
            return .copyFiles
        } else if shellScriptBuildPhases.contains(reference: buildPhaseReference) {
            return .runScript
        } else if headersBuildPhases.contains(reference: buildPhaseReference) {
            return .headers
        } else if carbonResourcesBuildPhases.contains(reference: buildPhaseReference) {
            return .carbonResources
        }
        return nil
    }

    /// Get the build phase name given its reference (mostly used for comments).
    ///
    /// - Parameter buildPhaseReference: build phase reference.
    /// - Returns: the build phase name.
    func buildPhaseName(buildPhaseReference: String) -> String? {
        if sourcesBuildPhases.contains(reference: buildPhaseReference) {
            return "Sources"
        } else if frameworksBuildPhases.contains(reference: buildPhaseReference) {
            return "Frameworks"
        } else if resourcesBuildPhases.contains(reference: buildPhaseReference) {
            return "Resources"
        } else if let copyFilesBuildPhase = copyFilesBuildPhases.getReference(buildPhaseReference) {
            return copyFilesBuildPhase.name ?? "CopyFiles"
        } else if let shellScriptBuildPhase = shellScriptBuildPhases.getReference(buildPhaseReference) {
            return shellScriptBuildPhase.name ?? "ShellScript"
        } else if headersBuildPhases.contains(reference: buildPhaseReference) {
            return "Headers"
        } else if carbonResourcesBuildPhases.contains(reference: buildPhaseReference) {
            return "Rez"
        }
        return nil
    }

    /// Returns the build phase name a file is in (mostly used for comments).
    ///
    /// - Parameter reference: reference of the file whose type name will be returned.
    /// - Returns: the build phase name.
    func buildPhaseName(buildFileReference: String) -> String? {
        let type = buildPhaseType(buildFileReference: buildFileReference)
        switch type {
        case .copyFiles?:
            return copyFilesBuildPhases.first(where: { _, val in val.files.contains(buildFileReference) })?.value.name ?? type?.rawValue
        default:
            return type?.rawValue
        }
    }

    /// Returns the object with the given configuration list (project or target)
    ///
    /// - Parameter reference: configuration list reference.
    /// - Returns: target or project with the given configuration list.
    func objectWithConfigurationList(reference: String) -> PBXReferencedObject<PBXObject>? {
        return projects.first(where: { $0.value.buildConfigurationList == reference }).flatMap({ PBXReferencedObject(reference: $0.key.value, object: $0.value) }) ??
            nativeTargets.first(where: { $0.value.buildConfigurationList == reference }).flatMap({ PBXReferencedObject(reference: $0.key.value, object: $0.value) }) ??
            aggregateTargets.first(where: { $0.value.buildConfigurationList == reference }).flatMap({ PBXReferencedObject(reference: $0.key.value, object: $0.value) }) ??
            legacyTargets.first(where: { $0.value.buildConfigurationList == reference }).flatMap({ PBXReferencedObject(reference: $0.key.value, object: $0.value) })
    }
}
