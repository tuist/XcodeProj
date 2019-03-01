import Foundation
import PathKit

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
        let temporaryPath = try Path.uniqueTemporary() + to.lastComponent
        try temporaryPath.write(data)
        _ = try FileManager.default.replaceItemAt(to.url, withItemAt: temporaryPath.url)
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
        let temporaryPath = try Path.uniqueTemporary() + to.lastComponent
        try temporaryPath.write(string)
        _ = try FileManager.default.replaceItemAt(to.url, withItemAt: temporaryPath.url)
        return true
    }
}
