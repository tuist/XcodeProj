import Foundation

// MARK: - Decodable Extension

extension Decodable {
    /// Initialies the Decodable object with a JSON dictionary.
    ///
    /// - Parameter jsonDictionary: json dictionary.
    /// - Throws: throws an error if the initialization fails.
    init(jsonDictionary: [String: Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
        let decoder = XcodeprojJSONDecoder(
            context: ProjectDecodingContext(jsonDictionary: jsonDictionary)
        )
        self = try decoder.decode(Self.self, from: data)
    }
}
