import Foundation
import Unbox
import PathKit

/// It represents a .pbxproj file
public class PBXProj {

    // MARK: - Properties

    /// Project archive version.
    public var archiveVersion: Int

    /// Project object version.
    public var objectVersion: Int

    /// Project classes.
    public var classes: [Any]

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
    
    /// Initializes the project with its attributes.
    ///
    /// - Parameters:
    ///   - archiveVersion: project archive version.
    ///   - objectVersion: project object version.
    ///   - rootObject: project root object.
    ///   - classes: project classes.
    ///   - objects: project objects
    public init(archiveVersion: Int,
                objectVersion: Int,
                rootObject: String,
                classes: [Any] = [],
                objects: [PBXObject] = []) {
        self.archiveVersion = archiveVersion
        self.objectVersion = objectVersion
        self.classes = classes
        self.rootObject = rootObject
        self.objects = objects
    }

    var objects: [PBXObject] {
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

    /// Initializes the .pbxproj reading the file from the given path.
    ///
    /// - Parameters:
    ///   - path: path where the .pbxproj is.
    /// - Throws: an error if the project cannot be found or the format is wrong.
    public convenience init(path: Path) throws {
        guard let dictionary = loadPlist(path: path.string) else { throw PBXProjError.notFound(path: path) }
        try self.init(dictionary: dictionary)
    }

    /// Initializes the .pbxproj representation with the path where the file is and a dictionary with its content.
    ///
    /// - Parameters:
    ///   - dictionary: dictionary with the file content.
    /// - Throws: throws an error if the content cannot be parsed properly.
    public init(dictionary: [String: Any]) throws {
        let unboxer = Unboxer(dictionary: dictionary)
        self.archiveVersion = try unboxer.unbox(key: "archiveVersion")
        self.objectVersion = try unboxer.unbox(key: "objectVersion")
        self.classes = (dictionary["classes"] as? [Any]) ?? []
        let objectsDictionary: [String: [String: Any]] = try unboxer.unbox(key: "objects")
        self.rootObject = try unboxer.unbox(key: "rootObject")
        objects = try objectsDictionary.flatMap { try PBXObject.parse(reference: $0.key, dictionary: $0.value) }
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
        return lhs.archiveVersion == rhs.archiveVersion &&
            lhs.objectVersion == rhs.objectVersion &&
            NSArray(array: lhs.classes).isEqual(to: NSArray(array: rhs.classes)) &&
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
