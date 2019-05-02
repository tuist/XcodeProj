import Foundation

// swiftlint:disable type_body_length
class PBXObjects: Equatable {
    // MARK: - Properties

    private let lock = NSRecursiveLock()

    private var notThreadSafeProjects: [PBXObjectReference: PBXProject] = [:]
    var projects: [PBXObjectReference: PBXProject] {
        return lock.whileLocked { notThreadSafeProjects }
    }

    private var notThreadSafeReferenceProxies: [PBXObjectReference: PBXReferenceProxy] = [:]
    var referenceProxies: [PBXObjectReference: PBXReferenceProxy] {
        return lock.whileLocked { notThreadSafeReferenceProxies }
    }

    // File elements
    private var notThreadSafeFileReferences: [PBXObjectReference: PBXFileReference] = [:]
    var fileReferences: [PBXObjectReference: PBXFileReference] {
        return lock.whileLocked { notThreadSafeFileReferences }
    }

    private var notThreadSafeVersionGroups: [PBXObjectReference: XCVersionGroup] = [:]
    var versionGroups: [PBXObjectReference: XCVersionGroup] {
        return lock.whileLocked { notThreadSafeVersionGroups }
    }

    private var notThreadSafeVariantGroups: [PBXObjectReference: PBXVariantGroup] = [:]
    var variantGroups: [PBXObjectReference: PBXVariantGroup] {
        return lock.whileLocked { notThreadSafeVariantGroups }
    }

    private var notThreadSafeGroups: [PBXObjectReference: PBXGroup] = [:]
    var groups: [PBXObjectReference: PBXGroup] {
        return lock.whileLocked { notThreadSafeGroups }
    }

    // Configuration
    private var notThreadSafeBuildConfigurations: [PBXObjectReference: XCBuildConfiguration] = [:]
    var buildConfigurations: [PBXObjectReference: XCBuildConfiguration] {
        return lock.whileLocked { notThreadSafeBuildConfigurations }
    }

    private var notThreadSafeConfigurationLists: [PBXObjectReference: XCConfigurationList] = [:]
    var configurationLists: [PBXObjectReference: XCConfigurationList] {
        return lock.whileLocked { notThreadSafeConfigurationLists }
    }

    // Targets
    private var notThreadSafeLegacyTargets: [PBXObjectReference: PBXLegacyTarget] = [:]
    var legacyTargets: [PBXObjectReference: PBXLegacyTarget] {
        return lock.whileLocked { notThreadSafeLegacyTargets }
    }

    private var notThreadSafeAggregateTargets: [PBXObjectReference: PBXAggregateTarget] = [:]
    var aggregateTargets: [PBXObjectReference: PBXAggregateTarget] {
        return lock.whileLocked { notThreadSafeAggregateTargets }
    }

    private var notThreadSafeNativeTargets: [PBXObjectReference: PBXNativeTarget] = [:]
    var nativeTargets: [PBXObjectReference: PBXNativeTarget] {
        return lock.whileLocked { notThreadSafeNativeTargets }
    }

    private var notThreadSafeTargetDependencies: [PBXObjectReference: PBXTargetDependency] = [:]
    var targetDependencies: [PBXObjectReference: PBXTargetDependency] {
        return lock.whileLocked { notThreadSafeTargetDependencies }
    }

    private var notThreadSafeContainerItemProxies: [PBXObjectReference: PBXContainerItemProxy] = [:]
    var containerItemProxies: [PBXObjectReference: PBXContainerItemProxy] {
        return lock.whileLocked { notThreadSafeContainerItemProxies }
    }

    private var notThreadSafeBuildRules: [PBXObjectReference: PBXBuildRule] = [:]
    var buildRules: [PBXObjectReference: PBXBuildRule] {
        return lock.whileLocked { notThreadSafeBuildRules }
    }

    // Build Phases
    private var notThreadSafeBuildFiles: [PBXObjectReference: PBXBuildFile] = [:]
    var buildFiles: [PBXObjectReference: PBXBuildFile] {
        return lock.whileLocked { notThreadSafeBuildFiles }
    }

    private var notThreadSafeCopyFilesBuildPhases: [PBXObjectReference: PBXCopyFilesBuildPhase] = [:]
    var copyFilesBuildPhases: [PBXObjectReference: PBXCopyFilesBuildPhase] {
        return lock.whileLocked { notThreadSafeCopyFilesBuildPhases }
    }

    private var notThreadSafeShellScriptBuildPhases: [PBXObjectReference: PBXShellScriptBuildPhase] = [:]
    var shellScriptBuildPhases: [PBXObjectReference: PBXShellScriptBuildPhase] {
        return lock.whileLocked { notThreadSafeShellScriptBuildPhases }
    }

    private var notThreadSafeResourcesBuildPhases: [PBXObjectReference: PBXResourcesBuildPhase] = [:]
    var resourcesBuildPhases: [PBXObjectReference: PBXResourcesBuildPhase] {
        return lock.whileLocked { notThreadSafeResourcesBuildPhases }
    }

    private var notThreadSafeFrameworksBuildPhases: [PBXObjectReference: PBXFrameworksBuildPhase] = [:]
    var frameworksBuildPhases: [PBXObjectReference: PBXFrameworksBuildPhase] {
        return lock.whileLocked { notThreadSafeFrameworksBuildPhases }
    }

    private var notThreadSafeHeadersBuildPhases: [PBXObjectReference: PBXHeadersBuildPhase] = [:]
    var headersBuildPhases: [PBXObjectReference: PBXHeadersBuildPhase] {
        return lock.whileLocked { notThreadSafeHeadersBuildPhases }
    }

    private var notThreadSafeSourcesBuildPhases: [PBXObjectReference: PBXSourcesBuildPhase] = [:]
    var sourcesBuildPhases: [PBXObjectReference: PBXSourcesBuildPhase] {
        return lock.whileLocked { notThreadSafeSourcesBuildPhases }
    }

    private var notThreadSafeCarbonResourcesBuildPhases: [PBXObjectReference: PBXRezBuildPhase] = [:]
    var carbonResourcesBuildPhases: [PBXObjectReference: PBXRezBuildPhase] {
        return lock.whileLocked { notThreadSafeCarbonResourcesBuildPhases }
    }

    /// Initializes the project objects container
    ///
    /// - Parameters:
    ///   - objects: project objects
    init(objects: [PBXObject] = []) {
        objects.forEach {
            _ = self.add(object: $0)
        }
    }

    // MARK: - Equatable

    public static func == (lhs: PBXObjects, rhs: PBXObjects) -> Bool {
        return lhs.buildFiles == rhs.buildFiles &&
            lhs.legacyTargets == rhs.legacyTargets &&
            lhs.aggregateTargets == rhs.aggregateTargets &&
            lhs.containerItemProxies == rhs.containerItemProxies &&
            lhs.copyFilesBuildPhases == rhs.copyFilesBuildPhases &&
            lhs.groups == rhs.groups &&
            lhs.configurationLists == rhs.configurationLists &&
            lhs.buildConfigurations == rhs.buildConfigurations &&
            lhs.variantGroups == rhs.variantGroups &&
            lhs.targetDependencies == rhs.targetDependencies &&
            lhs.sourcesBuildPhases == rhs.sourcesBuildPhases &&
            lhs.shellScriptBuildPhases == rhs.shellScriptBuildPhases &&
            lhs.resourcesBuildPhases == rhs.resourcesBuildPhases &&
            lhs.frameworksBuildPhases == rhs.frameworksBuildPhases &&
            lhs.headersBuildPhases == rhs.headersBuildPhases &&
            lhs.nativeTargets == rhs.nativeTargets &&
            lhs.fileReferences == rhs.fileReferences &&
            lhs.projects == rhs.projects &&
            lhs.versionGroups == rhs.versionGroups &&
            lhs.referenceProxies == rhs.referenceProxies &&
            lhs.carbonResourcesBuildPhases == rhs.carbonResourcesBuildPhases &&
            lhs.buildRules == rhs.buildRules
    }

    // MARK: - Helpers

    /// Add a new object.
    ///
    /// - Parameters:
    ///   - object: object.
    func add(object: PBXObject) {
        lock.lock()
        defer {
            lock.unlock()
        }
        let objectReference: PBXObjectReference = object.reference
        objectReference.objects = self

        switch object {
        // subclasses of PBXGroup; must be tested before PBXGroup
        case let object as PBXVariantGroup: notThreadSafeVariantGroups[objectReference] = object
        case let object as XCVersionGroup: notThreadSafeVersionGroups[objectReference] = object

        // everything else
        case let object as PBXBuildFile: notThreadSafeBuildFiles[objectReference] = object
        case let object as PBXAggregateTarget: notThreadSafeAggregateTargets[objectReference] = object
        case let object as PBXLegacyTarget: notThreadSafeLegacyTargets[objectReference] = object
        case let object as PBXContainerItemProxy: notThreadSafeContainerItemProxies[objectReference] = object
        case let object as PBXCopyFilesBuildPhase: notThreadSafeCopyFilesBuildPhases[objectReference] = object
        case let object as PBXGroup: notThreadSafeGroups[objectReference] = object
        case let object as XCConfigurationList: notThreadSafeConfigurationLists[objectReference] = object
        case let object as XCBuildConfiguration: notThreadSafeBuildConfigurations[objectReference] = object
        case let object as PBXTargetDependency: notThreadSafeTargetDependencies[objectReference] = object
        case let object as PBXSourcesBuildPhase: notThreadSafeSourcesBuildPhases[objectReference] = object
        case let object as PBXShellScriptBuildPhase: notThreadSafeShellScriptBuildPhases[objectReference] = object
        case let object as PBXResourcesBuildPhase: notThreadSafeResourcesBuildPhases[objectReference] = object
        case let object as PBXFrameworksBuildPhase: notThreadSafeFrameworksBuildPhases[objectReference] = object
        case let object as PBXHeadersBuildPhase: notThreadSafeHeadersBuildPhases[objectReference] = object
        case let object as PBXNativeTarget: notThreadSafeNativeTargets[objectReference] = object
        case let object as PBXFileReference: notThreadSafeFileReferences[objectReference] = object
        case let object as PBXProject: notThreadSafeProjects[objectReference] = object
        case let object as PBXReferenceProxy: notThreadSafeReferenceProxies[objectReference] = object
        case let object as PBXRezBuildPhase: notThreadSafeCarbonResourcesBuildPhases[objectReference] = object
        case let object as PBXBuildRule: notThreadSafeBuildRules[objectReference] = object
        default: fatalError("Unhandled PBXObject type for \(object), this is likely a bug / todo")
        }
    }

    /// Deletes the object with the given reference.
    ///
    /// - Parameter reference: referenc of the object to be deleted.
    /// - Returns: the deleted object.
    // swiftlint:disable:next function_body_length Note: SwiftLint doesn't disable if @discardable and the function are on different lines.
    @discardableResult func delete(reference: PBXObjectReference) -> PBXObject? {
        lock.lock()
        if let index = buildFiles.index(forKey: reference) {
            return notThreadSafeBuildFiles.remove(at: index).value
        } else if let index = aggregateTargets.index(forKey: reference) {
            return notThreadSafeAggregateTargets.remove(at: index).value
        } else if let index = legacyTargets.index(forKey: reference) {
            return notThreadSafeLegacyTargets.remove(at: index).value
        } else if let index = containerItemProxies.index(forKey: reference) {
            return notThreadSafeContainerItemProxies.remove(at: index).value
        } else if let index = groups.index(forKey: reference) {
            return notThreadSafeGroups.remove(at: index).value
        } else if let index = configurationLists.index(forKey: reference) {
            return notThreadSafeConfigurationLists.remove(at: index).value
        } else if let index = buildConfigurations.index(forKey: reference) {
            return notThreadSafeBuildConfigurations.remove(at: index).value
        } else if let index = variantGroups.index(forKey: reference) {
            return notThreadSafeVariantGroups.remove(at: index).value
        } else if let index = targetDependencies.index(forKey: reference) {
            return notThreadSafeTargetDependencies.remove(at: index).value
        } else if let index = nativeTargets.index(forKey: reference) {
            return notThreadSafeNativeTargets.remove(at: index).value
        } else if let index = fileReferences.index(forKey: reference) {
            return notThreadSafeFileReferences.remove(at: index).value
        } else if let index = projects.index(forKey: reference) {
            return notThreadSafeProjects.remove(at: index).value
        } else if let index = versionGroups.index(forKey: reference) {
            return notThreadSafeVersionGroups.remove(at: index).value
        } else if let index = referenceProxies.index(forKey: reference) {
            return notThreadSafeReferenceProxies.remove(at: index).value
        } else if let index = copyFilesBuildPhases.index(forKey: reference) {
            return notThreadSafeCopyFilesBuildPhases.remove(at: index).value
        } else if let index = shellScriptBuildPhases.index(forKey: reference) {
            return notThreadSafeShellScriptBuildPhases.remove(at: index).value
        } else if let index = resourcesBuildPhases.index(forKey: reference) {
            return notThreadSafeResourcesBuildPhases.remove(at: index).value
        } else if let index = frameworksBuildPhases.index(forKey: reference) {
            return notThreadSafeFrameworksBuildPhases.remove(at: index).value
        } else if let index = headersBuildPhases.index(forKey: reference) {
            return notThreadSafeHeadersBuildPhases.remove(at: index).value
        } else if let index = sourcesBuildPhases.index(forKey: reference) {
            return notThreadSafeSourcesBuildPhases.remove(at: index).value
        } else if let index = carbonResourcesBuildPhases.index(forKey: reference) {
            return notThreadSafeCarbonResourcesBuildPhases.remove(at: index).value
        } else if let index = buildRules.index(forKey: reference) {
            return notThreadSafeBuildRules.remove(at: index).value
        }
        lock.unlock()
        return nil
    }

    /// It returns the object with the given reference.
    ///
    /// - Parameter reference: Xcode reference.
    /// - Returns: object.
    // swiftlint:disable:next function_body_length
    func get(reference: PBXObjectReference) -> PBXObject? {
        // This if-let expression is used because the equivalent chain of `??` separated lookups causes,
        // with Swift 4, this compiler error:
        //     Expression was too complex to be solved in reasonable time;
        //     consider breaking up the expression into distinct sub-expressions
        if let object = buildFiles[reference] {
            return object
        } else if let object = aggregateTargets[reference] {
            return object
        } else if let object = legacyTargets[reference] {
            return object
        } else if let object = containerItemProxies[reference] {
            return object
        } else if let object = groups[reference] {
            return object
        } else if let object = configurationLists[reference] {
            return object
        } else if let object = buildConfigurations[reference] {
            return object
        } else if let object = variantGroups[reference] {
            return object
        } else if let object = targetDependencies[reference] {
            return object
        } else if let object = nativeTargets[reference] {
            return object
        } else if let object = fileReferences[reference] {
            return object
        } else if let object = projects[reference] {
            return object
        } else if let object = versionGroups[reference] {
            return object
        } else if let object = referenceProxies[reference] {
            return object
        } else if let object = copyFilesBuildPhases[reference] {
            return object
        } else if let object = shellScriptBuildPhases[reference] {
            return object
        } else if let object = resourcesBuildPhases[reference] {
            return object
        } else if let object = frameworksBuildPhases[reference] {
            return object
        } else if let object = headersBuildPhases[reference] {
            return object
        } else if let object = sourcesBuildPhases[reference] {
            return object
        } else if let object = carbonResourcesBuildPhases[reference] {
            return object
        } else if let object = buildRules[reference] {
            return object
        } else {
            return nil
        }
    }
}

// MARK: - Public

extension PBXObjects {
    /// Returns all the targets with the given name.
    ///
    /// - Parameters:
    ///   - name: target name.
    /// - Returns: targets with the given name.
    func targets(named name: String) -> [PBXTarget] {
        var targets: [PBXTarget] = []
        let filter = { (targets: [PBXObjectReference: PBXTarget]) -> [PBXTarget] in
            targets.values.filter { $0.name == name }
        }
        targets.append(contentsOf: filter(nativeTargets))
        targets.append(contentsOf: filter(legacyTargets))
        targets.append(contentsOf: filter(aggregateTargets))
        return targets
    }

    /// Invalidates all the objects references.
    func invalidateReferences() {
        forEach {
            $0.reference.invalidate()
        }
    }

    // MARK: - Computed Properties

    var buildPhases: [PBXObjectReference: PBXBuildPhase] {
        var phases: [PBXObjectReference: PBXBuildPhase] = [:]
        phases.merge(copyFilesBuildPhases as [PBXObjectReference: PBXBuildPhase], uniquingKeysWith: { first, _ in first })
        phases.merge(sourcesBuildPhases as [PBXObjectReference: PBXBuildPhase], uniquingKeysWith: { first, _ in first })
        phases.merge(shellScriptBuildPhases as [PBXObjectReference: PBXBuildPhase], uniquingKeysWith: { first, _ in first })
        phases.merge(resourcesBuildPhases as [PBXObjectReference: PBXBuildPhase], uniquingKeysWith: { first, _ in first })
        phases.merge(headersBuildPhases as [PBXObjectReference: PBXBuildPhase], uniquingKeysWith: { first, _ in first })
        phases.merge(carbonResourcesBuildPhases as [PBXObjectReference: PBXBuildPhase], uniquingKeysWith: { first, _ in first })
        phases.merge(frameworksBuildPhases as [PBXObjectReference: PBXBuildPhase], uniquingKeysWith: { first, _ in first })
        return phases
    }

    // This dictionary is used to quickly get a connection between the build phase and the build files of this phase.
    // This is used to decode build files. (we need the name of the build phase)
    // Otherwise, we would have to go through all the build phases for each file.
    var buildPhaseFile: [PBXObjectReference: PBXBuildPhaseFile] {
        let values: [[PBXBuildPhaseFile]] = buildPhases.values.map { buildPhase in
            let files = buildPhase.files
            let buildPhaseFile: [PBXBuildPhaseFile] = files?.compactMap { (file: PBXBuildFile) -> PBXBuildPhaseFile in
                PBXBuildPhaseFile(
                    buildFile: file,
                    buildPhase: buildPhase
                )
            } ?? []
            return buildPhaseFile
        }
        return Dictionary(uniqueKeysWithValues: values.flatMap { $0 }.map { ($0.buildFile.reference, $0) })
    }

    /// Runs the given closure for each of the objects that are part of the project.
    ///
    /// - Parameter closure: closure to be run.
    func forEach(_ closure: (PBXObject) -> Void) {
        buildFiles.values.forEach(closure)
        legacyTargets.values.forEach(closure)
        aggregateTargets.values.forEach(closure)
        containerItemProxies.values.forEach(closure)
        groups.values.forEach(closure)
        configurationLists.values.forEach(closure)
        versionGroups.values.forEach(closure)
        buildConfigurations.values.forEach(closure)
        variantGroups.values.forEach(closure)
        targetDependencies.values.forEach(closure)
        nativeTargets.values.forEach(closure)
        fileReferences.values.forEach(closure)
        projects.values.forEach(closure)
        referenceProxies.values.forEach(closure)
        buildRules.values.forEach(closure)
        copyFilesBuildPhases.values.forEach(closure)
        shellScriptBuildPhases.values.forEach(closure)
        resourcesBuildPhases.values.forEach(closure)
        frameworksBuildPhases.values.forEach(closure)
        headersBuildPhases.values.forEach(closure)
        sourcesBuildPhases.values.forEach(closure)
        carbonResourcesBuildPhases.values.forEach(closure)
    }
}
