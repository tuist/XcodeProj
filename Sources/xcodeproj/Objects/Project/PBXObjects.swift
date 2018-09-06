import Foundation

// swiftlint:disable type_body_length
public class PBXObjects: Equatable {
    // TODO: Change the objects to not expose object references.

    // MARK: - Properties

    public var projects: [PBXObjectReference: PBXProject] = [:]
    public var referenceProxies: [PBXObjectReference: PBXReferenceProxy] = [:]

    // File elements
    public var fileReferences: [PBXObjectReference: PBXFileReference] = [:]
    public var versionGroups: [PBXObjectReference: XCVersionGroup] = [:]
    public var variantGroups: [PBXObjectReference: PBXVariantGroup] = [:]
    public var groups: [PBXObjectReference: PBXGroup] = [:]

    // Configuration
    public var buildConfigurations: [PBXObjectReference: XCBuildConfiguration] = [:]
    public var configurationLists: [PBXObjectReference: XCConfigurationList] = [:]

    // Targets
    public var legacyTargets: [PBXObjectReference: PBXLegacyTarget] = [:]
    public var aggregateTargets: [PBXObjectReference: PBXAggregateTarget] = [:]
    public var nativeTargets: [PBXObjectReference: PBXNativeTarget] = [:]
    public var targetDependencies: [PBXObjectReference: PBXTargetDependency] = [:]
    public var containerItemProxies: [PBXObjectReference: PBXContainerItemProxy] = [:]
    public var buildRules: [PBXObjectReference: PBXBuildRule] = [:]

    // Build Phases
    public var buildFiles: [PBXObjectReference: PBXBuildFile] = [:]
    public var copyFilesBuildPhases: [PBXObjectReference: PBXCopyFilesBuildPhase] = [:]
    public var shellScriptBuildPhases: [PBXObjectReference: PBXShellScriptBuildPhase] = [:]
    public var resourcesBuildPhases: [PBXObjectReference: PBXResourcesBuildPhase] = [:]
    public var frameworksBuildPhases: [PBXObjectReference: PBXFrameworksBuildPhase] = [:]
    public var headersBuildPhases: [PBXObjectReference: PBXHeadersBuildPhase] = [:]
    public var sourcesBuildPhases: [PBXObjectReference: PBXSourcesBuildPhase] = [:]
    public var carbonResourcesBuildPhases: [PBXObjectReference: PBXRezBuildPhase] = [:]

    /// Initializes the project objects container
    ///
    /// - Parameters:
    ///   - objects: project objects
    public init(objects: [PBXObject] = []) {
        objects.forEach { _ = self.addObject($0) }
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

    // MARK: - Public Methods

    /// Add a new object.
    ///
    /// - Parameters:
    ///   - object: object.
    ///   - reference: object reference.
    @discardableResult
    public func addObject(_ object: PBXObject) -> PBXObjectReference {
        let objectReference: PBXObjectReference = object.reference
        objectReference.objects = self

        switch object {
        // subclasses of PBXGroup; must be tested before PBXGroup
        case let object as PBXVariantGroup: variantGroups[objectReference] = object
        case let object as XCVersionGroup: versionGroups[objectReference] = object

        // everything else
        case let object as PBXBuildFile: buildFiles[objectReference] = object
        case let object as PBXAggregateTarget: aggregateTargets[objectReference] = object
        case let object as PBXLegacyTarget: legacyTargets[objectReference] = object
        case let object as PBXContainerItemProxy: containerItemProxies[objectReference] = object
        case let object as PBXCopyFilesBuildPhase: copyFilesBuildPhases[objectReference] = object
        case let object as PBXGroup: groups[objectReference] = object
        case let object as XCConfigurationList: configurationLists[objectReference] = object
        case let object as XCBuildConfiguration: buildConfigurations[objectReference] = object
        case let object as PBXTargetDependency: targetDependencies[objectReference] = object
        case let object as PBXSourcesBuildPhase: sourcesBuildPhases[objectReference] = object
        case let object as PBXShellScriptBuildPhase: shellScriptBuildPhases[objectReference] = object
        case let object as PBXResourcesBuildPhase: resourcesBuildPhases[objectReference] = object
        case let object as PBXFrameworksBuildPhase: frameworksBuildPhases[objectReference] = object
        case let object as PBXHeadersBuildPhase: headersBuildPhases[objectReference] = object
        case let object as PBXNativeTarget: nativeTargets[objectReference] = object
        case let object as PBXFileReference: fileReferences[objectReference] = object
        case let object as PBXProject: projects[objectReference] = object
        case let object as PBXReferenceProxy: referenceProxies[objectReference] = object
        case let object as PBXRezBuildPhase: carbonResourcesBuildPhases[objectReference] = object
        case let object as PBXBuildRule: buildRules[objectReference] = object
        default: fatalError("Unhandled PBXObject type for \(object), this is likely a bug / todo")
        }
        return objectReference
    }

    /// Deletes the object with the given reference.
    ///
    /// - Parameter reference: referenc of the object to be deleted.
    /// - Returns: the deleted object.
    // swiftlint:disable:next function_body_length
    public func delete(_ reference: PBXObjectReference) -> PBXObject? {
        if let index = buildFiles.index(forKey: reference) {
            return buildFiles.remove(at: index).value
        } else if let index = aggregateTargets.index(forKey: reference) {
            return aggregateTargets.remove(at: index).value
        } else if let index = legacyTargets.index(forKey: reference) {
            return legacyTargets.remove(at: index).value
        } else if let index = containerItemProxies.index(forKey: reference) {
            return containerItemProxies.remove(at: index).value
        } else if let index = groups.index(forKey: reference) {
            return groups.remove(at: index).value
        } else if let index = configurationLists.index(forKey: reference) {
            return configurationLists.remove(at: index).value
        } else if let index = buildConfigurations.index(forKey: reference) {
            return buildConfigurations.remove(at: index).value
        } else if let index = variantGroups.index(forKey: reference) {
            return variantGroups.remove(at: index).value
        } else if let index = targetDependencies.index(forKey: reference) {
            return targetDependencies.remove(at: index).value
        } else if let index = nativeTargets.index(forKey: reference) {
            return nativeTargets.remove(at: index).value
        } else if let index = fileReferences.index(forKey: reference) {
            return fileReferences.remove(at: index).value
        } else if let index = projects.index(forKey: reference) {
            return projects.remove(at: index).value
        } else if let index = versionGroups.index(forKey: reference) {
            return versionGroups.remove(at: index).value
        } else if let index = referenceProxies.index(forKey: reference) {
            return referenceProxies.remove(at: index).value
        } else if let index = copyFilesBuildPhases.index(forKey: reference) {
            return copyFilesBuildPhases.remove(at: index).value
        } else if let index = shellScriptBuildPhases.index(forKey: reference) {
            return shellScriptBuildPhases.remove(at: index).value
        } else if let index = resourcesBuildPhases.index(forKey: reference) {
            return resourcesBuildPhases.remove(at: index).value
        } else if let index = frameworksBuildPhases.index(forKey: reference) {
            return frameworksBuildPhases.remove(at: index).value
        } else if let index = headersBuildPhases.index(forKey: reference) {
            return headersBuildPhases.remove(at: index).value
        } else if let index = sourcesBuildPhases.index(forKey: reference) {
            return sourcesBuildPhases.remove(at: index).value
        } else if let index = carbonResourcesBuildPhases.index(forKey: reference) {
            return carbonResourcesBuildPhases.remove(at: index).value
        } else if let index = buildRules.index(forKey: reference) {
            return buildRules.remove(at: index).value
        }
        return nil
    }

    /// It returns the object with the given reference.
    ///
    /// - Parameter reference: Xcode reference.
    /// - Returns: object.
    // swiftlint:disable function_body_length
    public func get(_ reference: PBXObjectReference) -> PBXObject? {
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

// MARK: - Helpers

public extension PBXObjects {
    /// Returns all the targets with the given name.
    ///
    /// - Parameters:
    ///   - name: target name.
    /// - Returns: targets with the given name.
    public func targets(named name: String) -> [PBXTarget] {
        var targets: [PBXTarget] = []
        targets.append(contentsOf: nativeTargets.values.map({ $0 as PBXTarget }))
        targets.append(contentsOf: legacyTargets.values.map({ $0 as PBXTarget }))
        targets.append(contentsOf: aggregateTargets.values.map({ $0 as PBXTarget }))
        return targets.filter { $0.name == name }
    }

    /// Invalidates all the objects references.
    public func invalidateReferences() {
        forEach {
            $0.reference.invalidate()
        }
    }

    // MARK: - Computed Properties

    public var buildPhases: [PBXObjectReference: PBXBuildPhase] {
        var phases: [PBXObjectReference: PBXBuildPhase] = [:]
        phases.merge(copyFilesBuildPhases as [PBXObjectReference: PBXBuildPhase], uniquingKeysWith: { first, _ in return first })
        phases.merge(sourcesBuildPhases as [PBXObjectReference: PBXBuildPhase], uniquingKeysWith: { first, _ in return first })
        phases.merge(shellScriptBuildPhases as [PBXObjectReference: PBXBuildPhase], uniquingKeysWith: { first, _ in return first })
        phases.merge(resourcesBuildPhases as [PBXObjectReference: PBXBuildPhase], uniquingKeysWith: { first, _ in return first })
        phases.merge(headersBuildPhases as [PBXObjectReference: PBXBuildPhase], uniquingKeysWith: { first, _ in return first })
        phases.merge(carbonResourcesBuildPhases as [PBXObjectReference: PBXBuildPhase], uniquingKeysWith: { first, _ in return first })
        phases.merge(frameworksBuildPhases as [PBXObjectReference: PBXBuildPhase], uniquingKeysWith: { first, _ in return first })
        return phases
    }

    /// Runs the given closure for each of the objects that are part of the project.
    ///
    /// - Parameter closure: closure to be run.
    public func forEach(_ closure: (PBXObject) -> Void) {
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
