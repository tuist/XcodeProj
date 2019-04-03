import Foundation
import PathKit

// MARK: - Xcodeproj

/// XcodeProj Errors
///
/// - notFound: the project cannot be found.
/// - pbxProjNotFound: the .pbxproj file couldn't be found inside the project folder.
/// - xcworkspaceNotFound: the workspace cannot be found at the given path.
public enum XCodeProjError: Error, CustomStringConvertible {
    case notFound(path: Path)
    case pbxprojNotFound(path: Path)
    case xcworkspaceNotFound(path: Path)

    public var description: String {
        switch self {
        case let .notFound(path):
            return "The project cannot be found at \(path.string)"
        case let .pbxprojNotFound(path):
            return "The project doesn't contain a .pbxproj file at path: \(path.string)"
        case let .xcworkspaceNotFound(path):
            return "The project doesn't contain a .xcworkspace at path: \(path.string)"
        }
    }
}

// MARK: - Xcodeproj Editing

/// Xcodeproj editing errors.
///
/// - unexistingFile: the file doesn't exist.
public enum XcodeprojEditingError: Error, CustomStringConvertible {
    case unexistingFile(Path)

    public var description: String {
        switch self {
        case let .unexistingFile(path):
            return "The file at path \(path.string) doesn't exist"
        }
    }
}

// MARK: - PBXProj

/// PBXProj error.
///
/// - notFound: the .pbxproj cannot be found at the given path.
enum PBXProjError: Error, CustomStringConvertible {
    case invalidGroupPath(sourceRoot: Path, elementPath: String?)
    var description: String {
        switch self {
        case let .notFound(path):
            return ".pbxproj not found at path \(path.string)"
        case let .invalidGroupPath(sourceRoot, elementPath):
            return "Cannot calculate full path for file element \"\(elementPath ?? "")\" in source root: \"\(sourceRoot)\""
        }
    }
}

// MARK: - XCBreakpointList

/// XCBreakpointList error.
///
/// - missing: returned when there's a property missing in the Breakpoints_v2.xcbkptlist.
public enum XCBreakpointListError: Error, CustomStringConvertible {
    case missing(property: String)

    public var description: String {
        switch self {
        case let .missing(property):
            return "Property \(property) missing"
        }
    }
}
