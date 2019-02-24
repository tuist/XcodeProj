import Foundation
import PathKit

// MARK: - Xcodeproj

/// XcodeProj Errors
///
/// - notFound: the project cannot be found.
/// - pbxProjNotFound: the .pbxproj file couldn't be found inside the project folder.
/// - xcworkspaceNotFound: the workspace cannot be found at the given path.
/// - cantOverrideExisting: the project can't be written because there's another directory.
public enum XCodeProjError: Error, CustomStringConvertible, Equatable {
    case notFound(path: Path)
    case pbxprojNotFound(path: Path)
    case xcworkspaceNotFound(path: Path)
    case cantOverrideExisting(path: Path)

    public var description: String {
        switch self {
        case let .notFound(path):
            return "The project cannot be found at \(path.string)"
        case let .pbxprojNotFound(path):
            return "The project doesn't contain a .pbxproj file at path: \(path.string)"
        case let .xcworkspaceNotFound(path):
            return "The project doesn't contain a .xcworkspace at path: \(path.string)"
        case let .cantOverrideExisting(path):
            return "The project can't be written at path \(path.string) where there's another project"
        }
    }
}

// MARK: - XCSharedData

/// XCSharedData errors.
///
/// - notFound: the share data hasn't been found.
public enum XCSharedDataError: Error, CustomStringConvertible {
    case notFound(path: Path)

    public var description: String {
        switch self {
        case let .notFound(path):
            return "xcshareddata not found at path \(path.string)"
        }
    }
}

// MARK: - XCWorkspace

/// XCWorkspace Errors
///
/// - notFound: the project cannot be found.
public enum XCWorkspaceError: Error, CustomStringConvertible {
    case notFound(path: Path)

    public var description: String {
        switch self {
        case let .notFound(path):
            return "The project cannot be found at \(path.string)"
        }
    }
}

// MARK: - XCWorkspaceData

/// XCWorkspaceData Errors.
///
/// - notFound: thrown when the .xcworkspacedata cannot be found.
/// - cantOverrideExisting: thrown when the workspace data can't be written because there's a file at the given path.
public enum XCWorkspaceDataError: Error, CustomStringConvertible {
    case notFound(path: Path)
    case cantOverrideExisting(path: Path)

    public var description: String {
        switch self {
        case let .notFound(path):
            return "Workspace not found at \(path.string)"
        case let .cantOverrideExisting(path):
            return "The workspace data can't be written at path \(path.string) where there's another file"
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

// MARK: - Xcodeproj Writing

/// Xcodeproj writing error.
///
/// - invalidType: the type that is being written is invalid.
public enum XcodeprojWritingError: Error, CustomStringConvertible {
    case invalidType(class: String, expected: String)

    public var description: String {
        switch self {
        case let .invalidType(classType, expected):
            return "Invalid type for object \(classType) that expects a \(expected)"
        }
    }
}

// MARK: - PBXObject

/// PBXObject error.
///
/// - missingIsa: the isa attribute is missing.
/// - unknownElement: the element that is being parsed is not supported.
/// - objectsReleased: the project has been released or the object hasn't been added to any project.
/// - objectNotFound: the object annot be found in the project.
/// - orphaned: the object doesn't belong to any project.
public enum PBXObjectError: Error, CustomStringConvertible {
    case missingIsa
    case unknownElement(String)
    case objectsReleased
    case objectNotFound(String)
    case orphaned(type: String, reference: String)

    public var description: String {
        switch self {
        case .missingIsa:
            return "Isa property is missing."
        case let .unknownElement(element):
            return "The element \(element) is not supported."
        case .objectsReleased:
            return "The PBXObjects instance has been released before saving."
        case let .objectNotFound(reference):
            return "PBXObject with reference \"\(reference)\" not found."
        case let .orphaned(type, reference):
            return "Trying to use object \(type) with reference '\(reference)' before being added to any project"
        }
    }
}

// MARK: - PBXProjEncoder

/// PBXProjEncoder error.
///
/// - emptyProjectReference: the project reference is missing.
enum PBXProjEncoderError: Error, CustomStringConvertible {
    case emptyProjectReference

    var description: String {
        switch self {
        case .emptyProjectReference:
            return "PBXProj should contain a reference to the XcodeProj object that represents the project"
        }
    }
}

// MARK: - PBXProj

/// PBXProj error.
///
/// - notFound: the .pbxproj cannot be found at the given path.
/// - cantOverrideExisting: the .pbxproj can't be written because there's another .pbxproj at the given path.
enum PBXProjError: Error, CustomStringConvertible, Equatable {
    case notFound(path: Path)
    case cantOverrideExisting(path: Path)

    var description: String {
        switch self {
        case let .notFound(path):
            return ".pbxproj not found at path \(path.string)"
        case let .cantOverrideExisting(path):
            return "The .pbxproj can't be written at path \(path.string) where there's another file"
        }
    }
}

// MARK: - XCBreakpointList

/// XCBreakpointList error.
///
/// - notFound: thrown when the Breakpoints_v2.xcbkptlist cannot be found.
/// - missing: thrown when there's a property missing in the Breakpoints_v2.xcbkptlist.
/// - cantOverrideExisting: thrown when the breapoint list can't be written because there's another list at the given path.
public enum XCBreakpointListError: Error, CustomStringConvertible {
    case notFound(path: Path)
    case missing(property: String)
    case cantOverrideExisting(path: Path)

    public var description: String {
        switch self {
        case let .notFound(path):
            return "Breakpoints_v2.xcbkptlist couldn't be found at path \(path.string)"
        case let .missing(property):
            return "Property \(property) missing"
        case let .cantOverrideExisting(path):
            return "The breakpoint list can't be written at path \(path.string) where there's another list"
        }
    }
}

// MARK: - XCConfig

/// XCConfig errors.
///
/// - notFound: thrown when the configuration file couldn't be found.
/// - cantOverrideExisting: thrown when the xcconfig can't be written because there'a another file at the given path.
public enum XCConfigError: Error, CustomStringConvertible {
    case notFound(path: Path)
    case cantOverrideExisting(path: Path)

    public var description: String {
        switch self {
        case let .notFound(path):
            return ".xcconfig file not found at \(path.string)"
        case let .cantOverrideExisting(path):
            return "The xcconfig file can't be written at path \(path.string) where there's another file"
        }
    }
}

// MARK: - XCScheme

/// XCScheme errors
///
/// - notFound: thrown when the scheme doesn't exist at the given path.
/// - missing: thrown when a property is missing while parsing the scheme.
/// - cantOverrideExisting: thrown when the scheme can't be written because there's another scheme at the given path.
public enum XCSchemeError: Error, CustomStringConvertible {
    case notFound(path: Path)
    case missing(property: String)
    case cantOverrideExisting(path: Path)

    public var description: String {
        switch self {
        case let .notFound(path):
            return ".xcscheme couldn't be found at path \(path.string)"
        case let .missing(property):
            return "Property \(property) missing"
        case let .cantOverrideExisting(path):
            return "The scheme can't be written at path \(path.string) where there's another scheme"
        }
    }
}
