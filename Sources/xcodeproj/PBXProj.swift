import Foundation
import Unbox
import PathKit
import xcodeprojprotocols
import xcodeprojextensions

/// It represents a .pbxproj file
public struct PBXProj {
    
    // MARK: - Properties
    
    /// Project path.
    public let path: Path
    
    /// Project archive version.
    public let archiveVersion: Int
    
    /// Project object version.
    public let objectVersion: Int
    
    /// Project classes.
    public let classes: [Any]
    
    /// Project objects
    public let objects: Set<PBXObject>
    
    /// Project root object.
    public let rootObject: UUID
    
    // MARK: - Init
    
    /// Initializes the project with its attributes.
    ///
    /// - Parameters:
    ///   - path: project path.
    ///   - archiveVersion: project archive version.
    ///   - objectVersion: project object version.
    ///   - rootObject: project root object.
    ///   - classes: project classes.
    ///   - objects: project objects
    public init(path: Path,
                archiveVersion: Int,
                objectVersion: Int,
                rootObject: UUID,
                classes: [Any] = [],
                objects: Set<PBXObject> = Set()) {
        self.path = path
        self.archiveVersion = archiveVersion
        self.objectVersion = objectVersion
        self.classes = classes
        self.objects = objects
        self.rootObject = rootObject
    }
    
    // MARK: - Public
    
    /// Returns a new PBXProj removing an object.
    ///
    /// - Parameter object: object to be removed.
    /// - Returns: a new PBXProj object with the object removed.
    public func removing(object: PBXObject) -> PBXProj {
        var objects = self.objects
        objects.remove(object)
        return PBXProj(path: path,
                       archiveVersion: archiveVersion,
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
        objects.insert(object)
        return PBXProj(path: path,
                       archiveVersion: archiveVersion,
                       objectVersion: objectVersion,
                       rootObject: rootObject,
                       classes: classes,
                       objects: objects)
    }
}

// MARK: - PBXProj Extension (Dictionary Initialization)

extension PBXProj: PlistInitiatable {
    
    /// Initializes the .pbxproj representation with the path where the file is and a dictionary with its content.
    ///
    /// - Parameters:
    ///   - path: path where the .pbxproj file is.
    ///   - dictionary: dictionary with the file content.
    /// - Throws: throws an error if the content cannot be parsed properly.
    public init(path: Path, dictionary: [String: Any]) throws {
        self.path = path
        let unboxer = Unboxer(dictionary: dictionary)
        self.archiveVersion = try unboxer.unbox(key: "archiveVersion")
        self.objectVersion = try unboxer.unbox(key: "objectVersion")
        self.classes = (dictionary["classes"] as? [Any]) ?? []
        let objectsDictionary: [String: [String: Any]] = try unboxer.unbox(key: "objects")
        let objectsArray = objectsDictionary
            .map { try? PBXObject(reference: $0.key, dictionary: $0.value) }
            .filter { $0 != nil }
            .map { $0! }
        self.objects = Set(objectsArray)
        self.rootObject = try unboxer.unbox(key: "rootObject")
    }
    
}

// MARK: - PBXProj extension (Writable)

extension PBXProj: Writable {
    
    public func write(override: Bool) throws {
        
    }
    
}
