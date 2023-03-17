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
        schemes = XCScheme.schemesPath(path)
            .glob("*.xcscheme")
            .compactMap { try? XCScheme(path: $0) }

        breakpoints = try? XCBreakpointList(path: XCBreakpointList.path(XCDebugger.path(path)))

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
        try writeWorkspaceSettings(path: path, override: override)
    }

    func writeSchemes(path: Path, override: Bool) throws {
        let schemesPath = XCScheme.schemesPath(path)
        if override, schemesPath.exists {
            try schemesPath.delete()
        }

        guard !schemes.isEmpty else { return }

        try schemesPath.mkpath()
        for scheme in schemes {
            let schemePath = XCScheme.path(path, schemeName: scheme.name)
            try scheme.write(path: schemePath, override: override)
        }
    }

    func writeBreakpoints(path: Path, override: Bool) throws {
        let debuggerPath = XCDebugger.path(path)
        if override, debuggerPath.exists {
            try debuggerPath.delete()
        }

        guard let breakpoints = breakpoints else { return }

        try debuggerPath.mkpath()
        try breakpoints.write(path: XCBreakpointList.path(debuggerPath), override: override)
    }
    
    func writeWorkspaceSettings(path: Path, override: Bool) throws {
        /**
         * We don't want to delete this path when `override` is `true` because
         * that will delete everything in the folder, including schemes and breakpoints.
         * Instead, just create the path if it doesn't exist and let the `write` method
         * in `WorkspaceSettings` handle the override.
         */
        if !path.exists {
            try path.mkpath()
        }
 
        try workspaceSettings?.write(path: WorkspaceSettings.path(path), override: override)
    }
}

extension XCSharedData {
    /// Returns shared data path relative to the given path.
    ///
    /// - Parameter path: `.xcodeproj` file path
    /// - Returns: shared data path relative to the given path.
    public static func path(_ path: Path) -> Path {
        path + "xcshareddata"
    }
}
