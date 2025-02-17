import Foundation
@preconcurrency import PathKit

// MARK: - Xcodeproj

/// XcodeProj Errors
///
/// - notFound: the project cannot be found.
/// - pbxProjNotFound: the .pbxproj file couldn't be found inside the project folder.
/// - xcworkspaceNotFound: the workspace cannot be found at the given path.
public enum XCodeProjError: Error, CustomStringConvertible, Sendable {
    case notFound(path: Path)
    case pbxprojNotFound(path: Path)
    case xcworkspaceNotFound(path: Path)

    public var description: String {
        switch self {
        case let .notFound(path):
            "The project cannot be found at \(path.string)"
        case let .pbxprojNotFound(path):
            "The project doesn't contain a .pbxproj file at path: \(path.string)"
        case let .xcworkspaceNotFound(path):
            "The project doesn't contain a .xcworkspace at path: \(path.string)"
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
            "xcshareddata not found at path \(path.string)"
        }
    }
}

// MARK: - XCUserData

/// XCUserData errors.
///
/// - notFound: the user data hasn't been found.
public enum XCUserDataError: Error, CustomStringConvertible {
    case notFound(path: Path)

    public var description: String {
        switch self {
        case let .notFound(path):
            "xcuserdata not found at path \(path.string)"
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
            "The project cannot be found at \(path.string)"
        }
    }
}

// MARK: - XCWorkspaceData

/// XCWorkspaceData Errors.
///
/// - notFound: returned when the .xcworkspacedata cannot be found.
public enum XCWorkspaceDataError: Error, CustomStringConvertible {
    case notFound(path: Path)

    public var description: String {
        switch self {
        case let .notFound(path):
            "Workspace not found at \(path.string)"
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
            "The file at path \(path.string) doesn't exist"
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
            "Invalid type for object \(classType) that expects a \(expected)"
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
    case missingReference
    case unknownElement(String)
    case objectsReleased
    case objectNotFound(String)
    case orphaned(type: String, reference: String)

    public var description: String {
        switch self {
        case .missingIsa:
            "Isa property is missing."
        case let .unknownElement(element):
            "The element \(element) is not supported."
        case .objectsReleased:
            "The PBXObjects instance has been released before saving."
        case let .objectNotFound(reference):
            "PBXObject with reference \"\(reference)\" not found."
        case let .orphaned(type, reference):
            "Trying to use object \(type) with reference '\(reference)' before being added to any project"
        case .missingReference:
            "Missing reference value"
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
            "PBXProj should contain a reference to the XcodeProj object that represents the project"
        }
    }
}

// MARK: - PBXProj

/// PBXProj error.
///
/// - notFound: the .pbxproj cannot be found at the given path.
enum PBXProjError: Error, CustomStringConvertible, Equatable {
    case notFound(path: Path)
    case invalidGroupPath(sourceRoot: Path, elementPath: String?)
    case targetNotFound(targetName: String)
    case frameworksBuildPhaseNotFound(targetName: String)
    case sourcesBuildPhaseNotFound(targetName: String)
    case pathIsAbsolute(Path)
    case multipleLocalPackages(productName: String)
    case multipleRemotePackages(productName: String)
    case malformed
    var description: String {
        switch self {
        case let .notFound(path):
            ".pbxproj not found at path \(path.string)"
        case let .invalidGroupPath(sourceRoot, elementPath):
            "Cannot calculate full path for file element \"\(elementPath ?? "")\" in source root: \"\(sourceRoot)\""
        case let .targetNotFound(targetName):
            "Could not find target with \(targetName)"
        case let .frameworksBuildPhaseNotFound(targetName):
            "Could not find frameworks build phase for target \(targetName)"
        case let .sourcesBuildPhaseNotFound(targetName):
            "Could not find sources build phase for target \(targetName)"
        case let .pathIsAbsolute(path):
            "Path must be relative, but path \(path.string) is absolute"
        case let .multipleLocalPackages(productName: productName):
            "Found multiple top-level packages named \(productName)"
        case let .multipleRemotePackages(productName: productName):
            "Can not resolve dependency \(productName) - conflicting version requirements"
        case .malformed:
            "The .pbxproj is malformed."
        }
    }
}

// MARK: - XCBreakpointList

/// XCBreakpointList error.
///
/// - notFound: returned when the Breakpoints_v2.xcbkptlist cannot be found.
/// - missing: returned when there's a property missing in the Breakpoints_v2.xcbkptlist.
public enum XCBreakpointListError: Error, CustomStringConvertible {
    case notFound(path: Path)
    case missing(property: String)

    public var description: String {
        switch self {
        case let .notFound(path):
            "Breakpoints_v2.xcbkptlist couldn't be found at path \(path.string)"
        case let .missing(property):
            "Property \(property) missing"
        }
    }
}

// MARK: - XCConfig

/// XCConfig errors.
///
/// - notFound: returned when the configuration file couldn't be found.
public enum XCConfigError: Error, CustomStringConvertible {
    case notFound(path: Path)
    public var description: String {
        switch self {
        case let .notFound(path):
            ".xcconfig file not found at \(path.string)"
        }
    }
}
