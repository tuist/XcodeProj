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
    ///   - userName: User name
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

        let schemesPath = XCScheme.schemesPath(path)
        schemes = schemesPath
            .glob("*.xcscheme")
            .compactMap { try? XCScheme(path: $0) }
        schemeManagement = try? XCSchemeManagement(path: XCSchemeManagement.path(schemesPath))

        breakpoints = try? XCBreakpointList(path: XCBreakpointList.path(XCDebugger.path(path)))
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

    func writeSchemes(path: Path, override: Bool) throws {
        guard !schemes.isEmpty else { return }

        try XCScheme.schemesPath(path).mkpath()
        for scheme in schemes {
            let schemePath = XCScheme.path(path, schemeName: scheme.name)
            try scheme.write(path: schemePath, override: override)
        }
    }

    func writeSchemeManagement(path: Path, override: Bool) throws {
        guard let schemeManagement = schemeManagement else { return }

        let schemesPath = XCScheme.schemesPath(path)
        try schemesPath.mkpath()
        try schemeManagement.write(path: XCSchemeManagement.path(schemesPath), override: override)
    }

    func writeBreakpoints(path: Path, override: Bool) throws {
        guard let breakpoints = breakpoints else { return }

        let debuggerPath = XCDebugger.path(path)
        try debuggerPath.mkpath()
        try breakpoints.write(path: XCBreakpointList.path(debuggerPath), override: override)
    }
}

extension XCUserData {
    /// Returns user data path relative to the given path.
    ///
    /// - Parameter path: `.xcodeproj` file path
    /// - Returns: user data path relative to the given path.
    public static func path(_ path: Path) -> Path {
        path + "xcuserdata"
    }

    /// Returns user data path for a specific user relative to the given path.
    ///
    /// - Parameter path: `.xcodeproj` file path
    /// - Returns: user data path relative to the given path.
    public static func path(_ path: Path, userName: String) -> Path {
        XCUserData.path(path) + "\(userName).xcuserdatad"
    }
}
