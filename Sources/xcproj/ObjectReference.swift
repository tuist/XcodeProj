import Foundation

/// contains a PBXObject as well as it's reference
public class ObjectReference<T: PBXObject> {

    public let reference: String
    public let object: T
    
    public init(reference: String, object: T) {
        self.reference = reference
        self.object = object
    }
}

extension Dictionary where Key == String, Value: PBXObject {

    public var objectReferences: [ObjectReference<Value>] {
        return self.map(ObjectReference.init)
    }
}
