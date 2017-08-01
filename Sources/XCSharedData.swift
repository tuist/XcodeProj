import Foundation
import PathKit

public struct XCSharedData {

    // MARK: - Attributes

    /// Shared data schemes.
    public var schemes: [XCScheme]

    // MARK: - Init

    /// Initializes the shared data with its properties.
    ///
    /// - Parameters:
    ///   - schemes: shared data schemes.
    public init(schemes: [XCScheme]) {
        self.schemes = schemes
    }

    /// Initializes the XCSharedData reading the content from the disk.
    ///
    /// - Parameter path: path where the .xcshareddata is.
    public init(path: Path) throws {
        if !path.exists {
            throw XCSharedDataError.notFound(path: path)
        }
        self.schemes = path.glob("xcschemes/*.xcscheme")
            .flatMap { try? XCScheme(path: $0) }
    }

}

/// XCSharedData errors.
///
/// - notFound: the share data hasn't been found.
public enum XCSharedDataError: Error, CustomStringConvertible {
    case notFound(path: Path)

    public var description: String {
        switch self {
        case .notFound(let path):
            return "xcshareddata not found at path \(path)"
        }
    }

}
