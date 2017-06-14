import Foundation
import PathKit
import xcodeprojextensions

/// Model that represents a .xcodeproj project.
public struct XcodeProj {
    
    // MARK: - Properties
    
    /// Project path
    public let path: Path
    
    // Project workspace
    public let workspace: XCWorkspace
    
    /// .pbxproj representatino
    public let pbxproj: PBXProj
    
    /// Shared data.
    public let sharedData: XCSharedData?
    
    // MARK: - Init
    
    public init(path: Path, fileManager: FileManager = .default) throws {
        if !fileManager.fileExists(atPath: path.string) { throw XCodeProjError.notFound(path: path) }
        let pbxprojPaths = path.glob("*.pbxproj")
        if pbxprojPaths.count == 0 {
            throw XCodeProjError.pbxprojNotFound(path: path)
        }
        pbxproj = try PBXProj(path: pbxprojPaths.first!,
                              name: path.lastComponentWithoutExtension)
        let xcworkspacePaths = path.glob("*.xcworkspace")
        if xcworkspacePaths.count == 0 {
            throw XCodeProjError.xcworkspaceNotFound(path: path)
        }
        workspace = try XCWorkspace(path: xcworkspacePaths.first!)
        self.path = path
        let sharedDataPath = path + Path("xcshareddata")
        self.sharedData = try? XCSharedData(path: sharedDataPath)
    }
    
    /// Initializes the XCodeProj
    ///
    /// - Parameters:
    ///   - path: project path
    ///   - workspace: project internal workspace.
    ///   - pbxproj: project .pbxproj.
    public init(path: Path, workspace: XCWorkspace, pbxproj: PBXProj, sharedData: XCSharedData? = nil) {
        self.path = path
        self.workspace = workspace
        self.pbxproj = pbxproj
        self.sharedData = sharedData
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
