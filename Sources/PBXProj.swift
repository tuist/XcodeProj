import Foundation
import Unbox
import PathKit

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
    public let objects: [PBXObject]
    
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
                objects: [PBXObject] = []) {
        self.path = path
        self.archiveVersion = archiveVersion
        self.objectVersion = objectVersion
        self.classes = classes
        self.objects = objects
        self.rootObject = rootObject
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
        self.objects = objectsDictionary
            .map { try? PBXObject(reference: $0.key, dictionary: $0.value) }
            .filter { $0 != nil }
            .map { $0! }
        self.rootObject = try unboxer.unbox(key: "rootObject")
    }
    
}

// MARK: - PBXProj Extension (Classes Accessors)

public extension PBXProj {
    
    /// Returns a new project by adding a class.
    ///
    /// - Parameter projectClass: class to be added.
    /// - Returns: project with the new class added.
    public func adding(projectClass: Any) -> PBXProj {
        var classes = self.classes
        classes.append(projectClass)
        return PBXProj(path: path,
                       archiveVersion: archiveVersion,
                       objectVersion: objectVersion,
                       rootObject: rootObject,
                       classes: classes,
                       objects: objects)
    }

}
