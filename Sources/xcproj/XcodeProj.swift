import Foundation
import PathKit

/// Model that represents a .xcodeproj project.
final public class XcodeProj {

    // MARK: - Properties

    /// Project workspace
    public var workspace: XCWorkspace

    /// .pbxproj representatino
    public var pbxproj: PBXProj

    /// Shared data.
    public var sharedData: XCSharedData?

    // MARK: - Init

    public init(path: Path) throws {
        if !path.exists { throw XCodeProjError.notFound(path: path) }
        let pbxprojPaths = path.glob("*.pbxproj")
        if pbxprojPaths.count == 0 {
            throw XCodeProjError.pbxprojNotFound(path: path)
        }
        let pbxProjData = try Data(contentsOf: pbxprojPaths.first!.url)
        let plistDecoder = PropertyListDecoder()
        pbxproj = try plistDecoder.decode(PBXProj.self, from: pbxProjData)
        pbxproj.updateProjectName(path: pbxprojPaths.first!)
        let xcworkspacePaths = path.glob("*.xcworkspace")
        if xcworkspacePaths.count == 0 {
            workspace = XCWorkspace()
        } else {
            workspace = try XCWorkspace(path: xcworkspacePaths.first!)
        }
        let sharedDataPath = path + Path("xcshareddata")
        self.sharedData = try? XCSharedData(path: sharedDataPath)
    }
    
    public convenience init(pathString: String) throws {
        try self.init(path: Path(pathString))
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
        try writeWorkspace(path: path, override: override)
        try writePBXProj(path: path, override: override)
        try writeSharedData(path: path, override: override)
    }

    fileprivate func writeWorkspace(path: Path, override: Bool) throws {
        try workspace.write(path: path + "project.xcworkspace", override: override)
    }

    fileprivate func writePBXProj(path: Path, override: Bool) throws {
        try pbxproj.write(path: path + "project.pbxproj", override: override)
    }

    fileprivate func writeSharedData(path: Path, override: Bool) throws {
        if let sharedData = sharedData {
            let schemesPath = path + "xcshareddata/xcschemes"
            if override && schemesPath.exists {
                try schemesPath.delete()
            }
            try schemesPath.mkpath()
            for scheme in sharedData.schemes {
                try scheme.write(path: schemesPath + "\(scheme.name).xcscheme", override: override)
            }
            let debuggerPath = path + "xcshareddata/xcdebugger"
            if override && debuggerPath.exists {
                try debuggerPath.delete()
            }
            try debuggerPath.mkpath()
            try sharedData.breakpoints?.write(path: debuggerPath + "Breakpoints_v2.xcbkptlist", override: override)
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
