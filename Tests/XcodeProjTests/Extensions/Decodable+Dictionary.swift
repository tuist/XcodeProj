import Foundation
@testable import XcodeProj

extension Decodable {
    /// Initialies the Decodable object with a JSON dictionary.
    ///
    /// - Parameter jsonDictionary: json dictionary.
    /// - Throws: throws an error if the initialization fails.
    init(jsonDictionary: [String: PlistObject]) throws {
        let data = try JSONEncoder().encode(jsonDictionary)
        let decoder = XcodeprojJSONDecoder(
            context: ProjectDecodingContext(pbxProjValueReader: { key in
                jsonDictionary[key]
            })
        )
        self = try decoder.decode(Self.self, from: data)
    }
}
