import Basic
import Foundation

/// Model that represents a Xcode workspace.
public final class XCWorkspace: Writable, Equatable {
    /// Workspace data
    public var data: XCWorkspaceData

    // MARK: - Init

    /// Initializes the workspace with the path where the workspace is.
    /// The initializer will try to find an .xcworkspacedata inside the workspace.
    /// If the .xcworkspacedata cannot be found, the init will fail.
    ///
    /// - Parameter path: .xcworkspace path.
    /// - Throws: throws an error if the workspace cannot be initialized.
    public convenience init(path: AbsolutePath) throws {
        if !path.exists {
            throw XCWorkspaceError.notFound(path: path)
        }
        let xcworkspaceDataPaths = path.glob("*.xcworkspacedata")
        if xcworkspaceDataPaths.count == 0 {
            self.init()
        } else {
            try self.init(data: XCWorkspaceData(path: xcworkspaceDataPaths.first!))
        }
    }

    /// Initializes a default workspace with a single reference that points to self:
    public convenience init() {
        let data = XCWorkspaceData(children: [.file(.init(location: .self("")))])
        self.init(data: data)
    }

    /// Initializes the workspace with the path string.
    ///
    /// - Parameter pathString: path string.
    /// - Throws: throws an error if the initialization fails.
    public convenience init(pathString: String) throws {
        try self.init(path: AbsolutePath(pathString))
    }

    /// Initializes the workspace with its properties.
    ///
    /// - Parameters:
    ///   - data: workspace data.
    public init(data: XCWorkspaceData) {
        self.data = data
    }

    // MARK: - Writable

    public func write(path: AbsolutePath) throws {
        let dataPath = path.appending(component: "contents.xcworkspacedata")
        try dataPath.mkpath()
        try data.write(path: dataPath)
    }

    // MARK: - Equatable

    public static func == (_: XCWorkspace, rhs: XCWorkspace) -> Bool {
        return rhs.data == rhs.data
    }
}
