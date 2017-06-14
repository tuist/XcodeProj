import Foundation

/// Protocol that defines how an entity can be writed into disk
public protocol Writable {
    
    /// Writes the object that conforms the protocol.
    ///
    /// - Parameter override: True if the content should be overriden if it already exists.
    /// - Throws: writing error if something goes wrong.
    func write(override: Bool) throws

}
