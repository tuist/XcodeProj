import Foundation

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
    
    /// Default batch size
    static let defaultBatchSize: UInt = 30
    
    /// Batch size
    let batchSize: UInt
    
    init(batchSize: UInt = PBXObjectsParser.defaultBatchSize) {
        self.batchSize = batchSize
    }

    /// Parses the objects contained in the given dictionary.
    ///
    /// - Parameter objects: dictionary with the objects.
    /// - Returns: array with all the objects
    /// - Throws: an error if the parsing fails
    func parse(objects: [String: [String: Any]]) throws -> [PBXObject] {
        let bucketSize = UInt(UInt(objects.count) / batchSize)
        var count = 0
        var batchDictionary: [String: [String: Any]] = [:]
        var promises: [Promise<[PBXObject]>] = []
        objects.forEach { (key, value) in
            batchDictionary[key] = value
            count += 1
            if count == bucketSize {
                let copiedDictionary = batchDictionary
                let promise: Promise<[PBXObject]> = Promise { completion in
                    do {
                        let values = try copiedDictionary.flatMap { try PBXObject.parse(reference: $0.key, dictionary: $0.value) }
                        completion(values, nil)
                    } catch {
                        completion(nil, error)
                    }
                }
                promise.start()
                promises.append(promise)
                count = 0
                batchDictionary = [:]
            }
        }
        let result = promises.merge().wait()
        if let error = result.1 {
            throw error
        } else if let value = result.0 {
            return value.flatMap({$0})
        } else {
            return []
        }
    }
    
}
