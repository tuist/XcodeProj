import Foundation
import PathKit

/// This protocol defines the interface to write project files to disk.
protocol FileWriting {
    /// Gracefully writes project data to disk:
    ///  1. If the content hasn't changed, it doesn't override the existing file.
    ///  2. If the content has changed, it overrides the existing file.
    ///
    /// - Parameters:
    ///   - data: Data to be writen.
    ///   - to: Path where the data will be written to.
    /// - Throws: An error if the write fails
    /// - Returns: True if the file was writen.
    @discardableResult
    func write(data: Data, to: Path) throws -> Bool

    /// Gracefully writes project strings to disk:
    ///  1. If the content hasn't changed, it doesn't override the existing file.
    ///  2. If the content has changed, it overrides the existing file.
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
    /// Gracefully writes project data to disk:
    ///  1. If the content hasn't changed, it doesn't override the existing file.
    ///  2. If the content has changed, it overrides the existing file.
    ///
    /// - Parameters:
    ///   - data: Data to be writen.
    ///   - to: Path where the data will be written to.
    /// - Throws: An error if the write fails
    /// - Returns: True if the file was writen.
    @discardableResult
    func write(data: Data, to: Path) throws -> Bool {
        var existingData: Data?
        if to.exists {
            existingData = try to.read()
        }
        if existingData == data {
            return false
        }
        let temporaryPath = try Path.uniqueTemporary() + to.lastComponent
        try temporaryPath.write(data)
        _ = try FileManager.default.replaceItemAt(to.url, withItemAt: temporaryPath.url)
        return true
    }

    /// Gracefully writes project strings to disk:
    ///  1. If the content hasn't changed, it doesn't override the existing file.
    ///  2. If the content has changed, it overrides the existing file.
    ///
    /// - Parameters:
    ///   - string: String to be writen.
    ///   - to: Path where the data will be written to.
    /// - Throws: An error if the write fails
    /// - Returns: True if the file was writen.
    @discardableResult
    func write(string: String, to: Path) throws -> Bool {
        var existingString: String?
        if to.exists {
            existingString = try to.read()
        }
        if existingString == string {
            return false
        }
        let temporaryPath = try Path.uniqueTemporary() + to.lastComponent
        try temporaryPath.write(string)
        _ = try FileManager.default.replaceItemAt(to.url, withItemAt: temporaryPath.url)
        return true
    }
}
