import Foundation

/// Struct that represents the Xcode build settings.
public final class BuildSettings {
    
    // MARK: - Attributes
    
    public var dictionary: [String: Any]
    
    // MARK: - Init
    
    /// Initializes the build settings with the dictionary that contains all the settings.
    ///
    /// - Parameter dictionary: build settings dictionary.
    public init(dictionary: [String: Any]) {
        self.dictionary = dictionary
    }
    
    // MARK: - Public
    
    /// Returns the value for a given setting.
    ///
    /// - Parameter key: setting whose value will be returned.
    public subscript(key: String) -> Any? {
        get {
            return self.dictionary[key]
        }
        set {
            self.dictionary[key] = newValue
        }
    }
    
}

// MARK: - BuildSettings Extension (Equatable)

extension BuildSettings: Equatable {
    
    public static func == (lhs: BuildSettings,
                           rhs: BuildSettings) -> Bool {
        return NSDictionary(dictionary: lhs.dictionary)
            .isEqual(to: NSDictionary(dictionary: rhs.dictionary))
    }
    
}

// MARK: - BuildSettings Extension (ExpressibleByDictionaryLiteral)

extension BuildSettings: ExpressibleByDictionaryLiteral {
    
    public convenience init(dictionaryLiteral elements: (String, String)...) {
        var dictionary: [String: String] = [:]
        elements.forEach { dictionary[$0.0] = $0.1 }
        self.init(dictionary: dictionary)
    }
    
}
