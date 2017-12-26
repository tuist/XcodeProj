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
        public var buildRules: ReferenceableCollection<PBXBuildRule> = [:]

        // Build Phases
        public var copyFilesBuildPhases: ReferenceableCollection<PBXCopyFilesBuildPhase> = [:]
        public var shellScriptBuildPhases: ReferenceableCollection<PBXShellScriptBuildPhase> = [:]
        public var resourcesBuildPhases: ReferenceableCollection<PBXResourcesBuildPhase> = [:]
        public var frameworksBuildPhases: ReferenceableCollection<PBXFrameworksBuildPhase> = [:]
        public var headersBuildPhases: ReferenceableCollection<PBXHeadersBuildPhase> = [:]
        public var sourcesBuildPhases: ReferenceableCollection<PBXSourcesBuildPhase> = [:]
        public var carbonResourcesBuildPhases: ReferenceableCollection<PBXRezBuildPhase> = [:]

        // MARK: - Computed Properties
        public var buildPhases: ReferenceableCollection<PBXBuildPhase> {
            var phases: [PBXBuildPhase] = []
            phases += self.copyFilesBuildPhases.referenceValues as [PBXBuildPhase]
            phases += self.sourcesBuildPhases.referenceValues as [PBXBuildPhase]
            phases += self.shellScriptBuildPhases.referenceValues as [PBXBuildPhase]
            phases += self.resourcesBuildPhases.referenceValues as [PBXBuildPhase]
            phases += self.frameworksBuildPhases.referenceValues as [PBXBuildPhase]
            phases += self.headersBuildPhases.referenceValues as [PBXBuildPhase]
            phases += self.carbonResourcesBuildPhases.referenceValues as [PBXBuildPhase]
            return Dictionary(references: phases)
        }

        /// Initializes the project objects container
        ///
        /// - Parameters:
        ///   - objects: project objects
        public init(objects: [PBXObject]) {
            objects.forEach(addObject)
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
                lhs.referenceProxies == rhs.referenceProxies &&
                lhs.carbonResourcesBuildPhases == rhs.carbonResourcesBuildPhases &&
                lhs.buildRules == rhs.buildRules
        }

        // MARK: - Public Methods

        public func addObject(_ object: PBXObject) {
            switch object {
            case let object as PBXBuildFile: buildFiles.append(object)
            case let object as PBXAggregateTarget: aggregateTargets.append(object)
            case let object as PBXLegacyTarget:
                legacyTargets.append(object)
            case let object as PBXContainerItemProxy: containerItemProxies.append(object)
            case let object as PBXCopyFilesBuildPhase: copyFilesBuildPhases.append(object)
            case let object as PBXGroup: groups.append(object)
            case let object as XCConfigurationList: configurationLists.append(object)
            case let object as XCBuildConfiguration: buildConfigurations.append(object)
            case let object as PBXVariantGroup: variantGroups.append(object)
            case let object as PBXTargetDependency: targetDependencies.append(object)
            case let object as PBXSourcesBuildPhase: sourcesBuildPhases.append(object)
            case let object as PBXShellScriptBuildPhase: shellScriptBuildPhases.append(object)
            case let object as PBXResourcesBuildPhase: resourcesBuildPhases.append(object)
            case let object as PBXFrameworksBuildPhase: frameworksBuildPhases.append(object)
            case let object as PBXHeadersBuildPhase: headersBuildPhases.append(object)
            case let object as PBXNativeTarget: nativeTargets.append(object)
            case let object as PBXFileReference: fileReferences.append(object)
            case let object as PBXProject: projects.append(object)
            case let object as XCVersionGroup: versionGroups.append(object)
            case let object as PBXReferenceProxy: referenceProxies.append(object)
            case let object as PBXRezBuildPhase: carbonResourcesBuildPhases.append(object)
            case let object as PBXBuildRule: buildRules.append(object)
            default: fatalError("Unhandled PBXObject type for \(object), this is likely a bug / todo")
            }
        }

        public func getTarget(reference: String) -> PBXTarget? {
            return aggregateTargets[reference] ??
                nativeTargets[reference] ??
                legacyTargets[reference]
        }

        public func getFileElement(reference: String) -> PBXFileElement? {
            return fileReferences[reference] ??
                groups[reference] ??
                variantGroups[reference] ??
                versionGroups[reference]
        }

        public func getReference(_ reference: String) -> PBXObject? {
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
                objects: [PBXObject] = []) {
        self.archiveVersion = archiveVersion
        self.objectVersion = objectVersion
        self.classes = classes
        self.rootObject = rootObject
        self.objects = Objects(objects: objects)
    }

    @available(*, deprecated, message: "Use objects.addObject instead") public func addObject(_ object: PBXObject) {
        objects.addObject(object)
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
        self.objects = try Objects(objects: objects.flatMap { try PBXObject.parse(reference: $0.key, dictionary: $0.value) })
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
