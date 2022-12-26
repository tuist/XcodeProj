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
        breakpoints = try? XCBreakpointList(path: XcodeProj.breakPointsPath(path))

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
        try XcodeProj.writeSchemes(schemes: schemes, path: path, override: override)
        try XcodeProj.writeBreakPoints(breakpoints: breakpoints, path: path, override: override)
    }
}
