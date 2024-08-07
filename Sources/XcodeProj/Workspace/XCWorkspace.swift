import Foundation
import PathKit

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
    public convenience init(path: Path) throws {
        if !path.exists {
            throw XCWorkspaceError.notFound(path: path)
        }
        let xcworkspaceDataPaths = path.glob("*.xcworkspacedata")
        if xcworkspaceDataPaths.isEmpty {
            self.init()
        } else {
            try self.init(data: XCWorkspaceData(path: xcworkspaceDataPaths.first!))
        }
    }

    /// Initializes a default workspace with a single reference that points to self:
    public convenience init() {
        let data = XCWorkspaceData(children: [.file(.init(location: .current("")))])
        self.init(data: data)
    }

    /// Initializes the workspace with the path string.
    ///
    /// - Parameter pathString: path string.
    /// - Throws: throws an error if the initialization fails.
    public convenience init(pathString: String) throws {
        try self.init(path: Path(pathString))
    }

    /// Initializes the workspace with its properties.
    ///
    /// - Parameters:
    ///   - data: workspace data.
    public init(data: XCWorkspaceData) {
        self.data = data
    }

    // MARK: - Writable

    public func write(path: Path, override: Bool = true) throws {
        let dataPath = path + "contents.xcworkspacedata"
        if override, dataPath.exists {
            if let existingContent: String = try? dataPath.read(),
               existingContent == data.rawContents() {
                // Raw data matches what's on disk
                // there's no need to overwrite the contents
                // this mitigates Xcode forcing users to
                // close and re-open projects/workspaces
                // on regeneration.
                return
            }
            try dataPath.delete()
        }
        try dataPath.mkpath()
        try data.write(path: dataPath)
    }

    public func dataRepresentation() throws -> Data? {
        data.rawContents().data(using: .utf8)
    }

    // MARK: - Equatable

    public static func == (lhs: XCWorkspace, rhs: XCWorkspace) -> Bool {
        lhs.data == rhs.data
    }
}
