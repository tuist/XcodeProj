import Foundation

/// Static initializer that creates a Dictionary from a .plist file.
///
/// - Parameter path: the path of the .plist file.
/// - Returns: initialized dictionary.
func loadPlist(path: String) -> Dictionary<String, AnyObject>? {
    return NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject>
}
