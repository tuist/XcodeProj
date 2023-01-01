import Foundation
import PathKit

public final class XCSharedData: Equatable, Writable {
    // MARK: - Attributes

    /// Shared data schemes.
    public var schemes: [XCScheme]

    /// Shared data breakpoints.
    public var breakpoints: XCBreakpointList?

    /// Workspace settings (represents the WorksapceSettings.xcsettings file).
    public var workspaceSettings: WorkspaceSettings?

    // MARK: - Init

    /// Initializes the shared data with its properties.
    ///
    /// - Parameters:
    ///   - schemes: Shared data schemes.
    ///   - breakpoints: Shared data breakpoints.
    ///   - workspaceSettings: Workspace settings (represents the WorksapceSettings.xcsettings file).
    public init(schemes: [XCScheme],
                breakpoints: XCBreakpointList? = nil,
                workspaceSettings: WorkspaceSettings? = nil) {
        self.schemes = schemes
        self.breakpoints = breakpoints
        self.workspaceSettings = workspaceSettings
    }

    /// Initializes the XCSharedData reading the content from the disk.
    ///
    /// - Parameter path: path where the .xcshareddata is.
    public init(path: Path) throws {
        if !path.exists {
            throw XCSharedDataError.notFound(path: path)
        }
        schemes = path.glob("xcschemes/*.xcscheme")
            .compactMap { try? XCScheme(path: $0) }
        breakpoints = try? XCBreakpointList(path: XcodeProj.breakpointsPath(path))

        let workspaceSettingsPath = path + "WorkspaceSettings.xcsettings"
        if workspaceSettingsPath.exists {
            workspaceSettings = try WorkspaceSettings.at(path: workspaceSettingsPath)
        } else {
            workspaceSettings = nil
        }
    }

    // MARK: - Equatable

    public static func == (lhs: XCSharedData, rhs: XCSharedData) -> Bool {
        lhs.schemes == rhs.schemes &&
            lhs.breakpoints == rhs.breakpoints &&
            lhs.workspaceSettings == rhs.workspaceSettings
    }

    // MARK: - Writable

    public func write(path: Path, override: Bool) throws {
        try writeSchemes(path: path, override: override)
        try writeBreakpoints(path: path, override: override)
    }

    /// Writes all shared schemes to the given path.
    ///
    /// - Parameter path: xcshareddata folder
    /// - Parameter override: if project should be overridden. Default is true.
    ///   If true will remove all existing schemes before writing.
    ///   If false will throw error if scheme already exists at the given path.
    func writeSchemes(path: Path, override: Bool) throws {
        let schemesPath = XcodeProj.schemesPath(path)
        if override, schemesPath.exists {
            try schemesPath.delete()
        }

        try schemesPath.mkpath()
        for scheme in schemes {
            try scheme.write(path: XcodeProj.schemePath(path, schemeName: scheme.name), override: override)
        }
    }

    /// Writes all project breakpoints to the given path.
    ///
    /// - Parameter path: xcshareddata folder
    /// - Parameter override: if project should be overridden. Default is true.
    ///   If true will remove all existing debugger data before writing.
    ///   If false will throw error if breakpoints file exists at the given path.
    func writeBreakpoints(path: Path, override: Bool) throws {
        let debuggerPath = XcodeProj.debuggerPath(path)
        if override, debuggerPath.exists {
            try debuggerPath.delete()
        }

        try debuggerPath.mkpath()
        try breakpoints?.write(path: XcodeProj.breakpointsPath(path), override: override)
    }
}
