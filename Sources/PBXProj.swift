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
        objects = objectsDictionary.flatMap { try? PBXObject.parse(reference: $0.key, dictionary: $0.value) }
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
            lhs.rootObject == rhs.rootObject
    }
}

// MARK: - PBXProj Error

enum PBXProjError: Error, CustomStringConvertible {
    case notFound(path: Path)
    var description: String {
        switch self {
        case .notFound(let path):
            return ".pbxproj not found at path \(path)"
        }
    }
}

// MARK: - PBXProj extension (Writable)

extension PBXProj: Writable {

    public func write(path: Path, override: Bool) throws {
        let writer = PBXProjWriter()
        let output = writer.write(proj: self)
        if override && path.exists {
            try path.delete()
        }
        try path.write(output)
    }

}

// MARK: - PBXProj Extension (Extras)

extension PBXProj {

    /// Returns the build file name.
    ///
    /// - Parameter reference: file reference.
    /// - Returns: build file name.
    func buildFileName(reference: String) -> String? {
        guard let fileRef = buildFiles.getReference(reference)?.fileRef else { return nil }
        if let variantGroup = variantGroups.getReference(fileRef) {
            return variantGroup.name
        } else if let fileReference = fileReferences.getReference(fileRef) {
            return fileReference.path ?? fileReference.name
        }
        return nil
    }

    /// Returns the build phase a file is in.
    ///
    /// - Parameter reference: reference of the file whose type will be returned.
    /// - Returns: String with the type of file.
    func fileType(reference: String) -> BuildPhase? {
        if frameworksBuildPhases.filter({$0.files.contains(reference)}).count != 0 {
            return .frameworks
        } else if headersBuildPhases.filter({$0.files.contains(reference)}).count != 0 {
            return .headers
        } else if sourcesBuildPhases.filter({$0.files.contains(reference)}).count != 0 {
            return .sources
        } else if resourcesBuildPhases.filter({$0.files.contains(reference)}).count != 0 {
            return .resources
        }
        return nil
    }

    /// Returns the build phase type from its reference.
    ///
    /// - Parameter reference: build phase reference.
    /// - Returns: string with the build phase type.
    func buildPhaseType(from reference: String) -> BuildPhase? {
        if sourcesBuildPhases.contains(reference: reference) {
            return .sources
        } else if frameworksBuildPhases.contains(reference: reference) {
            return .frameworks
        } else if resourcesBuildPhases.contains(reference: reference) {
            return .resources
        } else if copyFilesBuildPhases.contains(reference: reference) {
            return .copyFiles
        } else if shellScriptBuildPhases.contains(reference: reference) {
            return .runScript
        } else if headersBuildPhases.contains(reference: reference) {
            return .headers
        }
        return nil
    }

}

// MARK: - PBXProj Extension (UUID Generation)

public extension PBXProj {

    /// Returns a valid UUID for new elements.
    ///
    /// - Parameter element: project element class.
    /// - Returns: UUID available to be used.
    public func generateUUID<T: PBXObject>(for element: T.Type) -> String {
        var uuid: String = ""
        var counter: UInt = 0
        let random: String = String.random()
        let className: String = String(describing: T.self).hash.description
        repeat {
            counter += 1
            uuid = String(format: "%08X%08X%08X", className, random, counter)
        } while(objects.contains(reference: uuid))
        return uuid
    }

}
