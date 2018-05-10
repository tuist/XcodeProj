import Foundation

public class PBXObjects: Equatable {

    // MARK: - Properties

    public var buildFiles: [PBXObjectReference: PBXBuildFile] = [:]
    public var legacyTargets: [PBXObjectReference: PBXLegacyTarget] = [:]
    public var aggregateTargets: [PBXObjectReference: PBXAggregateTarget] = [:]
    public var containerItemProxies: [PBXObjectReference: PBXContainerItemProxy] = [:]
    public var groups: [PBXObjectReference: PBXGroup] = [:]
    public var configurationLists: [PBXObjectReference: XCConfigurationList] = [:]
    public var versionGroups: [PBXObjectReference: XCVersionGroup] = [:]
    public var buildConfigurations: [PBXObjectReference: XCBuildConfiguration] = [:]
    public var variantGroups: [PBXObjectReference: PBXVariantGroup] = [:]
    public var targetDependencies: [PBXObjectReference: PBXTargetDependency] = [:]
    public var nativeTargets: [PBXObjectReference: PBXNativeTarget] = [:]
    public var fileReferences: [PBXObjectReference: PBXFileReference] = [:]
    public var projects: [PBXObjectReference: PBXProject] = [:]
    public var referenceProxies: [PBXObjectReference: PBXReferenceProxy] = [:]
    public var buildRules: [PBXObjectReference: PBXBuildRule] = [:]

    // Build Phases
    public var copyFilesBuildPhases: [PBXObjectReference: PBXCopyFilesBuildPhase] = [:]
    public var shellScriptBuildPhases: [PBXObjectReference: PBXShellScriptBuildPhase] = [:]
    public var resourcesBuildPhases: [PBXObjectReference: PBXResourcesBuildPhase] = [:]
    public var frameworksBuildPhases: [PBXObjectReference: PBXFrameworksBuildPhase] = [:]
    public var headersBuildPhases: [PBXObjectReference: PBXHeadersBuildPhase] = [:]
    public var sourcesBuildPhases: [PBXObjectReference: PBXSourcesBuildPhase] = [:]
    public var carbonResourcesBuildPhases: [PBXObjectReference: PBXRezBuildPhase] = [:]

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
    public func addObject(_ object: PBXObject, reference _: String? = nil) -> PBXObjectReference {
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
}
