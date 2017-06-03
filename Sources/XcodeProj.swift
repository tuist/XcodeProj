import Foundation
import PathKit

/// Model that represents a Xcodeproj
public struct XcodeProj {
    
    // MARK: - Properties
    
    // Project workspace
    public let workspace: XCWorkspace
    
    /// .pbxproj representatino
    public let pbxproj: PBXProj
    
    // MARK: - Init
    
    public init(path: Path, fileManager: FileManager = .default) throws {
        if !fileManager.fileExists(atPath: path.string) { throw XCodeProjError.notFound(path: path) }
        let pbxprojPaths = path.glob("*.pbxproj")
        if pbxprojPaths.count == 0 {
            throw XCodeProjError.pbxprojNotFound(path: path)
        }
        pbxproj = try PBXProj(path: pbxprojPaths.first!)
        let xcworkspacePaths = path.glob("*.xcworkspace")
        if xcworkspacePaths.count == 0 {
            throw XCodeProjError.xcworkspaceNotFound(path: path)
        }
        workspace = try XCWorkspace(path: xcworkspacePaths.first!)
    }
    
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
/// - pbxProjNotFound: the .pbxproj file couldn't be found inside the project folder.
public enum XCodeProjError: Error, CustomStringConvertible {
    
    case notFound(path: Path)
    case pbxprojNotFound(path: Path)
    case xcworkspaceNotFound(path: Path)
    
    public var description: String {
        switch self {
        case .notFound(let path):
            return "The project cannot be found at \(path)"
        case .pbxprojNotFound(let path):
            return "The project doesn't contain a .pbxproj file at path: \(path)"
        case .xcworkspaceNotFound(let path):
            return "The project doesn't contain a .xcworkspace at path: \(path)"
        }
    }

}
