import Foundation
import PathKit

/// Protocol that defines how an entity can be writed into disk
public protocol Writable {
    
    /// Writes the object that conforms the protocol.
    ///
    /// - Parameter path: The path to write to
    /// - Parameter override: True if the content should be overriden if it already exists.
    /// - Throws: writing error if something goes wrong.
    func write(path: Path, override: Bool) throws

}
