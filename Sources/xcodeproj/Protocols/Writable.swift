import Basic
import Foundation

/// Protocol that defines how an entity can be writed into disk
public protocol Writable {
    /// Writes the object that conforms the protocol.
    ///
    /// - Parameter path: The path to write to
    /// - Parameter override: True if the content should be overriden if it already exists.
    /// - Throws: writing error if something goes wrong.
    func write(path: AbsolutePath) throws

    /// Writes the object that conforms the protocol.
    ///
    /// - Parameter pathString: The path string to write to
    /// - Parameter override: True if the content should be overriden if it already exists.
    /// - Throws: writing error if something goes wrong.
    func write(pathString: String) throws
}

extension Writable {
    public func write(pathString: String) throws {
        let path = AbsolutePath(pathString)
        try write(path: path)
    }
}
