import Foundation
import PathKit

// https://github.com/apple/swift-package-manager/blob/b3914444d0eaa11fe33126cc6be4ecd46aa08ce1/Sources/Xcodeproj/generate().swift
/// This protocol defines the interface to write project files to disk.
protocol FileWriting {
    /// Writes the given data to disk by writing it in a temporary path and then
    /// moving it to the given path.
    ///
    /// - Parameters:
    ///   - data: Data to be writen.
    ///   - to: Path where the data will be written to.
    /// - Throws: An error if the write fails
    /// - Returns: True if the file was writen.
    @discardableResult
    func write(data: Data, to: Path) throws -> Bool

    /// Writes the given string to disk by writing it in a temporary path and then
    /// moving it to the given path.
    ///
    /// - Parameters:
    ///   - string: String to be writen.
    ///   - to: Path where the data will be written to.
    /// - Throws: An error if the write fails
    /// - Returns: True if the file was writen.
    @discardableResult
    func write(string: String, to: Path) throws -> Bool
}

class FileWriter: FileWriting {
    /// Writes the given data to disk by writing it in a temporary path and then
    /// moving it to the given path.
    ///
    /// - Parameters:
    ///   - data: Data to be writen.
    ///   - to: Path where the data will be written to.
    /// - Throws: An error if the write fails
    /// - Returns: True if the file was writen.
    @discardableResult
    func write(data: Data, to: Path) throws -> Bool {
        if to.exists {
            if try Data(contentsOf: to.url) == data {
                return false
            }
        }
        try data.write(to: to.url, options: .atomic)
        return true
    }

    /// Writes the given string to disk by writing it in a temporary path and then
    /// moving it to the given path.
    ///
    /// - Parameters:
    ///   - string: String to be writen.
    ///   - to: Path where the data will be written to.
    /// - Throws: An error if the write fails
    /// - Returns: True if the file was writen.
    @discardableResult
    func write(string: String, to: Path) throws -> Bool {
        if to.exists {
            if try String(contentsOf: to.url) == string {
                return false
            }
        }
        try string.write(to: to.url, atomically: true, encoding: .utf8)
        return true
    }
}
