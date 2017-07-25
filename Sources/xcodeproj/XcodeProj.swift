import Foundation
import PathKit
import xcodeprojextensions
import xcodeprojprotocols

/// Model that represents a .xcodeproj project.
public struct XcodeProj {
    
    // MARK: - Properties
    
    // Project workspace
    public let workspace: XCWorkspace
    
    /// .pbxproj representatino
    public let pbxproj: PBXProj
    
    /// Shared data.
    public let sharedData: XCSharedData?
    
    // MARK: - Init
    
    public init(path: Path) throws {
        if !path.exists { throw XCodeProjError.notFound(path: path) }
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
        let sharedDataPath = path + Path("xcshareddata")
        self.sharedData = try? XCSharedData(path: sharedDataPath)
    }
    
    /// Initializes the XCodeProj
    ///
    /// - Parameters:
    ///   - workspace: project internal workspace.
    ///   - pbxproj: project .pbxproj.
    public init(workspace: XCWorkspace, pbxproj: PBXProj, sharedData: XCSharedData? = nil) {
        self.workspace = workspace
        self.pbxproj = pbxproj
        self.sharedData = sharedData
    }
    
}

// MARK: - <Writable>

extension XcodeProj: Writable {

    public func write(path: Path, override: Bool = true) throws {
        try path.mkpath()
        try writeWorkSpace(path: path, override: override)
        try writePBXProj(path: path, override: override)
        try writeSharedData(path: path, override: override)
    }

    fileprivate func writeWorkSpace(path: Path, override: Bool) throws {
        try workspace.write(path: path + "project.xcworkspace", override: override)
    }

    fileprivate func writePBXProj(path: Path, override: Bool) throws {
        try pbxproj.write(path: path + "project.pbxproj", override: override)
    }

    fileprivate func writeSharedData(path: Path, override: Bool) throws {
        if let sharedData = sharedData {
            let schemesPath = path + "xcshareddata/xcschemes"
            try schemesPath.mkpath()
            for scheme in sharedData.schemes {
                try scheme.write(path: schemesPath + scheme.name, override: override)
            }
        }
    }

}

// MARK: - XcodeProj Extension (Equatable)

extension XcodeProj: Equatable {

    public static func == (lhs: XcodeProj, rhs: XcodeProj) -> Bool {
        return lhs.workspace == rhs.workspace &&
            lhs.pbxproj == rhs.pbxproj
            //TODO: make SharedData equatable: lhs.sharedData == rhs.sharedData
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
