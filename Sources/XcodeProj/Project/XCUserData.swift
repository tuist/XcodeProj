import Foundation
import PathKit
import AEXML

public final class XCUserData: Equatable, Writable {
    // MARK: - Attributes

    /// User name
    public var userName: String

    /// User data schemes.
    public var schemes: [XCScheme]

    /// Metdata for schemes
    public var schemeManagement: XCSchemeManagement?

    /// User data breakpoints.
    public var breakpoints: XCBreakpointList?

    // MARK: - Init

    /// Initializes the shared data with its properties.
    ///
    /// - Parameters:
    ///   - schemes: User data schemes.
    ///   - breakpoints: User data breakpoints.
    ///   - schemeManagement: Metdata for schemes
    public init(userName: String,
                schemes: [XCScheme],
                breakpoints: XCBreakpointList? = nil,
                schemeManagement: XCSchemeManagement? = nil) {
        self.userName = userName
        self.schemes = schemes
        self.breakpoints = breakpoints
        self.schemeManagement = schemeManagement
    }

    /// Initializes the XCUserData reading the content from the disk.
    ///
    /// - Parameter path: path where the .xcuserdatad is.
    public init(path: Path) throws {
        if !path.exists {
            throw XCUserDataError.notFound(path: path)
        }
        userName = path.lastComponentWithoutExtension
        schemes = path.glob("xcschemes/*.xcscheme")
            .compactMap { try? XCScheme(path: $0) }
        breakpoints = try? XCBreakpointList(path: XcodeProj.breakPointsPath(path))
        schemeManagement = try? XCSchemeManagement(path: XcodeProj.schemeManagementPath(path))
    }

    // MARK: - Equatable

    public static func == (lhs: XCUserData, rhs: XCUserData) -> Bool {
        lhs.userName == rhs.userName &&
            lhs.schemes == rhs.schemes &&
            lhs.breakpoints == rhs.breakpoints &&
            lhs.schemeManagement == rhs.schemeManagement
    }

    // MARK: - Writable

    public func write(path: Path, override: Bool) throws {
        if override, path.exists {
            try path.delete()
        }

        try XcodeProj.writeSchemes(schemes: schemes, path: path, override: override)
        try XcodeProj.writeBreakPoints(breakpoints: breakpoints, path: path, override: override)
        try writeSchemeManagement(path: path, override: override)
    }

    /// Writes all project breakpoints to the given path.
    ///
    /// - Parameter path: path to xcuserdata folder
    /// - Parameter override: if project should be overridden. Default is true.
    ///   If true will remove all existing debugger data before writing.
    ///   If false will throw error if breakpoints file exists at the given path.
    public func writeSchemeManagement(path: Path, override: Bool) throws {
        let schemeManagementPath = XcodeProj.schemeManagementPath(path)
        try path.mkpath()
        try schemeManagement?.write(path: schemeManagementPath, override: override)
    }
}
