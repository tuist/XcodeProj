import Foundation
import Unbox
import PathKit
import AEXML

public extension XCWorkspace {
    
    public struct Data: Equatable {
        
        /// Workspace file reference.
        public struct FileRef: Hashable, ExpressibleByStringLiteral {
            
            /// Location of the file
            public let location: String
            
            // MARK: - Init
            
            /// Initializes the FileRef with the location.
            ///
            /// - Parameter location: location of the file reference.
            public init(location: String) {
                self.location = location
            }
            
            // MARK: - Hashable
            
            public var hashValue: Int { return self.location.hashValue }
            
            public static func == (lhs: FileRef,
                                   rhs: FileRef) -> Bool {
                return lhs.location == rhs.location
            }
            
            // MARK: - ExpressibleByStringLiteral
            
            public init(stringLiteral value: String) {
                self.location = value
            }
            
            public init(extendedGraphemeClusterLiteral value: String) {
                self.location = value
            }
            
            public init(unicodeScalarLiteral value: String) {
                self.location = value
            }
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
        
        // MARK: - Public
        
        /// Returns a new XCWorkspaceData adding a reference.
        ///
        /// - Parameter reference: reference to be added.
        /// - Returns: XCWorkspaceData with the reference addeed.
        public func adding(reference: FileRef) -> XCWorkspace.Data {
            var references = self.references
            references.append(reference)
            return Data(path: path,
                        references: references)
        }
        
        /// Returns a new XCWorkspaceData removing a reference.
        ///
        /// - Parameter reference: reference to be removed.
        /// - Returns: new XCWorkspaceData with the reference removed.
        public func removing(reference: FileRef) -> XCWorkspace.Data {
            var references = self.references
            if let index = references.index(of: reference) {
                references.remove(at: index)
            }
            return Data(path: path,
                        references: references)
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
        
        // MARK: - Equatable
        
        public static func == (lhs: XCWorkspace.Data,
                               rhs: XCWorkspace.Data) -> Bool {
            return lhs.path == rhs.path &&
                lhs.references == rhs.references
        }
        
    }
    
}
