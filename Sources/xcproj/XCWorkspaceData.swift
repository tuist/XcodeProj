import Foundation
import PathKit
import AEXML

// MARK: - XCWorkspace model
public extension XCWorkspace {

    final public class Data: Equatable, Writable {

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

        // MARK: - Attributes

        /// References to the workspace projects
        public var references: [FileRef]

        // MARK: - Init

        /// Initializes the XCWorkspaceData reading the content from the file at the given path.
        ///
        /// - Parameter path: path where the .xcworkspacedata is.
        public init(path: Path) throws {
            if !path.exists {
                throw XCWorkspaceDataError.notFound(path: path)
            }
            let xml = try AEXMLDocument(xml: path.read())
            self.references = xml
                .root
                .children
                .flatMap { $0.attributes["location"] }
                .map { FileRef(string: $0!, path: path) }
        }

        /// Initializes the XCWorkspaceData with its attributes.
        ///
        /// - Parameters:
        ///   - references: references to the files in the workspace.
        public init(references: [FileRef]) {
            self.references = references
        }

        // MARK: - Equatable

        public static func == (lhs: XCWorkspace.Data,
                               rhs: XCWorkspace.Data) -> Bool {
            return lhs.references == rhs.references
        }

        // MARK: - <Writable>

        public func write(path: Path, override: Bool = true) throws {
            let document = AEXMLDocument()
            let workspace = document.addChild(name: "Workspace", value: nil, attributes: ["version": "1.0"])
            references.forEach { (reference) in
                workspace.addChild(name: "FileRef",
                                   value: nil,
                                   attributes: ["location": "\(reference)"])
            }
            if override && path.exists {
                try path.delete()
            }
            try path.write(document.xml)
        }

    }

}

// MARK: - XCWorkspaceData Errors

/// XCWorkspaceData Errors.
///
/// - notFound: returned when the .xcworkspacedata cannot be found.
public enum XCWorkspaceDataError: Error, CustomStringConvertible {

    case notFound(path: Path)

    public var description: String {
        switch self {
        case .notFound(let path):
            return "Workspace not found at \(path)"
        }
    }

}
