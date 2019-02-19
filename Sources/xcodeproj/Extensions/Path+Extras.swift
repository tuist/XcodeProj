import Foundation
// swiftlint:disable all
import PathKit

// MARK: - Path extras.

extension Path {
    /// Creates a directory
    ///
    /// - Throws: an errof if the directory cannot be created.
    func mkpath(withIntermediateDirectories: Bool) throws {
        try FileManager.default.createDirectory(atPath: string, withIntermediateDirectories: withIntermediateDirectories, attributes: nil)
    }

    func relative(to path: Path) -> Path {
        return Path(normalize().string.replacingOccurrences(of: "\(path.normalize().string)/", with: ""))
    }
}

// swiftlint:enable all
