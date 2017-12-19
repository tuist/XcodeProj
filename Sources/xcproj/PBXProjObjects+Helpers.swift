import Foundation

// MARK: - PBXProj.Objects Extension (Public)

public extension PBXProj.Objects {

    /// Returns all the targets with the given name.
    ///
    /// - Parameter name: target name.
    /// - Returns: all existing targets with the given name.
    public func targets(named name: String) -> [PBXTarget] {
        var targets: [PBXTarget] = []
        targets.append(contentsOf: Array(nativeTargets.values) as [PBXTarget])
        targets.append(contentsOf: Array(legacyTargets.values) as [PBXTarget])
        targets.append(contentsOf: Array(aggregateTargets.values) as [PBXTarget])
        return targets.filter { $0.name == name }
    }
    
}

// MARK: - PBXProj.Objects Extension (Internal)

extension PBXProj.Objects {
    
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
        return buildConfigurations[configReference]?.name
    }
    
    /// Returns the build phase a file is in.
    ///
    /// - Parameter reference: reference of the file whose type will be returned.
    /// - Returns: String with the type of file.
    func buildPhaseType(buildFileReference: String) -> BuildPhase? {
        if sourcesBuildPhases.contains(where: { _, val in val.files.contains(buildFileReference)}) {
            return .sources
        } else if frameworksBuildPhases.contains(where: { _, val in val.files.contains(buildFileReference)}) {
            return .frameworks
        } else if resourcesBuildPhases.contains(where: { _, val in val.files.contains(buildFileReference)}) {
            return .resources
        } else if copyFilesBuildPhases.contains(where: { _, val in val.files.contains(buildFileReference)}) {
            return .copyFiles
        } else if headersBuildPhases.contains(where: { _, val in val.files.contains(buildFileReference)}) {
            return .headers
        } else if carbonResourcesBuildPhases.contains(where: { _, val in val.files.contains(buildFileReference)}) {
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
            return  copyFilesBuildPhase.name ?? "CopyFiles"
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
            return copyFilesBuildPhases.first(where: { _, val in val.files.contains(buildFileReference)})?.value.name ?? type?.rawValue
        default:
            return type?.rawValue
        }
    }
    
}
