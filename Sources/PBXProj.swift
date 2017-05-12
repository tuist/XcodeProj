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
    public let classes: Set<PBXObject>
    
    /// Project root object.
    public let rootObject: UUID
    
    // MARK: - Init
    
    /// Initializes the project with its attributes.
    ///
    /// - Parameters:
    ///   - path: project path.
    ///   - archiveVersion: project archive version.
    ///   - objectVersion: project object version.
    ///   - classes: project classes.
    ///   - rootObject: project root object.
    public init(path: Path,
                archiveVersion: Int,
                objectVersion: Int,
                classes: Set<PBXObject>,
                rootObject: UUID) {
        self.path = path
        self.archiveVersion = archiveVersion
        self.objectVersion = objectVersion
        self.classes = classes
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
        //sss
        self.classes = []
//        self.classes = (dictionary["classes"] as? [Any]) ?? []
        self.rootObject = try unboxer.unbox(key: "rootObject")
    }
    
}

// MARK: - PBXProj Extension (Classes Accessors)

public extension PBXProj {
    
    /// Returns a new project by adding a class.
    ///
    /// - Parameter projectClass: class to be added.
    /// - Returns: project with the new class added.
    public func adding(projectClass: PBXObject) -> PBXProj {
        var classes = self.classes
        classes.insert(projectClass)
        return PBXProj(path: path,
                       archiveVersion: archiveVersion,
                       objectVersion: objectVersion,
                       classes: classes,
                       rootObject: rootObject)
    }
    
    /// Returns a new project removing a class.
    ///
    /// - Parameter projectClass: class to be removed
    /// - Returns: project with the classs added.
    public func removing(projectClass: PBXObject) -> PBXProj {
        var classes = self.classes
        classes.remove(projectClass)
        return PBXProj(path: path,
                       archiveVersion: archiveVersion,
                       objectVersion: objectVersion,
                       classes: classes,
                       rootObject: rootObject)
    }
    
}
