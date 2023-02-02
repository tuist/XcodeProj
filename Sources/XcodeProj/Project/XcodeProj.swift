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

    /// User data.
    public var userData: [XCUserData]

    // MARK: - Init

    public init(path: Path) throws {
        var pbxproj: PBXProj!
        var workspace: XCWorkspace!
        var sharedData: XCSharedData?
        var userData: [XCUserData]

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

        userData = XCUserData.path(path)
            .glob("*.xcuserdatad")
            .compactMap { try? XCUserData(path: $0) }

        self.pbxproj = pbxproj
        self.workspace = workspace
        self.sharedData = sharedData
        self.userData = userData
    }

    public convenience init(pathString: String) throws {
        try self.init(path: Path(pathString))
    }

    /// Initializes the XCodeProj
    ///
    /// - Parameters:
    ///   - workspace: project internal workspace.
    ///   - pbxproj: project .pbxproj.
    ///   - sharedData: shared data
    ///   - userData: user data
    public init(workspace: XCWorkspace,
                pbxproj: PBXProj,
                sharedData: XCSharedData? = nil,
                userData: [XCUserData] = []) {
        self.workspace = workspace
        self.pbxproj = pbxproj
        self.sharedData = sharedData
        self.userData = userData
    }

    // MARK: - Equatable

    public static func == (lhs: XcodeProj, rhs: XcodeProj) -> Bool {
        lhs.workspace == rhs.workspace &&
            lhs.pbxproj == rhs.pbxproj &&
            lhs.sharedData == rhs.sharedData &&
            lhs.userData == rhs.userData
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
        try writeSharedData(path: path, override: override)
        try writeUserData(path: path, override: override)
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
        XCSharedData.path(path)
    }

    /// Writes shared data to the given path.
    ///
    /// - Parameter path: path to `.xcodeproj` file.
    /// - Parameter override: if shared data should be overridden. Default is true.
    /// - Parameter outputSettings: Controls the writing of various files.
    ///   If false will throw error if shared data already exists at the given path.
    public func writeSharedData(path: Path, override: Bool = true) throws {
        try sharedData?.write(path: XCSharedData.path(path), override: override)
    }

    /// Writes user data to the given path.
    ///
    /// - Parameter path: path to `.xcodeproj` file.
    /// - Parameter override: if user data should be overridden. Default is true.
    /// - Parameter outputSettings: Controls the writing of various files.
    ///   If false will throw error if user data already exists at the given path.
    public func writeUserData(path: Path, override: Bool = true) throws {
        for userData in userData {
            try userData.write(path: XCUserData.path(path, userName: userData.userName), override: override)
        }
    }

    /// Returns shared schemes folder path relative to the given path.
    ///
    /// - Parameter path: `.xcodeproj` file path
    /// - Returns: schemes folder path relative to the given path.
    @available(*, deprecated, message: "use XCScheme.schemesPath(path:)")
    public static func schemesPath(_ path: Path) -> Path {
        XCScheme.schemesPath(sharedDataPath(path))
    }

    /// Returns shared scheme file path relative to the given path.
    ///
    /// - Parameter path: `.xcodeproj` file path
    /// - Parameter schemeName: scheme name
    /// - Returns: scheme file path relative to the given path.
    @available(*, deprecated, message: "use XCScheme.path(path:schemeName)")
    public static func schemePath(_ path: Path, schemeName: String) -> Path {
        XCScheme.path(schemesPath(path), schemeName: schemeName)
    }

    /// Writes all project schemes to the given path.
    ///
    /// - Parameter path: path to `.xcodeproj` file.
    /// - Parameter override: if project should be overridden. Default is true.
    ///   If true will remove all existing schemes before writing.
    ///   If false will throw error if scheme already exists at the given path.
    public func writeSchemes(path: Path, override: Bool = true) throws {
        try sharedData?.writeSchemes(path: XCSharedData.path(path), override: override)

        for userData in userData {
            let userDataPath = XCUserData.path(path, userName: userData.userName)
            try userData.writeSchemes(path: userDataPath, override: override)
        }
    }

    /// Returns shared debugger folder path relative to the given path.
    ///
    /// - Parameter path: `.xcodeproj` file path
    /// - Parameter schemeName: scheme name
    /// - Returns: debugger folder path relative to the given path.
    @available(*, deprecated, message: "use XCDebugger.path(path:)")
    public static func debuggerPath(_ path: Path) -> Path {
        XCDebugger.path(XCSharedData.path(path))
    }

    /// Returns shared breakpoints plist path relative to the given path.
    ///
    /// - Parameter path: `.xcodeproj` file path
    /// - Parameter schemeName: scheme name
    /// - Returns: breakpoints plist path relative to the given path.
    @available(*, deprecated, message: "use XCBreakpointList.path(path:)")
    public static func breakPointsPath(_ path: Path) -> Path {
        XCBreakpointList.path(debuggerPath(path))
    }

    /// Writes all project breakpoints to the given path.
    ///
    /// - Parameter path: path to `.xcodeproj` file.
    /// - Parameter override: if project should be overridden. Default is true.
    ///   If true will remove all existing debugger data before writing.
    ///   If false will throw error if breakpoints file exists at the given path.
    public func writeBreakPoints(path: Path, override: Bool = true) throws {
        let sharedDataPath = XcodeProj.sharedDataPath(path)
        try sharedData?.writeBreakpoints(path: sharedDataPath, override: override)

        for userData in userData {
            let userDataPath = XCUserData.path(path, userName: userData.userName)
            try userData.writeBreakpoints(path: userDataPath, override: override)
        }
    }
}
