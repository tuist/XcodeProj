import Foundation
import PathKit

/// Represents a .pbxproj file
public class PBXProj: Decodable {

    // MARK: - Properties

    /// Project archive version.
    public var archiveVersion: Int?

    /// Project object version.
    public var objectVersion: Int

    /// Project classes.
    public var classes: [String: Any]

    /// Project root object.
    public var rootObject: String

    public var buildFiles: [PBXBuildFile] = []
    public var aggregateTargets: [PBXAggregateTarget] = []
    public var containerItemProxies: [PBXContainerItemProxy] = []
    public var copyFilesBuildPhases: [PBXCopyFilesBuildPhase] = []
    public var groups: [PBXGroup] = []
    public var fileElements: [PBXFileElement] = []
    public var configurationLists: [XCConfigurationList] = []
    public var versionGroups: [XCVersionGroup] = []
    public var buildConfigurations: [XCBuildConfiguration] = []
    public var variantGroups: [PBXVariantGroup] = []
    public var targetDependencies: [PBXTargetDependency] = []
    public var sourcesBuildPhases: [PBXSourcesBuildPhase] = []
    public var shellScriptBuildPhases: [PBXShellScriptBuildPhase] = []
    public var resourcesBuildPhases: [PBXResourcesBuildPhase] = []
    public var frameworksBuildPhases: [PBXFrameworksBuildPhase] = []
    public var headersBuildPhases: [PBXHeadersBuildPhase] = []
    public var nativeTargets: [PBXNativeTarget] = []
    public var fileReferences: [PBXFileReference] = []
    public var projects: [PBXProject] = []
    public var referenceProxies: [PBXReferenceProxy] = []
    public var buildPhases: [PBXBuildPhase] {
        var phases: [PBXBuildPhase] = []
        phases.append(contentsOf: self.copyFilesBuildPhases as [PBXBuildPhase])
        phases.append(contentsOf: self.sourcesBuildPhases as [PBXBuildPhase])
        phases.append(contentsOf: self.shellScriptBuildPhases as [PBXBuildPhase])
        phases.append(contentsOf: self.resourcesBuildPhases as [PBXBuildPhase])
        phases.append(contentsOf: self.frameworksBuildPhases as [PBXBuildPhase])
        phases.append(contentsOf: self.headersBuildPhases as [PBXBuildPhase])
        return phases
    }
    
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
                archiveVersion: Int? = nil,
                classes: [String: Any] = [:],
                objects: [PBXObject] = []) {
        self.archiveVersion = archiveVersion
        self.objectVersion = objectVersion
        self.classes = classes
        self.rootObject = rootObject
        self.objects = objects
    }

    public private(set) var objects: [PBXObject] {
        get {
            var array: [PBXObject] = []
            array += buildFiles as [PBXObject]
            array += aggregateTargets as [PBXObject]
            array += containerItemProxies as [PBXObject]
            array += copyFilesBuildPhases as [PBXObject]
            array += groups as [PBXObject]
            array += fileElements as [PBXObject]
            array += configurationLists as [PBXObject]
            array += buildConfigurations as [PBXObject]
            array += variantGroups as [PBXObject]
            array += targetDependencies as [PBXObject]
            array += sourcesBuildPhases as [PBXObject]
            array += shellScriptBuildPhases as [PBXObject]
            array += resourcesBuildPhases as [PBXObject]
            array += frameworksBuildPhases as [PBXObject]
            array += headersBuildPhases as [PBXObject]
            array += nativeTargets as [PBXObject]
            array += fileReferences as [PBXObject]
            array += projects as [PBXObject]
            array += versionGroups as [PBXObject]
            array += referenceProxies as [PBXObject]
            return array
        }
        set {
            buildFiles = newValue.flatMap { $0 as? PBXBuildFile }
            aggregateTargets = newValue.flatMap { $0 as? PBXAggregateTarget }
            containerItemProxies = newValue.flatMap { $0 as? PBXContainerItemProxy }
            copyFilesBuildPhases = newValue.flatMap { $0 as? PBXCopyFilesBuildPhase }
            groups = newValue.flatMap { $0 as? PBXGroup }
            fileElements = newValue.flatMap { $0 as? PBXFileElement }
            configurationLists = newValue.flatMap { $0 as? XCConfigurationList }
            buildConfigurations = newValue.flatMap { $0 as? XCBuildConfiguration }
            variantGroups = newValue.flatMap { $0 as? PBXVariantGroup }
            targetDependencies = newValue.flatMap { $0 as? PBXTargetDependency }
            sourcesBuildPhases = newValue.flatMap { $0 as? PBXSourcesBuildPhase }
            shellScriptBuildPhases = newValue.flatMap { $0 as? PBXShellScriptBuildPhase }
            resourcesBuildPhases = newValue.flatMap { $0 as? PBXResourcesBuildPhase }
            frameworksBuildPhases = newValue.flatMap { $0 as? PBXFrameworksBuildPhase }
            headersBuildPhases = newValue.flatMap { $0 as? PBXHeadersBuildPhase }
            nativeTargets = newValue.flatMap { $0 as? PBXNativeTarget }
            fileReferences = newValue.flatMap { $0 as? PBXFileReference }
            projects = newValue.flatMap { $0 as? PBXProject }
            versionGroups = newValue.flatMap { $0 as? XCVersionGroup }
            referenceProxies = newValue.flatMap { $0 as? PBXReferenceProxy }
        }
    }

    public func addObject(_ object: PBXObject) {
        switch object {
        case let object as PBXBuildFile: buildFiles.append(object)
        case let object as PBXAggregateTarget: aggregateTargets.append(object)
        case let object as PBXContainerItemProxy: containerItemProxies.append(object)
        case let object as PBXCopyFilesBuildPhase: copyFilesBuildPhases.append(object)
        case let object as PBXGroup: groups.append(object)
        case let object as PBXFileElement: fileElements.append(object)
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
        default: break
        }
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
        self.archiveVersion = archiveVersionString.flatMap(Int.init)
        let objectVersionString: String = try container.decode(.objectVersion)
        self.objectVersion = Int(objectVersionString) ?? 0
        self.rootObject = try container.decode(.rootObject)
        self.classes = try container.decodeIfPresent([String: Any].self, forKey: .classes) ?? [:]        
        let objectsDictionary: [String: Any] = try container.decodeIfPresent([String: Any].self, forKey: .objects) ?? [:]
        let objects: [String: [String: Any]] = (objectsDictionary as? [String: [String: Any]]) ?? [:]
        self.objects = try objects.flatMap { try PBXObject.parse(reference: $0.key, dictionary: $0.value) }
    }

    func fileName(from reference: String) -> String? {
        let fileReference = fileReferences.getReference(reference)
        return fileReference?.name ?? fileReference?.path
    }

    func configName(from reference: String) -> String? {
        return self.buildConfigurations.getReference(reference)?.name
    }

}

// MARK: - PBXProj Extension (Equatable)

extension PBXProj: Equatable {

    public static func == (lhs: PBXProj, rhs: PBXProj) -> Bool {
        let equalClasses = NSDictionary(dictionary: lhs.classes).isEqual(to: rhs.classes)
        return lhs.archiveVersion == rhs.archiveVersion &&
            lhs.objectVersion == rhs.objectVersion &&
            equalClasses &&
            lhs.buildFiles == rhs.buildFiles &&
            lhs.aggregateTargets == rhs.aggregateTargets &&
            lhs.containerItemProxies == rhs.containerItemProxies &&
            lhs.copyFilesBuildPhases == rhs.copyFilesBuildPhases &&
            lhs.groups == rhs.groups &&
            lhs.fileElements == rhs.fileElements &&
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
            lhs.rootObject == rhs.rootObject &&
            lhs.versionGroups == rhs.versionGroups &&
            lhs.referenceProxies == rhs.referenceProxies
    }
}
