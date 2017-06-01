import Foundation
import Unbox
import PathKit

public struct XCWorkspaceData {
    
    /// Workspace file reference.
    public struct FileRef {
        /// Location of the file
        public let location: String
    }
    
    /// MARK: - Attributes
    
    /// Path to the .xcworkspacedata file
    public let path: Path
    
    /// References to the workspace projects
    public let references: [FileRef]
    
    // MARK: - Init
    
    /// Initializes the XCWorkspaceData reading the content from the file at the given path.
    ///
    /// - Parameter path: path where the .xcworkspacedata is.
    public init(path: Path) {
        self.path = path
        self.references = []
    }
    
    /// Initializes the XCWorkspaceData with its attributes.
    ///
    /// - Parameters:
    ///   - path: path where the .xcworkspacedata is.
    ///   - references: references to the files in the workspace.
    public init(path: Path, references: [FileRef]) {
        self.path = path
        self.references = references
    }
    
}
