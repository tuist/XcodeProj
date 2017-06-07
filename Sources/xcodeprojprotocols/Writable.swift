import Foundation

/// Protocol that defines how an entity can be writed into disk
public protocol Writable {
    func write(override: Bool) throws
}
