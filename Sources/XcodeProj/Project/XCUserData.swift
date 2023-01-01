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
        breakpoints = try? XCBreakpointList(path: XcodeProj.breakpointsPath(path))
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
        try writeSchemes(path: path, override: override)
        try writeBreakpoints(path: path, override: override)
        try writeSchemeManagement(path: path, override: override)
    }

    /// Writes all user schemes to the given path.
    ///
    /// - Parameter path: xcuserdata folder
    /// - Parameter override: if project should be overridden.
    ///   If true will overrwrite a specific scheme
    ///   If false will throw error if scheme already exists at the given path.
    ///   Note that this will preserve any existing schemes that are already present in the user schemes folder
    func writeSchemes(path: Path, override: Bool) throws {
        try XcodeProj.schemesPath(path).mkpath()
        for scheme in schemes {
            try scheme.write(path: XcodeProj.schemePath(path, schemeName: scheme.name), override: override)
        }
    }

    /// Writes all user breakpoints to the given path.
    ///
    /// - Parameter path: path to xcuserdata folder
    /// - Parameter override: if project should be overridden..
    ///   If true will remove all existing debugger data before writing.
    ///   If false will throw error if breakpoints file exists at the given path.
    func writeBreakpoints(path: Path, override: Bool) throws {
        try XcodeProj.debuggerPath(path).mkpath()
        try breakpoints?.write(path: XcodeProj.breakpointsPath(path), override: override)
    }

    /// Writes scheme management to the given path.
    ///
    /// - Parameter path: path to xcuserdata folder
    /// - Parameter override: if data should be overridden..
    ///   If true will remove all existing scheme management data before writing.
    ///   If false will throw error if  scheme management file exists at the given path.
    func writeSchemeManagement(path: Path, override: Bool) throws {
        let schemeManagementPath = XcodeProj.schemeManagementPath(path)
        try path.mkpath()
        try schemeManagement?.write(path: schemeManagementPath, override: override)
    }
}
