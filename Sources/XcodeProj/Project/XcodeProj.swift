import Foundation
import PathKit

/// Model that represents a .xcodeproj project.
public final class XcodeProj: Equatable {
    // MARK: - Properties

    /// Project workspace
    public var workspace: XCWorkspace

    /// .pbxproj representation
    public var pbxproj: PBXProj

    /// Shared data.
    public var sharedData: XCSharedData?

    // MARK: - Init

    public init(path: Path) throws {
        var pbxproj: PBXProj!
        var workspace: XCWorkspace!
        var sharedData: XCSharedData?

        if !path.exists { throw XCodeProjError.notFound(path: path) }
        guard let pbxprojPath = path.glob("*.pbxproj").first else {
            throw XCodeProjError.pbxprojNotFound(path: path)
        }
        pbxproj = try PBXProj(path: pbxprojPath)
        let xcworkspacePaths = path.glob("*.xcworkspace")
        if xcworkspacePaths.isEmpty {
            workspace = XCWorkspace()
        } else {
            workspace = try XCWorkspace(path: xcworkspacePaths.first!)
        }
        let sharedDataPath = path + "xcshareddata"
        sharedData = try? XCSharedData(path: sharedDataPath)

        self.pbxproj = pbxproj
        self.workspace = workspace
        self.sharedData = sharedData
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

    // MARK: - Equatable

    public static func == (lhs: XcodeProj, rhs: XcodeProj) -> Bool {
        lhs.workspace == rhs.workspace &&
            lhs.pbxproj == rhs.pbxproj &&
            lhs.sharedData == rhs.sharedData
    }
}

// MARK: - <Writable>

extension XcodeProj: Writable {
    /// Writes project to the given path.
    ///
    /// - Parameter path: path to `.xcodeproj` file.
    /// - Parameter override: if project should be overridden. Default is true.
    ///   If false will throw error if project already exists at the given path.
    public func write(path: Path, override: Bool = true) throws {
        try write(path: path, override: override, outputSettings: PBXOutputSettings())
    }

    /// Writes project to the given path.
    ///
    /// - Parameter path: path to `.xcodeproj` file.
    /// - Parameter override: if project should be overridden. Default is true.
    /// - Parameter outputSettings: Controls the writing of various files.
    ///   If false will throw error if project already exists at the given path.
    public func write(path: Path, override: Bool = true, outputSettings: PBXOutputSettings) throws {
        try path.mkpath()
        try writeWorkspace(path: path, override: override)
        try writePBXProj(path: path, override: override, outputSettings: outputSettings)
        try writeSchemes(path: path, override: override)
        try writeBreakPoints(path: path, override: override)
    }

    /// Returns workspace file path relative to the given path.
    ///
    /// - Parameter path: `.xcodeproj` file path
    /// - Returns: workspace file path relative to the given path.
    public static func workspacePath(_ path: Path) -> Path {
        path + "project.xcworkspace"
    }

    /// Writes workspace to the given path.
    ///
    /// - Parameter path: path to `.xcodeproj` file.
    /// - Parameter override: if workspace should be overridden. Default is true.
    ///   If false will throw error if workspace already exists at the given path.
    public func writeWorkspace(path: Path, override: Bool = true) throws {
        try workspace.write(path: XcodeProj.workspacePath(path), override: override)
    }

    /// Returns project file path relative to the given path.
    ///
    /// - Parameter path: `.xcodeproj` file path
    /// - Returns: project file path relative to the given path.
    public static func pbxprojPath(_ path: Path) -> Path {
        path + "project.pbxproj"
    }

    /// Writes project to the given path.
    ///
    /// - Parameter path: path to `.xcodeproj` file.
    /// - Parameter override: if project should be overridden. Default is true.
    /// - Parameter outputSettings: Controls the writing of various files.
    ///   If false will throw error if project already exists at the given path.
    public func writePBXProj(path: Path, override: Bool = true, outputSettings: PBXOutputSettings) throws {
        try pbxproj.write(path: XcodeProj.pbxprojPath(path), override: override, outputSettings: outputSettings)
    }

    /// Returns shared data path relative to the given path.
    ///
    /// - Parameter path: `.xcodeproj` file path
    /// - Returns: shared data path relative to the given path.
    public static func sharedDataPath(_ path: Path) -> Path {
        path + "xcshareddata"
    }

    /// Returns schemes folder path relative to the given path.
    ///
    /// - Parameter path: `.xcodeproj` file path
    /// - Returns: schemes folder path relative to the given path.
    public static func schemesPath(_ path: Path) -> Path {
        XcodeProj.sharedDataPath(path) + "xcschemes"
    }

    /// Returns scheme file path relative to the given path.
    ///
    /// - Parameter path: `.xcodeproj` file path
    /// - Parameter schemeName: scheme name
    /// - Returns: scheme file path relative to the given path.
    public static func schemePath(_ path: Path, schemeName: String) -> Path {
        XcodeProj.schemesPath(path) + "\(schemeName).xcscheme"
    }

    /// Writes all project schemes to the given path.
    ///
    /// - Parameter path: path to `.xcodeproj` file.
    /// - Parameter override: if project should be overridden. Default is true.
    ///   If true will remove all existing schemes before writing.
    ///   If false will throw error if scheme already exists at the given path.
    public func writeSchemes(path: Path, override: Bool = true) throws {
        guard let sharedData = sharedData else { return }

        let schemesPath = XcodeProj.schemesPath(path)
        if override, schemesPath.exists {
            try schemesPath.delete()
        }
        try schemesPath.mkpath()
        for scheme in sharedData.schemes {
            try scheme.write(path: XcodeProj.schemePath(path, schemeName: scheme.name), override: override)
        }
    }

    /// Returns debugger folder path relative to the given path.
    ///
    /// - Parameter path: `.xcodeproj` file path
    /// - Parameter schemeName: scheme name
    /// - Returns: debugger folder path relative to the given path.
    public static func debuggerPath(_ path: Path) -> Path {
        XcodeProj.sharedDataPath(path) + "xcdebugger"
    }

    /// Returns breakpoints plist path relative to the given path.
    ///
    /// - Parameter path: `.xcodeproj` file path
    /// - Parameter schemeName: scheme name
    /// - Returns: breakpoints plist path relative to the given path.
    public static func breakPointsPath(_ path: Path) -> Path {
        XcodeProj.debuggerPath(path) + "Breakpoints_v2.xcbkptlist"
    }

    /// Writes all project breakpoints to the given path.
    ///
    /// - Parameter path: path to `.xcodeproj` file.
    /// - Parameter override: if project should be overridden. Default is true.
    ///   If true will remove all existing debugger data before writing.
    ///   If false will throw error if breakpoints file exists at the given path.
    public func writeBreakPoints(path: Path, override: Bool = true) throws {
        guard let sharedData = sharedData else { return }

        let debuggerPath = XcodeProj.debuggerPath(path)
        if override, debuggerPath.exists {
            try debuggerPath.delete()
        }
        try debuggerPath.mkpath()
        try sharedData.breakpoints?.write(path: XcodeProj.breakPointsPath(path), override: override)
    }
}
