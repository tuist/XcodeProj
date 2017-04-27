import Foundation

/// Model that represents a Xcodeproj
public struct XCodeProj {
    
    // MARK: - Properties
    
    // Project workspace
    public let workspace: XCWorkspace
    
    /// .pbxproj representatino
    public let pbxproj: PBXProj
    
    // MARK: - Init
    
//    public init(path: String, fileManager: FileManager = .default) throws {
//        if !fileManager.fileExists(atPath: path) { throw XCodeProjError.notFound(path: path) }
//        
//    
//    }
    
    /// Initializes the XCodeProj
    ///
    /// - Parameters:
    ///   - workspace: project internal workspace.
    ///   - pbxproj: project .pbxproj.
    public init(workspace: XCWorkspace, pbxproj: PBXProj) {
        self.workspace = workspace
        self.pbxproj = pbxproj
    }
    
}

/// XcodeProj Errors
///
/// - notFound: the project cannot be found.
public enum XCodeProjError: Error, CustomStringConvertible {
    
    case notFound(path: String)
    
    public var description: String {
        switch self {
        case .notFound(let path):
            return "The project cannot be found at \(path)"
        }
    }

}
