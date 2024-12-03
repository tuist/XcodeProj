import Foundation

public enum XCWorkspaceDataElement: Equatable {
    public enum Error: Swift.Error {
        case unknownName(String)
    }

    case file(XCWorkspaceDataFileRef)
    case group(XCWorkspaceDataGroup)

    /// Returns the location to the workspace data element.
    public var location: XCWorkspaceDataElementLocationType {
        switch self {
        case let .file(ref):
            ref.location
        case let .group(ref):
            ref.location
        }
    }

    // MARK: - Equatable

    public static func == (lhs: XCWorkspaceDataElement, rhs: XCWorkspaceDataElement) -> Bool {
        switch (lhs, rhs) {
        case let (.file(lhs), .file(rhs)):
            lhs == rhs
        case let (.group(lhs), .group(rhs)):
            lhs == rhs
        default:
            false
        }
    }
}
