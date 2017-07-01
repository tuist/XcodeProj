import Foundation

// MARK: - Bool Extension (Extras)

public extension Bool {

    /// Returns a XML string value that represents the boolean.
    var xmlString: String {
        return self ? "YES": "NO"
    }

}
