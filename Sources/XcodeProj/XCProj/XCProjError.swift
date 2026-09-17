import Foundation

/// Errors raised while converting between the `project.xcproj` schema and the `PBXProj` object graph.
public enum XCProjError: Error, Equatable, CustomStringConvertible, Sendable {
    /// A build phase kind exists in the `project.xcproj` schema but has no counterpart in `PBXProj`.
    case unsupportedBuildPhase(kind: String)

    /// A reference into the groups and files tree could not be resolved.
    case unresolvedReference(String)

    /// A reference into the groups and files tree matched more than one element.
    case ambiguousReference(String)

    /// A build phase reference could not be resolved to a build phase of a target.
    case unresolvedBuildPhase(String)

    /// A build phase reference matched more than one build phase.
    case ambiguousBuildPhase(String)

    /// A target reference could not be resolved to a target of the project.
    case unresolvedTarget(String)

    /// A Swift package reference could not be resolved to a package of the project.
    case unresolvedPackage(String)

    /// A file path could not be represented in the `project.xcproj` schema.
    case invalidFilePath(path: String, sourceTree: String)

    /// The `PBXProj` has no root object, so there is nothing to encode.
    case missingRootObject

    /// An object that the schema requires to carry an identifier has none.
    case missingObjectID(String)

    /// The group tree contains an element kind that the `project.xcproj` schema cannot express.
    case unsupportedFileElement(String)

    /// A build file attribute from the schema has no established `project.pbxproj` spelling.
    case unsupportedBuildFileAttribute(String)

    /// A `project.pbxproj` build file carries an `ATTRIBUTES` token this library does not know.
    case unknownBuildFileAttribute(String)

    /// A line ending style has no counterpart in the other format.
    case unsupportedLineEnding(String)

    /// A copy files destination has no counterpart in the other format.
    case unsupportedCopyFilesDestination(String)

    public var description: String {
        switch self {
        case let .unsupportedBuildPhase(kind):
            "The build phase kind '\(kind)' has no representation in PBXProj"
        case let .unresolvedReference(reference):
            "The groups and files tree has no element matching '\(reference)'"
        case let .ambiguousReference(reference):
            "The groups and files tree has more than one element matching '\(reference)'"
        case let .unresolvedBuildPhase(reference):
            "No build phase matches '\(reference)'"
        case let .ambiguousBuildPhase(reference):
            "More than one build phase matches '\(reference)'"
        case let .unresolvedTarget(name):
            "The project has no target named '\(name)'"
        case let .unresolvedPackage(name):
            "The project has no Swift package named '\(name)'"
        case let .invalidFilePath(path, sourceTree):
            "The path '\(path)' relative to the source tree '\(sourceTree)' cannot be represented in a project.xcproj"
        case .missingRootObject:
            "The project has no root object"
        case let .missingObjectID(description):
            "\(description) requires an identifier but has none"
        case let .unsupportedFileElement(description):
            "\(description) has no representation in a project.xcproj"
        case let .unsupportedBuildFileAttribute(attribute):
            "The build file attribute '\(attribute)' has no established representation in a project.pbxproj"
        case let .unknownBuildFileAttribute(token):
            "The build file attribute '\(token)' is not a known ATTRIBUTES value"
        case let .unsupportedLineEnding(value):
            "The line ending style '\(value)' cannot be converted"
        case let .unsupportedCopyFilesDestination(value):
            "The copy files destination '\(value)' cannot be converted"
        }
    }
}
