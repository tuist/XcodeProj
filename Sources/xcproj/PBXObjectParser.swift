import Foundation
import BrightFutures
import Result

/// Defines the interface for parsing objects
protocol PBXObjectsParsing {
    
    /// Parses the objects contained in the given dictionary.
    ///
    /// - Parameter objects: dictionary with the objects.
    /// - Returns: array with all the objects
    /// - Throws: an error if the parsing fails
    func parse(objects: [String: [String: Any]]) throws -> [PBXObject]
}

/// Default objects parser
final class PBXObjectsParser: PBXObjectsParsing {
    
    /// PBXObjectParser error.
    ///
    /// - decoding: decoding error.
    /// - other: other error.
    public enum ParsingError: Error {
        case decoding(DecodingError)
        case other(Error)
    }
    
    // MARK: - Attributes

    /// Parses the objects contained in the given dictionary.
    ///
    /// - Parameter objects: dictionary with the objects.
    /// - Returns: array with all the objects
    /// - Throws: an error if the parsing fails
    func parse(objects: [String: [String: Any]]) throws -> [PBXObject] {
        let multithread = false
        if multithread {
            return try objects.map { (input) in
                return Future<PBXObject, ParsingError> { completion in
                    DispatchQueue.global().async {
                        do {
                            let value = try PBXObject.parse(reference: input.key,
                                                            dictionary: input.value)
                            completion(.success(value))
                        } catch let decodingError as DecodingError {
                            completion(.failure(.decoding(decodingError)))
                        } catch {
                            completion(.failure(.other(error)))
                        }
                    }
                }
            }.sequence().forced().dematerialize()
        } else {
            return try objects.map { try PBXObject.parse(reference: $0.key,
                                                         dictionary: $0.value) }
        }
    }
    
}
