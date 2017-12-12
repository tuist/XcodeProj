import Foundation
import PathKit

/// Represents a .pbxproj file
final public class PBXProj: Decodable {
    public class Objects: Equatable {
        // MARK: - Properties
        public var buildFiles: ReferenceableCollection<PBXBuildFile> = [:]
        public var legacyTargets: ReferenceableCollection<PBXLegacyTarget> = [:]
        public var aggregateTargets: ReferenceableCollection<PBXAggregateTarget> = [:]
        public var containerItemProxies: ReferenceableCollection<PBXContainerItemProxy> = [:]
        public var groups: ReferenceableCollection<PBXGroup> = [:]
        public var configurationLists: ReferenceableCollection<XCConfigurationList> = [:]
        public var versionGroups: ReferenceableCollection<XCVersionGroup> = [:]
        public var buildConfigurations: ReferenceableCollection<XCBuildConfiguration> = [:]
        public var variantGroups: ReferenceableCollection<PBXVariantGroup> = [:]
        public var targetDependencies: ReferenceableCollection<PBXTargetDependency> = [:]
        public var nativeTargets: ReferenceableCollection<PBXNativeTarget> = [:]
        public var fileReferences: ReferenceableCollection<PBXFileReference> = [:]
        public var projects: ReferenceableCollection<PBXProject> = [:]
        public var referenceProxies: ReferenceableCollection<PBXReferenceProxy> = [:]

        // Build Phases
        public var copyFilesBuildPhases: ReferenceableCollection<PBXCopyFilesBuildPhase> = [:]
        public var shellScriptBuildPhases: ReferenceableCollection<PBXShellScriptBuildPhase> = [:]
        public var resourcesBuildPhases: ReferenceableCollection<PBXResourcesBuildPhase> = [:]
        public var frameworksBuildPhases: ReferenceableCollection<PBXFrameworksBuildPhase> = [:]
        public var headersBuildPhases: ReferenceableCollection<PBXHeadersBuildPhase> = [:]
        public var sourcesBuildPhases: ReferenceableCollection<PBXSourcesBuildPhase> = [:]

        // MARK: - Computed Properties
        public var buildPhases: ReferenceableCollection<PBXBuildPhase> {
            var phases: [String: PBXBuildPhase] = [:]
            phases.merge(self.copyFilesBuildPhases as ReferenceableCollection<PBXBuildPhase>, uniquingKeysWith: { (first, _) in return first })
            phases.merge(self.sourcesBuildPhases as ReferenceableCollection<PBXBuildPhase>, uniquingKeysWith: { (first, _) in return first })
            phases.merge(self.shellScriptBuildPhases as ReferenceableCollection<PBXBuildPhase>, uniquingKeysWith: { (first, _) in return first })
            phases.merge(self.resourcesBuildPhases as ReferenceableCollection<PBXBuildPhase>, uniquingKeysWith: { (first, _) in return first })
            phases.merge(self.headersBuildPhases as ReferenceableCollection<PBXBuildPhase>, uniquingKeysWith: { (first, _) in return first })
            return phases
        }

        /// Initializes the project objects container
        ///
        /// - Parameters:
        ///   - objects: project objects
        public init(objects: [String: PBXObject]) {
            objects.forEach { self.addObject($0.value, reference: $0.key) }
        }
        // MARK: - Equatable
        public static func == (lhs: Objects, rhs: Objects) -> Bool {
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
                lhs.referenceProxies == rhs.referenceProxies
        }

        // MARK: - Public Methods

        public func addObject(_ object: PBXObject, reference: String) {
            switch object {
            case let object as PBXBuildFile: buildFiles.append(object, reference: reference)
            case let object as PBXAggregateTarget: aggregateTargets.append(object, reference: reference)
            case let object as PBXLegacyTarget:
                legacyTargets.append(object, reference: reference)
            case let object as PBXContainerItemProxy: containerItemProxies.append(object, reference: reference)
            case let object as PBXCopyFilesBuildPhase: copyFilesBuildPhases.append(object, reference: reference)
            case let object as PBXGroup: groups.append(object, reference: reference)
            case let object as XCConfigurationList: configurationLists.append(object, reference: reference)
            case let object as XCBuildConfiguration: buildConfigurations.append(object, reference: reference)
            case let object as PBXVariantGroup: variantGroups.append(object, reference: reference)
            case let object as PBXTargetDependency: targetDependencies.append(object, reference: reference)
            case let object as PBXSourcesBuildPhase: sourcesBuildPhases.append(object, reference: reference)
            case let object as PBXShellScriptBuildPhase: shellScriptBuildPhases.append(object, reference: reference)
            case let object as PBXResourcesBuildPhase: resourcesBuildPhases.append(object, reference: reference)
            case let object as PBXFrameworksBuildPhase: frameworksBuildPhases.append(object, reference: reference)
            case let object as PBXHeadersBuildPhase: headersBuildPhases.append(object, reference: reference)
            case let object as PBXNativeTarget: nativeTargets.append(object, reference: reference)
            case let object as PBXFileReference: fileReferences.append(object, reference: reference)
            case let object as PBXProject: projects.append(object, reference: reference)
            case let object as XCVersionGroup: versionGroups.append(object, reference: reference)
            case let object as PBXReferenceProxy: referenceProxies.append(object, reference: reference)
            default: fatalError("Unhandled PBXObject type for \(object), this is likely a bug / todo")
            }
        }

        public func getTarget(reference: String) -> PBXTarget? {
            let caches: [[String: PBXTarget]] = [
                aggregateTargets,
                nativeTargets,
                legacyTargets
            ]
            return caches.first { cache in cache[reference] != nil }?[reference]
        }

        public func getFileElement(reference: String) -> PBXFileElement? {
            let caches: [[String: PBXFileElement]] = [
                fileReferences,
                groups,
                variantGroups,
                versionGroups,
                ]
            return caches.first { cache in cache[reference] != nil }?[reference]
        }

        public func getReference(_ reference: String) -> PBXObject? {
            let caches: [[String: PBXObject]] = [
                buildFiles,
                aggregateTargets,
                legacyTargets,
                containerItemProxies,
                groups,
                configurationLists,
                buildConfigurations,
                variantGroups,
                targetDependencies,
                nativeTargets,
                fileReferences,
                projects,
                versionGroups,
                referenceProxies,
                copyFilesBuildPhases,
                shellScriptBuildPhases,
                resourcesBuildPhases,
                frameworksBuildPhases,
                headersBuildPhases,
                sourcesBuildPhases
            ]
            return caches.first { cache in cache[reference] != nil }?[reference]
        }

        public func contains(reference: String) -> Bool {
            return getReference(reference) != nil
        }
    }

    // MARK: - Properties
    public let objects: Objects

    /// Project archive version.
    public var archiveVersion: Int

    /// Project object version.
    public var objectVersion: Int

    /// Project classes.
    public var classes: [String: Any]

    /// Project root object.
    public var rootObject: String

    /// Initializes the project with its attributes.
    ///
    /// - Parameters:
    ///   - objectVersion: project object version.
    ///   - rootObject: project root object.
    ///   - archiveVersion: project archive version.
    ///   - classes: project classes.
    ///   - objects: project objects
    public init(objectVersion: Int,
                rootObject: String,
                archiveVersion: Int = 1,
                classes: [String: Any] = [:],
                objects: [String: PBXObject] = [:]) {
        self.archiveVersion = archiveVersion
        self.objectVersion = objectVersion
        self.classes = classes
        self.rootObject = rootObject
        self.objects = Objects(objects: objects)
    }

    // MARK: - Decodable
    
    fileprivate enum CodingKeys: String, CodingKey {
        case archiveVersion
        case objectVersion
        case classes
        case objects
        case rootObject
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let archiveVersionString: String? = try container.decodeIfPresent(.archiveVersion)
        self.archiveVersion = archiveVersionString.flatMap(Int.init) ?? 1
        let objectVersionString: String = try container.decode(.objectVersion)
        self.objectVersion = Int(objectVersionString) ?? 0
        self.rootObject = try container.decode(.rootObject)
        self.classes = try container.decodeIfPresent([String: Any].self, forKey: .classes) ?? [:]        
        let objectsDictionary: [String: Any] = try container.decodeIfPresent([String: Any].self, forKey: .objects) ?? [:]
        let objects: [String: [String: Any]] = (objectsDictionary as? [String: [String: Any]]) ?? [:]
        self.objects = try Objects(objects: objects.mapValuesWithKeys({ try PBXObject.parse(reference: $0, dictionary: $1) }))
    }
}

// MARK: - PBXProj Extension (Equatable)

extension PBXProj: Equatable {

    public static func == (lhs: PBXProj, rhs: PBXProj) -> Bool {
        let equalClasses = NSDictionary(dictionary: lhs.classes).isEqual(to: rhs.classes)
        return lhs.archiveVersion == rhs.archiveVersion &&
            lhs.objectVersion == rhs.objectVersion &&
            equalClasses &&
            lhs.objects == rhs.objects
    }
}
