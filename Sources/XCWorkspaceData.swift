import Foundation
import Unbox
import PathKit
import SWXMLHash

// MARK: - XCWorkspace model
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
        public init(path: Path, fileManager: FileManager = .default) throws {
            if !fileManager.fileExists(atPath: path.string) {
                throw XCWorkspaceDataError.notFound(path: path)
            }
            self.path = path
            let data = try Foundation.Data(contentsOf: path.url)
            let xml = SWXMLHash.parse(data)
            self.references = xml["Workspace"]
                .all
                .map { $0["FileRef"].element?.attribute(by: "location")?.text }
                .filter { $0 != nil }
                .map { FileRef(location: $0!) }
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

public enum XCWorkspaceDataError: Error, CustomStringConvertible {
    
    case notFound(path: Path)
    
    public var description: String {
        switch self {
        case .notFound(let path):
            return "Workspace not found at \(path)"
        }
    }
    
}
