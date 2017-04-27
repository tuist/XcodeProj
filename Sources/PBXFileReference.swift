import Foundation

//  A PBXFileReference is used to track every external file referenced by 
//  the project: source files, resource files, libraries, generated application files, and so on.
public struct PBXFileReference {
 
    // MARK: - Attributes
    
    public let reference: UUID
    public let isa: String = "PBXFileReference"
    public let fileEncoding: Int
    public let explicitFileType: String
    public let lastKnownFileType: String
    public let name: String
    public let path: String
    public let sourceTree: PBXSourceTree
    
}
