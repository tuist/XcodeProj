import Foundation
import PathKit
import xcodeprojextensions

/// Protocol that indicates that the entity can be initialized passing a path where the plist 
//  file is and the dictionary that represents the content in that plist.
public protocol PlistInitiatable {
    init(path: Path, dictionary: [String: Any]) throws
}

// MARK: - PlistInitiaable Extension (Convenience Initialization)

public extension PlistInitiatable {
    
    /// Convenience initializer that reads the plist content from the passed path.
    ///
    /// - Parameter path: path pointing to the plist file.
    /// - Throws: throws an error if the plist file cannot be found.
    init(path: Path) throws {
        guard let dictionary = loadPlist(path: path.string) else { throw PlistInitializationError.notFound(path: path) }
        try self.init(path: path, dictionary: dictionary as [String: Any])
    }
    
}

/// Error during the process of reading the plist file.
///
/// - notFound: the plist file cannot be found.
public enum PlistInitializationError: Error, CustomStringConvertible {
    case notFound(path: Path)
    
    /// <CustomStringConvertible> description
    
    public var description: String {
        switch self {
        case .notFound(let path):
            return "The plist file cannot be found: \(path)"
        }
    }
    
}
