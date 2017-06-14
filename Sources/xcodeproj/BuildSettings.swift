import Foundation

/// Struct that represents the Xcode build settings.
public struct BuildSettings {
    
    // MARK: - Attributes
    
    public var dictionary: [String: String]
    
    // MARK: - Init
    
    /// Initializes the build settings with the dictionary that contains all the settings.
    ///
    /// - Parameter dictionary: build settings dictionary.
    public init(dictionary: [String: String]) {
        self.dictionary = dictionary
    }
    
    // MARK: - Public
    
    /// Returns the value for a given setting.
    ///
    /// - Parameter key: setting whose value will be returned.
    public subscript(key: String) -> String? {
        get {
            return self.dictionary[key]
        }
        set {
            self.dictionary[key] = newValue
        }
    }
    
}

// MARK: - BuildSettings Extension (ExpressibleByDictionaryLiteral)

extension BuildSettings: ExpressibleByDictionaryLiteral {
    
    public init(dictionaryLiteral elements: (String, String)...) {
        var dictionary: [String: String] = [:]
        elements.forEach { dictionary[$0.0] = $0.1 }
        self.dictionary = dictionary
    }
    
}
