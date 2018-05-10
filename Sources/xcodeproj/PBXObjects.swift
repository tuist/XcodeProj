import Foundation

public class PBXObjects: Equatable {

    // MARK: - Properties

    public var buildFiles: PBXObjectsCollection<PBXBuildFile> = [:]
    public var legacyTargets: PBXObjectsCollection<PBXLegacyTarget> = [:]
    public var aggregateTargets: PBXObjectsCollection<PBXAggregateTarget> = [:]
    public var containerItemProxies: PBXObjectsCollection<PBXContainerItemProxy> = [:]
    public var groups: PBXObjectsCollection<PBXGroup> = [:]
    public var configurationLists: PBXObjectsCollection<XCConfigurationList> = [:]
    public var versionGroups: PBXObjectsCollection<XCVersionGroup> = [:]
    public var buildConfigurations: PBXObjectsCollection<XCBuildConfiguration> = [:]
    public var variantGroups: PBXObjectsCollection<PBXVariantGroup> = [:]
    public var targetDependencies: PBXObjectsCollection<PBXTargetDependency> = [:]
    public var nativeTargets: PBXObjectsCollection<PBXNativeTarget> = [:]
    public var fileReferences: PBXObjectsCollection<PBXFileReference> = [:]
    public var projects: PBXObjectsCollection<PBXProject> = [:]
    public var referenceProxies: PBXObjectsCollection<PBXReferenceProxy> = [:]
    public var buildRules: PBXObjectsCollection<PBXBuildRule> = [:]

    // Build Phases
    public var copyFilesBuildPhases: PBXObjectsCollection<PBXCopyFilesBuildPhase> = [:]
    public var shellScriptBuildPhases: PBXObjectsCollection<PBXShellScriptBuildPhase> = [:]
    public var resourcesBuildPhases: PBXObjectsCollection<PBXResourcesBuildPhase> = [:]
    public var frameworksBuildPhases: PBXObjectsCollection<PBXFrameworksBuildPhase> = [:]
    public var headersBuildPhases: PBXObjectsCollection<PBXHeadersBuildPhase> = [:]
    public var sourcesBuildPhases: PBXObjectsCollection<PBXSourcesBuildPhase> = [:]
    public var carbonResourcesBuildPhases: PBXObjectsCollection<PBXRezBuildPhase> = [:]

    // MARK: - Computed Properties

    public var buildPhases: PBXObjectsCollection<PBXBuildPhase> {
        var phases: [PBXObjectReference: PBXBuildPhase] = [:]
        phases.merge(copyFilesBuildPhases as PBXObjectsCollection<PBXBuildPhase>, uniquingKeysWith: { first, _ in return first })
        phases.merge(sourcesBuildPhases as PBXObjectsCollection<PBXBuildPhase>, uniquingKeysWith: { first, _ in return first })
        phases.merge(shellScriptBuildPhases as PBXObjectsCollection<PBXBuildPhase>, uniquingKeysWith: { first, _ in return first })
        phases.merge(resourcesBuildPhases as PBXObjectsCollection<PBXBuildPhase>, uniquingKeysWith: { first, _ in return first })
        phases.merge(headersBuildPhases as PBXObjectsCollection<PBXBuildPhase>, uniquingKeysWith: { first, _ in return first })
        phases.merge(carbonResourcesBuildPhases as PBXObjectsCollection<PBXBuildPhase>, uniquingKeysWith: { first, _ in return first })
        phases.merge(frameworksBuildPhases as PBXObjectsCollection<PBXBuildPhase>, uniquingKeysWith: { first, _ in return first })
        return phases
    }

    /// Initializes the project objects container
    ///
    /// - Parameters:
    ///   - objects: project objects
    public init(objects: [String: PBXObject]) {
        objects.forEach { _ = self.addObject($0.value, reference: $0.key) }
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
    public func addObject(_ object: PBXObject, reference: String? = nil) -> PBXObjectReference {
        if object.reference != nil {}
        let objectReference: PBXObjectReference!
        if let reference = reference {
            objectReference = PBXObjectReference(reference, objects: self)
        } else {
            objectReference = PBXObjectReference(objects: self)
        }
        object.reference = objectReference

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

    /// It returns the object with the given reference.
    ///
    /// - Parameter reference: file reference.
    /// - Returns: object.
    // swiftlint:disable function_body_length
    public func getReference(_ reference: String) -> PBXObject? {
        // This if-let expression is used because the equivalent chain of `??` separated lookups causes,
        // with Swift 4, this compiler error:
        //     Expression was too complex to be solved in reasonable time;
        //     consider breaking up the expression into distinct sub-expressions
        if let object = buildFiles.getReference(reference) {
            return object
        } else if let object = aggregateTargets.getReference(reference) {
            return object
        } else if let object = legacyTargets.getReference(reference) {
            return object
        } else if let object = containerItemProxies.getReference(reference) {
            return object
        } else if let object = groups.getReference(reference) {
            return object
        } else if let object = configurationLists.getReference(reference) {
            return object
        } else if let object = buildConfigurations.getReference(reference) {
            return object
        } else if let object = variantGroups.getReference(reference) {
            return object
        } else if let object = targetDependencies.getReference(reference) {
            return object
        } else if let object = nativeTargets.getReference(reference) {
            return object
        } else if let object = fileReferences.getReference(reference) {
            return object
        } else if let object = projects.getReference(reference) {
            return object
        } else if let object = versionGroups.getReference(reference) {
            return object
        } else if let object = referenceProxies.getReference(reference) {
            return object
        } else if let object = copyFilesBuildPhases.getReference(reference) {
            return object
        } else if let object = shellScriptBuildPhases.getReference(reference) {
            return object
        } else if let object = resourcesBuildPhases.getReference(reference) {
            return object
        } else if let object = frameworksBuildPhases.getReference(reference) {
            return object
        } else if let object = headersBuildPhases.getReference(reference) {
            return object
        } else if let object = sourcesBuildPhases.getReference(reference) {
            return object
        } else if let object = carbonResourcesBuildPhases.getReference(reference) {
            return object
        } else if let object = buildRules.getReference(reference) {
            return object
        } else {
            return nil
        }
    }

    /// Returns true if objects contains any object with the given reference.
    ///
    /// - Parameter reference: reference.
    /// - Returns: true if it contains the reference.
    public func contains(reference: String) -> Bool {
        return getReference(reference) != nil
    }
}
