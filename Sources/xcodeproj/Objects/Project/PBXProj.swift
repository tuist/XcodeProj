import Foundation
import PathKit

/// Represents a .pbxproj file
public final class PBXProj: Decodable {
    // MARK: - Properties

    let objects: PBXObjects

    /// Project archive version.
    public var archiveVersion: UInt

    /// Project object version.
    public var objectVersion: UInt

    /// Project classes.
    public var classes: [String: Any]

    /// Project root object.
    var rootObjectReference: PBXObjectReference?

    /// Project root object.
    public var rootObject: PBXProject? {
        set {
            rootObjectReference = newValue?.reference
        }
        get {
            return rootObjectReference?.getObject()
        }
    }

    /// Initializes the project with its attributes.
    ///
    /// - Parameters:
    ///   - rootObject: project root object.
    ///   - objectVersion: project object version.
    ///   - archiveVersion: project archive version.
    ///   - classes: project classes.
    ///   - objects: project objects
    public init(rootObject: PBXProject? = nil,
                objectVersion: UInt = Xcode.LastKnown.objectVersion,
                archiveVersion: UInt = Xcode.LastKnown.archiveVersion,
                classes: [String: Any] = [:],
                objects: [PBXObject] = []) {
        self.archiveVersion = archiveVersion
        self.objectVersion = objectVersion
        self.classes = classes
        rootObjectReference = rootObject?.reference
        self.objects = PBXObjects(objects: objects)
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
        let objects = decoder.context.objects
        let objectReferenceRepository = decoder.context.objectReferenceRepository
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rootObjectReference: String = try container.decode(.rootObject)
        self.rootObjectReference = objectReferenceRepository.getOrCreate(reference: rootObjectReference, objects: objects)
        objectVersion = try container.decodeIntIfPresent(.objectVersion) ?? 0
        archiveVersion = try container.decodeIntIfPresent(.archiveVersion) ?? 1
        classes = try container.decodeIfPresent([String: Any].self, forKey: .classes) ?? [:]
        let objectsDictionary: [String: Any] = try container.decodeIfPresent([String: Any].self, forKey: .objects) ?? [:]
        let objectsDictionaries: [String: [String: Any]] = (objectsDictionary as? [String: [String: Any]]) ?? [:]
        try objectsDictionaries.forEach { reference, dictionary in
            let object = try PBXObject.parse(reference: reference, dictionary: dictionary, userInfo: decoder.userInfo)
            objects.add(object: object)
        }
        self.objects = objects
    }
}

// MARK: - Public helpers

public extension PBXProj {
    // MARK: - Properties

    public var projects: [PBXProject] { return Array(objects.projects.values) }
    public var referenceProxies: [PBXReferenceProxy] { return Array(objects.referenceProxies.values) }

    // File elements
    public var fileReferences: [PBXFileReference] { return Array(objects.fileReferences.values) }
    public var versionGroups: [XCVersionGroup] { return Array(objects.versionGroups.values) }
    public var variantGroups: [PBXVariantGroup] { return Array(objects.variantGroups.values) }
    public var groups: [PBXGroup] { return Array(objects.groups.values) }

    // Configuration
    public var buildConfigurations: [XCBuildConfiguration] { return Array(objects.buildConfigurations.values) }
    public var configurationLists: [XCConfigurationList] { return Array(objects.configurationLists.values) }

    // Targets
    public var legacyTargets: [PBXLegacyTarget] { return Array(objects.legacyTargets.values) }
    public var aggregateTargets: [PBXAggregateTarget] { return Array(objects.aggregateTargets.values) }
    public var nativeTargets: [PBXNativeTarget] { return Array(objects.nativeTargets.values) }
    public var targetDependencies: [PBXTargetDependency] { return Array(objects.targetDependencies.values) }
    public var containerItemProxies: [PBXContainerItemProxy] { return Array(objects.containerItemProxies.values) }
    public var buildRules: [PBXBuildRule] { return Array(objects.buildRules.values) }

    // Build
    public var buildFiles: [PBXBuildFile] { return Array(objects.buildFiles.values) }
    public var copyFilesBuildPhases: [PBXCopyFilesBuildPhase] { return Array(objects.copyFilesBuildPhases.values) }
    public var shellScriptBuildPhases: [PBXShellScriptBuildPhase] { return Array(objects.shellScriptBuildPhases.values) }
    public var resourcesBuildPhases: [PBXResourcesBuildPhase] { return Array(objects.resourcesBuildPhases.values) }
    public var frameworksBuildPhases: [PBXFrameworksBuildPhase] { return Array(objects.frameworksBuildPhases.values) }
    public var headersBuildPhases: [PBXHeadersBuildPhase] { return Array(objects.headersBuildPhases.values) }
    public var sourcesBuildPhases: [PBXSourcesBuildPhase] { return Array(objects.sourcesBuildPhases.values) }
    public var carbonResourcesBuildPhases: [PBXRezBuildPhase] { return Array(objects.carbonResourcesBuildPhases.values) }
    public var buildPhases: [PBXBuildPhase] { return Array(objects.buildPhases.values) }

    /// Returns root project.
    public func rootProject() throws -> PBXProject? {
        return try rootObjectReference?.getThrowingObject()
    }

    /// Returns root project's root group.
    public func rootGroup() throws -> PBXGroup? {
        let project = try rootProject()
        return try project?.mainGroupReference.getThrowingObject()
    }

    /// Adds a new object to the project.
    ///
    /// - Parameter object: object to be added.
    public func add(object: PBXObject) {
        objects.add(object: object)
    }

    /// Deletes an object from the project.
    ///
    /// - Parameter object: object to be deleted.
    public func delete(object: PBXObject) {
        objects.delete(reference: object.reference)
    }

    /// Returns all the targets with the given name.
    ///
    /// - Parameters:
    ///   - name: target name.
    /// - Returns: targets with the given name.
    public func targets(named name: String) -> [PBXTarget] {
        return objects.targets(named: name)
    }

    /// Invalidates all the objects UUIDs.
    /// Those UUIDs will be generated deterministically when the project is saved.
    public func invalidateUUIDs() {
        objects.invalidateReferences()
    }

    /// Runs the given closure passing each of the objects that are part of the project.
    ///
    /// - Parameter closure: closure to be run.
    public func forEach(_ closure: (PBXObject) -> Void) {
        objects.forEach(closure)
    }
}

// MARK: - Internal helpers

extension PBXProj {
    /// Infers project name from Path and sets it as project name
    ///
    /// Project name is needed for certain comments when serialising PBXProj
    ///
    /// - Parameters:
    ///   - path: path to .xcodeproj directory.
    func updateProjectName(path: Path) throws {
        guard path.parent().extension == "xcodeproj" else {
            return
        }
        let projectName = path.parent().lastComponent.split(separator: ".").first
        try rootProject()?.name = projectName.map(String.init) ?? ""
    }
}

// MARK: - Equatable

extension PBXProj: Equatable {
    public static func == (lhs: PBXProj, rhs: PBXProj) -> Bool {
        let equalClasses = NSDictionary(dictionary: lhs.classes).isEqual(to: rhs.classes)
        return lhs.archiveVersion == rhs.archiveVersion &&
            lhs.objectVersion == rhs.objectVersion &&
            equalClasses &&
            lhs.objects == rhs.objects
    }
}

// MARK: - Writable

extension PBXProj: Writable {
    public func write(path: Path, override: Bool) throws {
        try write(path: path, override: override, outputSettings: PBXOutputSettings())
    }

    public func write(path: Path, override: Bool, outputSettings: PBXOutputSettings) throws {
        let encoder = PBXProjEncoder(outputSettings: outputSettings)
        let output = try encoder.encode(proj: self)
        if override && path.exists {
            try path.delete()
        }
        try path.write(output)
    }
}
