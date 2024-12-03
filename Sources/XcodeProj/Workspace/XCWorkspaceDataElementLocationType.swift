import Foundation

public enum XCWorkspaceDataElementLocationType {
    public enum Error: Swift.Error {
        case missingSchema
    }

    case absolute(String) // "Absolute path"
    case container(String) // "Relative to container"
    case developer(String) // "Relative to Developer Directory"
    case group(String) // "Relative to group"
    case current(String) // Single project workspace in xcodeproj directory
    case other(String, String)

    public var schema: String {
        switch self {
        case .absolute:
            "absolute"
        case .container:
            "container"
        case .developer:
            "developer"
        case .group:
            "group"
        case .current:
            "self"
        case let .other(schema, _):
            schema
        }
    }

    public var path: String {
        switch self {
        case let .absolute(path):
            path
        case let .container(path):
            path
        case let .developer(path):
            path
        case let .group(path):
            path
        case let .current(path):
            path
        case let .other(_, path):
            path
        }
    }

    public init(string: String) throws {
        let elements = string.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
        guard let schema = elements.first.map(String.init) else {
            throw Error.missingSchema
        }
        let path = String(elements.last ?? "")
        switch schema {
        case "absolute":
            self = .absolute(path)
        case "container":
            self = .container(path)
        case "developer":
            self = .developer(path)
        case "group":
            self = .group(path)
        case "self":
            self = .current(path)
        default:
            self = .other(schema, path)
        }
    }
}

extension XCWorkspaceDataElementLocationType: CustomStringConvertible {
    public var description: String {
        "\(schema):\(path)"
    }
}

extension XCWorkspaceDataElementLocationType: Equatable {
    public static func == (lhs: XCWorkspaceDataElementLocationType, rhs: XCWorkspaceDataElementLocationType) -> Bool {
        switch (lhs, rhs) {
        case let (.absolute(lhs), .absolute(rhs)):
            lhs == rhs
        case let (.container(lhs), .container(rhs)):
            lhs == rhs
        case let (.developer(lhs), .developer(rhs)):
            lhs == rhs
        case let (.group(lhs), .group(rhs)):
            lhs == rhs
        case let (.current(lhs), .current(rhs)):
            lhs == rhs
        case let (.other(lhs0, lhs1), .other(rhs0, rhs1)):
            lhs0 == rhs0 && lhs1 == rhs1
        default: false
        }
    }
}
