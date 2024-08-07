import Foundation

extension Dictionary where Key == String, Value == PlistObject{
    func enumerateKeysAndObjects(
        options opts: NSEnumerationOptions = [],
        using block: (String, PlistObject, UnsafeMutablePointer<ObjCBool>) throws -> Void
    ) throws {
        var blockError: Error?
        // For performance it is very important to create a separate dictionary instance.
        // (self as NSDictionary).enumerateKeys... - works much slower
        let dictionary = NSDictionary(dictionary: self)
        dictionary.enumerateKeysAndObjects(options: opts) { key, obj, stops in
            do {
                try block(key as! String, obj as! PlistObject, stops)
            } catch {
                blockError = error
                stops.pointee = true
            }
        }
        if let error = blockError {
            throw error
        }
    }
}
