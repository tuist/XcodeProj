import Foundation

// swiftlint:disable type_body_length
class PBXObjects: Equatable {
    // MARK: - Properties

    private let lock = NSRecursiveLock()

    private var _projects: [PBXObjectReference: PBXProject] = [:]
    var projects: [PBXObjectReference: PBXProject] {
        lock.whileLocked { _projects }
    }

    private var _referenceProxies: [PBXObjectReference: PBXReferenceProxy] = [:]
    var referenceProxies: [PBXObjectReference: PBXReferenceProxy] {
        lock.whileLocked { _referenceProxies }
    }

    // File elements
    private var _fileReferences: [PBXObjectReference: PBXFileReference] = [:]
    var fileReferences: [PBXObjectReference: PBXFileReference] {
        lock.whileLocked { _fileReferences }
    }

    private var _versionGroups: [PBXObjectReference: XCVersionGroup] = [:]
    var versionGroups: [PBXObjectReference: XCVersionGroup] {
        lock.whileLocked { _versionGroups }
    }

    private var _variantGroups: [PBXObjectReference: PBXVariantGroup] = [:]
    var variantGroups: [PBXObjectReference: PBXVariantGroup] {
        lock.whileLocked { _variantGroups }
    }

    private var _groups: [PBXObjectReference: PBXGroup] = [:]
    var groups: [PBXObjectReference: PBXGroup] {
        lock.whileLocked { _groups }
    }

    // Configuration
    private var _buildConfigurations: [PBXObjectReference: XCBuildConfiguration] = [:]
    var buildConfigurations: [PBXObjectReference: XCBuildConfiguration] {
        lock.whileLocked { _buildConfigurations }
    }

    private var _configurationLists: [PBXObjectReference: XCConfigurationList] = [:]
    var configurationLists: [PBXObjectReference: XCConfigurationList] {
        lock.whileLocked { _configurationLists }
    }

    // Targets
    private var _legacyTargets: [PBXObjectReference: PBXLegacyTarget] = [:]
    var legacyTargets: [PBXObjectReference: PBXLegacyTarget] {
        lock.whileLocked { _legacyTargets }
    }

    private var _aggregateTargets: [PBXObjectReference: PBXAggregateTarget] = [:]
    var aggregateTargets: [PBXObjectReference: PBXAggregateTarget] {
        lock.whileLocked { _aggregateTargets }
    }

    private var _nativeTargets: [PBXObjectReference: PBXNativeTarget] = [:]
    var nativeTargets: [PBXObjectReference: PBXNativeTarget] {
        lock.whileLocked { _nativeTargets }
    }

    private var _targetDependencies: [PBXObjectReference: PBXTargetDependency] = [:]
    var targetDependencies: [PBXObjectReference: PBXTargetDependency] {
        lock.whileLocked { _targetDependencies }
    }

    private var _containerItemProxies: [PBXObjectReference: PBXContainerItemProxy] = [:]
    var containerItemProxies: [PBXObjectReference: PBXContainerItemProxy] {
        lock.whileLocked { _containerItemProxies }
    }

    private var _buildRules: [PBXObjectReference: PBXBuildRule] = [:]
    var buildRules: [PBXObjectReference: PBXBuildRule] {
        lock.whileLocked { _buildRules }
    }

    // Build Phases
    private var _buildFiles: [PBXObjectReference: PBXBuildFile] = [:]
    var buildFiles: [PBXObjectReference: PBXBuildFile] {
        lock.whileLocked { _buildFiles }
    }

    private var _copyFilesBuildPhases: [PBXObjectReference: PBXCopyFilesBuildPhase] = [:]
    var copyFilesBuildPhases: [PBXObjectReference: PBXCopyFilesBuildPhase] {
        lock.whileLocked { _copyFilesBuildPhases }
    }

    private var _shellScriptBuildPhases: [PBXObjectReference: PBXShellScriptBuildPhase] = [:]
    var shellScriptBuildPhases: [PBXObjectReference: PBXShellScriptBuildPhase] {
        lock.whileLocked { _shellScriptBuildPhases }
    }

    private var _resourcesBuildPhases: [PBXObjectReference: PBXResourcesBuildPhase] = [:]
    var resourcesBuildPhases: [PBXObjectReference: PBXResourcesBuildPhase] {
        lock.whileLocked { _resourcesBuildPhases }
    }

    private var _frameworksBuildPhases: [PBXObjectReference: PBXFrameworksBuildPhase] = [:]
    var frameworksBuildPhases: [PBXObjectReference: PBXFrameworksBuildPhase] {
        lock.whileLocked { _frameworksBuildPhases }
    }

    private var _headersBuildPhases: [PBXObjectReference: PBXHeadersBuildPhase] = [:]
    var headersBuildPhases: [PBXObjectReference: PBXHeadersBuildPhase] {
        lock.whileLocked { _headersBuildPhases }
    }

    private var _sourcesBuildPhases: [PBXObjectReference: PBXSourcesBuildPhase] = [:]
    var sourcesBuildPhases: [PBXObjectReference: PBXSourcesBuildPhase] {
        lock.whileLocked { _sourcesBuildPhases }
    }

    private var _carbonResourcesBuildPhases: [PBXObjectReference: PBXRezBuildPhase] = [:]
    var carbonResourcesBuildPhases: [PBXObjectReference: PBXRezBuildPhase] {
        lock.whileLocked { _carbonResourcesBuildPhases }
    }

    private var _remoteSwiftPackageReferences: [PBXObjectReference: XCRemoteSwiftPackageReference] = [:]
    var remoteSwiftPackageReferences: [PBXObjectReference: XCRemoteSwiftPackageReference] {
        lock.whileLocked { _remoteSwiftPackageReferences }
    }

    private var _localSwiftPackageReferences: [PBXObjectReference: XCLocalSwiftPackageReference] = [:]
    var localSwiftPackageReferences: [PBXObjectReference: XCLocalSwiftPackageReference] {
        lock.whileLocked { _localSwiftPackageReferences }
    }

    private var _swiftPackageProductDependencies: [PBXObjectReference: XCSwiftPackageProductDependency] = [:]
    var swiftPackageProductDependencies: [PBXObjectReference: XCSwiftPackageProductDependency] {
        lock.whileLocked { _swiftPackageProductDependencies }
    }

    private var _fileSystemSynchronizedRootGroups: [PBXObjectReference: PBXFileSystemSynchronizedRootGroup] = [:]
    var fileSystemSynchronizedRootGroups: [PBXObjectReference: PBXFileSystemSynchronizedRootGroup] {
        lock.whileLocked { _fileSystemSynchronizedRootGroups }
    }

    private var _fileSystemSynchronizedBuildFileExceptionSets: [PBXObjectReference: PBXFileSystemSynchronizedBuildFileExceptionSet] = [:]
    var fileSystemSynchronizedBuildFileExceptionSets: [PBXObjectReference: PBXFileSystemSynchronizedBuildFileExceptionSet] {
        lock.whileLocked { _fileSystemSynchronizedBuildFileExceptionSets }
    }

    private var _fileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet: [PBXObjectReference: PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet] = [:]
    var fileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet: [PBXObjectReference: PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet] {
        lock.whileLocked { _fileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet }
    }

    // XCSwiftPackageProductDependency

    /// Initializes the project objects container
    ///
    /// - Parameters:
    ///   - objects: project objects
    init(objects: [PBXObject] = []) {
        for item in objects {
            add(object: item)
        }
    }

    // MARK: - Equatable

    public static func == (lhs: PBXObjects, rhs: PBXObjects) -> Bool {
        lhs.buildFiles == rhs.buildFiles &&
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
            lhs.buildRules == rhs.buildRules &&
            lhs.swiftPackageProductDependencies == rhs._swiftPackageProductDependencies &&
            lhs.remoteSwiftPackageReferences == rhs.remoteSwiftPackageReferences &&
            lhs.localSwiftPackageReferences == rhs.localSwiftPackageReferences &&
            lhs.fileSystemSynchronizedRootGroups == rhs.fileSystemSynchronizedRootGroups &&
            lhs.fileSystemSynchronizedBuildFileExceptionSets == rhs.fileSystemSynchronizedBuildFileExceptionSets &&
            lhs.fileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet == rhs.fileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet
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
        update(object, reference: objectReference, inserting: true)
    }

    /// Removes the object stored under `reference` from the collection that objects of `object`'s type belong to.
    /// Unlike `delete(reference:)`, it doesn't probe every collection.
    ///
    /// - Returns: the removed object, or nil when that collection has nothing under `reference`.
    func remove(reference: PBXObjectReference, typeOf object: PBXObject) -> PBXObject? {
        lock.lock()
        defer { lock.unlock() }
        return update(object, reference: reference, inserting: false)
    }

    /// Inserts `object` under `reference` into the collection its type belongs to, or removes what that collection
    /// stores under `reference`, so `add` and `remove` always agree on the collection.
    @discardableResult private func update(
        _ object: PBXObject,
        reference: PBXObjectReference,
        inserting: Bool
    ) -> PBXObject? {
        func update<T: PBXObject>(_ objects: inout [PBXObjectReference: T], _ object: T) -> PBXObject? {
            if inserting {
                objects[reference] = object
                return object
            }
            return objects.removeValue(forKey: reference)
        }

        switch object {
        // subclasses of PBXGroup; must be tested before PBXGroup
        case let object as PBXVariantGroup: return update(&_variantGroups, object)
        case let object as XCVersionGroup: return update(&_versionGroups, object)
        // everything else
        case let object as PBXBuildFile: return update(&_buildFiles, object)
        case let object as PBXAggregateTarget: return update(&_aggregateTargets, object)
        case let object as PBXLegacyTarget: return update(&_legacyTargets, object)
        case let object as PBXContainerItemProxy: return update(&_containerItemProxies, object)
        case let object as PBXCopyFilesBuildPhase: return update(&_copyFilesBuildPhases, object)
        case let object as PBXGroup: return update(&_groups, object)
        case let object as XCConfigurationList: return update(&_configurationLists, object)
        case let object as XCBuildConfiguration: return update(&_buildConfigurations, object)
        case let object as PBXTargetDependency: return update(&_targetDependencies, object)
        case let object as PBXSourcesBuildPhase: return update(&_sourcesBuildPhases, object)
        case let object as PBXShellScriptBuildPhase: return update(&_shellScriptBuildPhases, object)
        case let object as PBXResourcesBuildPhase: return update(&_resourcesBuildPhases, object)
        case let object as PBXFrameworksBuildPhase: return update(&_frameworksBuildPhases, object)
        case let object as PBXHeadersBuildPhase: return update(&_headersBuildPhases, object)
        case let object as PBXNativeTarget: return update(&_nativeTargets, object)
        case let object as PBXFileReference: return update(&_fileReferences, object)
        case let object as PBXProject: return update(&_projects, object)
        case let object as PBXReferenceProxy: return update(&_referenceProxies, object)
        case let object as PBXRezBuildPhase: return update(&_carbonResourcesBuildPhases, object)
        case let object as PBXBuildRule: return update(&_buildRules, object)
        case let object as XCRemoteSwiftPackageReference: return update(&_remoteSwiftPackageReferences, object)
        case let object as XCLocalSwiftPackageReference: return update(&_localSwiftPackageReferences, object)
        case let object as XCSwiftPackageProductDependency: return update(&_swiftPackageProductDependencies, object)
        case let object as PBXFileSystemSynchronizedRootGroup: return update(&_fileSystemSynchronizedRootGroups, object)
        case let object as PBXFileSystemSynchronizedBuildFileExceptionSet: return update(&_fileSystemSynchronizedBuildFileExceptionSets, object)
        case let object as PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet:
            return update(&_fileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet, object)
        default:
            // Objects of these types are never added, so there is nothing to remove.
            guard inserting else { return nil }
            fatalError("Unhandled PBXObject type for \(object), this is likely a bug / todo")
        }
    }

    /// Deletes the object with the given reference.
    ///
    /// - Parameter reference: referenc of the object to be deleted.
    /// - Returns: the deleted object.
    // swiftlint:disable:next function_body_length Note: SwiftLint doesn't disable if @discardable and the function are on different lines.
    @discardableResult func delete(reference: PBXObjectReference) -> PBXObject? {
        lock.lock()
        defer { lock.unlock() }
        if let index = buildFiles.index(forKey: reference) {
            return _buildFiles.remove(at: index).value
        } else if let index = aggregateTargets.index(forKey: reference) {
            return _aggregateTargets.remove(at: index).value
        } else if let index = legacyTargets.index(forKey: reference) {
            return _legacyTargets.remove(at: index).value
        } else if let index = containerItemProxies.index(forKey: reference) {
            return _containerItemProxies.remove(at: index).value
        } else if let index = groups.index(forKey: reference) {
            return _groups.remove(at: index).value
        } else if let index = configurationLists.index(forKey: reference) {
            return _configurationLists.remove(at: index).value
        } else if let index = buildConfigurations.index(forKey: reference) {
            return _buildConfigurations.remove(at: index).value
        } else if let index = variantGroups.index(forKey: reference) {
            return _variantGroups.remove(at: index).value
        } else if let index = targetDependencies.index(forKey: reference) {
            return _targetDependencies.remove(at: index).value
        } else if let index = nativeTargets.index(forKey: reference) {
            return _nativeTargets.remove(at: index).value
        } else if let index = fileReferences.index(forKey: reference) {
            return _fileReferences.remove(at: index).value
        } else if let index = projects.index(forKey: reference) {
            return _projects.remove(at: index).value
        } else if let index = versionGroups.index(forKey: reference) {
            return _versionGroups.remove(at: index).value
        } else if let index = referenceProxies.index(forKey: reference) {
            return _referenceProxies.remove(at: index).value
        } else if let index = copyFilesBuildPhases.index(forKey: reference) {
            return _copyFilesBuildPhases.remove(at: index).value
        } else if let index = shellScriptBuildPhases.index(forKey: reference) {
            return _shellScriptBuildPhases.remove(at: index).value
        } else if let index = resourcesBuildPhases.index(forKey: reference) {
            return _resourcesBuildPhases.remove(at: index).value
        } else if let index = frameworksBuildPhases.index(forKey: reference) {
            return _frameworksBuildPhases.remove(at: index).value
        } else if let index = headersBuildPhases.index(forKey: reference) {
            return _headersBuildPhases.remove(at: index).value
        } else if let index = sourcesBuildPhases.index(forKey: reference) {
            return _sourcesBuildPhases.remove(at: index).value
        } else if let index = carbonResourcesBuildPhases.index(forKey: reference) {
            return _carbonResourcesBuildPhases.remove(at: index).value
        } else if let index = buildRules.index(forKey: reference) {
            return _buildRules.remove(at: index).value
        } else if let index = remoteSwiftPackageReferences.index(forKey: reference) {
            return _remoteSwiftPackageReferences.remove(at: index).value
        } else if let index = localSwiftPackageReferences.index(forKey: reference) {
            return _localSwiftPackageReferences.remove(at: index).value
        } else if let index = swiftPackageProductDependencies.index(forKey: reference) {
            return _swiftPackageProductDependencies.remove(at: index).value
        } else if let index = fileSystemSynchronizedRootGroups.index(forKey: reference) {
            return _fileSystemSynchronizedRootGroups.remove(at: index).value
        } else if let index = fileSystemSynchronizedBuildFileExceptionSets.index(forKey: reference) {
            return _fileSystemSynchronizedBuildFileExceptionSets.remove(at: index).value
        } else if let index = fileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet.index(forKey: reference) {
            return _fileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet.remove(at: index).value
        }

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
            object
        } else if let object = aggregateTargets[reference] {
            object
        } else if let object = legacyTargets[reference] {
            object
        } else if let object = containerItemProxies[reference] {
            object
        } else if let object = groups[reference] {
            object
        } else if let object = configurationLists[reference] {
            object
        } else if let object = buildConfigurations[reference] {
            object
        } else if let object = variantGroups[reference] {
            object
        } else if let object = targetDependencies[reference] {
            object
        } else if let object = nativeTargets[reference] {
            object
        } else if let object = fileReferences[reference] {
            object
        } else if let object = projects[reference] {
            object
        } else if let object = versionGroups[reference] {
            object
        } else if let object = referenceProxies[reference] {
            object
        } else if let object = copyFilesBuildPhases[reference] {
            object
        } else if let object = shellScriptBuildPhases[reference] {
            object
        } else if let object = resourcesBuildPhases[reference] {
            object
        } else if let object = frameworksBuildPhases[reference] {
            object
        } else if let object = headersBuildPhases[reference] {
            object
        } else if let object = sourcesBuildPhases[reference] {
            object
        } else if let object = carbonResourcesBuildPhases[reference] {
            object
        } else if let object = buildRules[reference] {
            object
        } else if let object = remoteSwiftPackageReferences[reference] {
            object
        } else if let object = localSwiftPackageReferences[reference] {
            object
        } else if let object = swiftPackageProductDependencies[reference] {
            object
        } else if let object = fileSystemSynchronizedRootGroups[reference] {
            object
        } else if let object = fileSystemSynchronizedBuildFileExceptionSets[reference] {
            object
        } else if let object = fileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet[reference] {
            object
        } else {
            nil
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
        // A build file listed by several phases maps to the first of them. Visiting the phases and files backwards lets
        // each entry be overwritten without checking it first, so the first occurrence is the one that stays.
        var buildPhaseFile = [PBXObjectReference: PBXBuildPhaseFile](minimumCapacity: buildFiles.count)
        for buildPhase in buildPhases.values.reversed() {
            for file in (buildPhase.files ?? []).reversed() {
                buildPhaseFile[file.reference] = PBXBuildPhaseFile(buildFile: file, buildPhase: buildPhase)
            }
        }
        return buildPhaseFile
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
        remoteSwiftPackageReferences.values.forEach(closure)
        localSwiftPackageReferences.values.forEach(closure)
        swiftPackageProductDependencies.values.forEach(closure)
        fileSystemSynchronizedRootGroups.values.forEach(closure)
        fileSystemSynchronizedBuildFileExceptionSets.values.forEach(closure)
        fileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet.values.forEach(closure)
    }
}
