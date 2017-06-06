import Foundation
import Unbox
import PathKit
import AEXML
import Protocols

// MARK: - XCWorkspace model
public extension XCWorkspace {
    
    public struct Data: Equatable, Writable {
        
        public enum FileRef: Hashable, ExpressibleByStringLiteral, CustomStringConvertible {
            case project(path: Path)
            case file(path: Path)
            case other(location: String)
            
            // MARK: - Init
            
            init(string: String, path: Path? = nil) {
                var location = string
                if location == "self:",
                    let path = path, (path + Path("..")).parent().string.contains(".xcodeproj") {
                    self = .project(path: (path + Path("..")).parent())
                } else if location.contains("self:") {
                    location = location.replacingOccurrences(of: "self:", with: "")
                    let path = Path(location)
                    if location.contains(".xcodeproj") {
                        self = .project(path: path)
                    } else {
                        self = .file(path: path)
                    }
                } else {
                    self = .other(location: string)
                }
            }
            
            // MARK: - <CustomStringConvertible>
            
            public var description: String {
                switch self {
                case .project(let path): return "self:\(path.string)"
                case .file(let path): return "self:\(path.string)"
                case .other(let location): return location
                }
            }
            
            // MARK: - <ExpressibleByStringLiteral>
            
            public init(stringLiteral value: String) {
                self.init(string: value)
            }
            
            public init(extendedGraphemeClusterLiteral value: String) {
                self.init(string: value)
            }
            
            public init(unicodeScalarLiteral value: String) {
                self.init(string: value)
            }
            
            // MARK: - Public
            
            public var project: XcodeProj? {
                switch self {
                case .project(let path):
                    return try? XcodeProj(path: path)
                default:
                    return nil
                }
            }
            
            // MARK: - Hashable
            
            public var hashValue: Int {
                switch self {
                case .file(let path):
                    return path.hashValue
                case .project(let path):
                    return path.hashValue
                case .other(let location):
                    return location.hashValue
                }
            }
            
            public static func == (lhs: FileRef,
                                   rhs: FileRef) -> Bool {
                switch (lhs, rhs) {
                case (.file(let lhsPath), .file(let rhsPath)):
                    return lhsPath == rhsPath
                case (.project(let lhsPath), .project(let rhsPath)):
                    return lhsPath == rhsPath
                case (.other(let lhsLocation), .other(let rhsLocation)):
                    return lhsLocation == rhsLocation
                default:
                    return false
                }
            }
            
        }
        
        /// Workspace file reference.
        
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
            let xml = try AEXMLDocument(xml: data)
            self.references = xml
                .root
                .all!
                .map { $0["FileRef"].attributes["location"] }
                .filter { $0 != nil }
                .map { FileRef(string: $0!, path: path) }
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
        
        // MARK: - <Writable>
        
        public func write(override: Bool = true) throws {
            let document = AEXMLDocument()
            let workspace = document.addChild(name: "Workspace", value: nil, attributes: ["version": "1.0"])
            references.forEach { (reference) in
                workspace.addChild(name: "FileRef",
                                   value: nil,
                                   attributes: ["location": "\(reference)"])
            }
            let fm = FileManager.default
            if override && fm.fileExists(atPath: path.string) {
                try fm.removeItem(atPath: path.string)
            }
            try Foundation.Data(base64Encoded: document.string)?.write(to: path.url)
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
