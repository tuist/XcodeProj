import Foundation
import Unbox

/// It represents a .pbxproj file
public struct PBXProj {
    
    // MARK: - Properties
    
    public let archiveVersion: Int
    public let objectVersion: Int
    public let classes: [Any]
    
}

internal extension PBXProj {
    
    init(dictionary: Dictionary<String, Any>) throws {
        let unboxer = Unboxer(dictionary: dictionary)
        self.archiveVersion = try unboxer.unbox(key: "archiveVersion")
        self.objectVersion = try unboxer.unbox(key: "objectVersion")
        self.classes = (dictionary["classes"] as? [Any]) ?? []
    }
    
}
