import Foundation

/// Static initializer that creates a Dictionary from a .plist file.
///
/// - Parameter path: the path of the .plist file.
/// - Returns: initialized dictionary.
public func loadPlist(path: String) -> [String: PlistObject]? {
    let fileURL = URL(fileURLWithPath: path)
    guard let data = try? Data(contentsOf: fileURL) else { return nil }
    return try? PropertyListDecoder().decode([String: PlistObject].self, from: data)
}
