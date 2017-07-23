import Foundation
import Unbox
import PathKit
import xcodeprojprotocols
import xcodeprojextensions

/// It represents a .pbxproj file
public struct PBXProj {
    
    // MARK: - Properties
    
    /// Project archive version.
    public let archiveVersion: Int
    
    /// Project object version.
    public let objectVersion: Int
    
    /// Project classes.
    public let classes: [Any]
    
    /// Project objects
    public let objects: [PBXObject]
    
    /// Project root object.
    public let rootObject: String
    
}

// MARK: - PBXProj Extension (Init)

extension PBXProj {
    
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
        self.objects = objects
        self.rootObject = rootObject
    }
    
    /// Initializes the .pbxproj reading the file from the given path.
    ///
    /// - Parameters:
    ///   - path: path where the .pbxproj is.
    /// - Throws: an error if the project cannot be found or the format is wrong.
    public init(path: Path) throws {
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
        self.objects = objectsDictionary
            .map { try? PBXObject(reference: $0.key, dictionary: $0.value) }
            .filter { $0 != nil }
            .map { $0! }
        self.rootObject = try unboxer.unbox(key: "rootObject")
    }
    
}

// MARK: - PBXProj Extension (Equatable)

extension PBXProj: Equatable {
    
    public static func == (lhs: PBXProj, rhs: PBXProj) -> Bool {
        return lhs.archiveVersion == rhs.archiveVersion &&
            lhs.objectVersion == rhs.objectVersion &&
            NSArray(array: lhs.classes).isEqual(to: NSArray(array: rhs.classes)) &&
            lhs.objects == rhs.objects &&
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
        guard let fileRef = objects.buildFiles.filter({$0.reference == reference}).first?.fileRef else { return nil }
        if let variantGroup = objects.variantGroups.filter({ $0.reference == fileRef }).first {
            return variantGroup.name
        } else if let fileReference = objects.fileReferences.filter({ $0.reference == fileRef}).first {
            return fileReference.path ?? fileReference.name
        }
        return nil
    }
    
    /// Returns the type of file whose reference is given.
    ///
    /// - Parameter reference: reference of the file whose type will be returned.
    /// - Returns: String with the type of file.
    func fileType(reference: String) -> String? {
        if objects.frameworksBuildPhases.filter({$0.files.contains(reference)}).count != 0 {
            return BuildPhase.frameworks.rawValue
        } else if objects.headersBuildPhases.filter({$0.files.contains(reference)}).count != 0 {
            return BuildPhase.headers.rawValue
        } else if objects.sourcesBuildPhases.filter({$0.files.contains(reference)}).count != 0 {
            return BuildPhase.sources.rawValue
        } else if objects.resourcesBuildPhases.filter({$0.files.contains(reference)}).count != 0 {
            return BuildPhase.resources.rawValue
        }
        return nil
    }
    
    /// Returns the build phase type from its reference.
    ///
    /// - Parameter reference: build phase reference.
    /// - Returns: string with the build phase type.
    func buildPhaseType(from reference: String) -> String? {
        let sources = objects.sourcesBuildPhases.map {return $0.reference}
        let frameworks = objects.frameworksBuildPhases.map {return $0.reference}
        let resources = objects.resourcesBuildPhases.map {return $0.reference}
        let copyFiles = objects.copyFilesBuildPhases.map {return $0.reference}
        let runScript = objects.shellScriptBuildPhases.map {return $0.reference}
        let headers = objects.headersBuildPhases.map {return $0.reference}
        if sources.contains(reference) {
            return BuildPhase.sources.rawValue
        } else if frameworks.contains(reference) {
            return BuildPhase.frameworks.rawValue
        } else if resources.contains(reference) {
            return BuildPhase.resources.rawValue
        } else if copyFiles.contains(reference) {
            return BuildPhase.copyFiles.rawValue
        } else if runScript.contains(reference) {
            return BuildPhase.runScript.rawValue
        } else if headers.contains(reference) {
            return BuildPhase.headers.rawValue
        }
        return nil
    }
    
    /// Returns a new PBXProj updating an object.
    ///
    /// - Parameter object: object to be updated. The object reference is used to find the object in the project list of objects.
    /// - Returns: a new PBXProj object with the object udpated.
    public func updating(object: PBXObject) -> PBXProj {
        var objects = self.objects
        if let index = objects.index(of: object) {
            objects.replaceSubrange(index..<index+1, with: [object])
        }
        return PBXProj(archiveVersion: archiveVersion,
                       objectVersion: objectVersion,
                       rootObject: rootObject,
                       classes: classes,
                       objects: objects)
    }
    
    /// Returns a new PBXProj removing an object.
    ///
    /// - Parameter object: object to be removed.
    /// - Returns: a new PBXProj object with the object removed.
    public func removing(object: PBXObject) -> PBXProj {
        var objects = self.objects
        if let index = objects.index(of: object) {
            objects.remove(at: index)
        }
        return PBXProj(archiveVersion: archiveVersion,
                       objectVersion: objectVersion,
                       rootObject: rootObject,
                       classes: classes,
                       objects: objects)
    }
    
    /// Returns a new PBXProj removing the object with the given reference.
    ///
    /// - Parameter objectReference: reference that identifies the object to be removed.
    /// - Returns: a new PBXProj object with the object removed.
    public func removing(objectReference: String) -> PBXProj {
        var objects = self.objects
        if let index = objects.index(where: {$0.reference == objectReference}) {
            objects.remove(at: index)
        }
        return PBXProj(archiveVersion: archiveVersion,
                       objectVersion: objectVersion,
                       rootObject: rootObject,
                       classes: classes,
                       objects: objects)
    }
    
    /// Returns a new PBXProj adding an object.
    ///
    /// - Parameter object: object to be added.
    /// - Returns: a new PBXProj object with the object added.
    public func adding(object: PBXObject) -> PBXProj {
        var objects = self.objects
        objects.append(object)
        return PBXProj(archiveVersion: archiveVersion,
                       objectVersion: objectVersion,
                       rootObject: rootObject,
                       classes: classes,
                       objects: objects)
    }
    
}

// MARK: - PBXProj Extension (UUID Generation)

public extension PBXProj {
    
    /// Returns a valid UUID for new elements.
    ///
    /// - Parameter element: project element class.
    /// - Returns: UUID available to be used.
    public func generateUUID<T: ProjectElement>(for element: T.Type) -> String {
        var uuid: String = ""
        var counter: UInt = 0
        let random: String = String.random()
        let className: String = String(describing: T.self).md5()
        repeat {
            counter += 1
            uuid = String(format: "%08X%08X%08X", className, random, counter)
        } while(self.objects.map({$0.reference}).contains(uuid))
        return uuid
    }
    
}
