import Foundation
import PathKit
import AEXML

final public class XCSharedData {

    // MARK: - Attributes

    /// Shared data schemes.
    public var schemes: [XCScheme]

    /// Shared data breakpoints.
    public var breakpoints: [XCBreakpoint]

    // MARK: - Init

    /// Initializes the shared data with its properties.
    ///
    /// - Parameters:
    ///   - schemes: shared data schemes.
    ///   - breakpoints: shared data breakpoints.
    public init(schemes: [XCScheme], breakpoints: [XCBreakpoint]) {
        self.schemes = schemes
        self.breakpoints = breakpoints
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
        self.breakpoints = path.glob("xcdebugger/Breakpoints_v2.xcbkptlist")
            .flatMap { try? XCBreakpoint(path: $0) }
    }

}

// MARK: - XCSharedData Extension (Writable)

extension XCSharedData: Writable {

    public func writeBreakpoints(path: Path, override: Bool) throws {
        try write(path: path, override: override)
    }

    public func write(path: Path, override: Bool) throws {
        let document = AEXMLDocument()
        if override && path.exists {
            try path.delete()
        }
        try path.write(document.xml)
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
