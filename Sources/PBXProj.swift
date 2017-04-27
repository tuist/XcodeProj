import Foundation
import Unbox
import PathKit

/// It represents a .pbxproj file
public struct PBXProj {
    
    // MARK: - Properties
    
    public let path: Path
    public let archiveVersion: Int
    public let objectVersion: Int
    public let classes: [Any]
    public let rootObject: UUID
    
}

// MARK: - PBXProj Extension (Dictionary Initialization)

internal extension PBXProj {
    
    init(path: Path, dictionary: [String: Any]) throws {
        self.path = path
        let unboxer = Unboxer(dictionary: dictionary)
        self.archiveVersion = try unboxer.unbox(key: "archiveVersion")
        self.objectVersion = try unboxer.unbox(key: "objectVersion")
        self.classes = (dictionary["classes"] as? [Any]) ?? []
        self.rootObject = try unboxer.unbox(key: "rootObject")
    }
    
}

//public extension PBXProj {
//    
//    init(path: ) {
//
//    }
//    
//}
