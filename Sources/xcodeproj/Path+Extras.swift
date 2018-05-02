import Foundation
import Basic

// MARK: - AbsolutePath extras.

extension AbsolutePath {

    /// Returns true if a file exists at the given path.
    var exists: Bool {
        return FileManager.default.fileExists(atPath: self.asString)
    }
    
    /// Returns last path component without the extension.
    var lastComponentWithoutExtension: String {
        return self.components.last?.split(separator: ".").first.map(String.init) ?? ""
    }
    
    /// Deletes the file at the given path.
    ///
    /// - Throws: an error if the deletion fails.
    func delete() throws {
        try FileManager.default.removeItem(atPath: self.asString)
    }
    
    /// Writes the string atomically into a file at the given path.
    ///
    /// - Parameter content: content to be written.
    /// - Throws: an error if the writing fails.
    func write(_ content: String) throws {
        try content.write(toFile: self.asString, atomically: true, encoding: .utf8)
    }
    
    /// Reads the content (string) at the given path.
    ///
    /// - Returns: file content.
    /// - Throws: an error if the content cannot be read.
    func read() throws -> String {
        return try String.init(contentsOf: URL(fileURLWithPath: self.asString))
    }
}
