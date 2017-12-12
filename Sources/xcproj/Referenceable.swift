import Foundation

// Typealias that represents dictionary from string -> T where T is Referenceable (i.e. PBXObjects)

public protocol Referenceable {
    var reference: String { get }
}

public typealias ReferenceableCollection<T: Equatable> = [String: T]

extension Array where Element: Referenceable {

    public var references: [String] {
        return map { $0.reference }
    }

    public func contains(reference: String) -> Bool {
        return contains { $0.reference == reference }
    }

    public func getReference(_ reference: String) -> Element? {
        return first { $0.reference == reference }
    }
}

extension Dictionary where Key == String, Value: Referenceable {
    init(references: [Value]) {
        self = [String: Value](uniqueKeysWithValues: references.flatMap { ($0.reference, $0) })
    }

    public var references: [String] {
        return Array(self.keys)
    }

    public var referenceValues: [Value] {
        return self.values.map { $0 }
    }

    public func contains(reference: Key) -> Bool {
        return self[reference] != nil
    }

    public func getReference(_ reference: Key) -> Value? {
        return self[reference]
    }

    mutating public func append(_ value: Value, reference: String) {
        self[value.reference] = value
    }
}
