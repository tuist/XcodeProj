import Foundation
import PathKit

/// Protocol that defines how an entity can be written to disk
public protocol Writable {
    /// Writes the object that conforms the protocol.
    ///
    /// - Parameter path: The path to write to
    /// - Parameter override: True if the content should be overridden if it already exists.
    /// - Throws: writing error if something goes wrong.
    func write(path: Path, override: Bool) throws

    /// Writes the object that conforms the protocol.
    ///
    /// - Parameter pathString: The path string to write to
    /// - Parameter override: True if the content should be overridden if it already exists.
    /// - Throws: writing error if something goes wrong.
    func write(pathString: String, override: Bool) throws

    /// Gets the data representation of the object that conforms to the protocol.
    ///
    /// - Throws: error if encoding to Data fails.
    func dataRepresentation() throws -> Data?
}

public extension Writable {
    func write(pathString: String, override: Bool) throws {
        let path = Path(pathString)
        try write(path: path, override: override)
    }

    func dataRepresentation() throws -> Data? { nil }
}
