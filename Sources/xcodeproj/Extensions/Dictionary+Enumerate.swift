import Foundation

extension Dictionary {
    
    func enumerateKeysAndObjects(
        options opts: NSEnumerationOptions = [],
        using block: (Any, Any, UnsafeMutablePointer<ObjCBool>) throws -> Void) throws
    {
        var blockError: Error?
        (self as NSDictionary).enumerateKeysAndObjects(options: opts) { (key, obj, stops) in
            do {
                try block(key, obj, stops)
            } catch {
                blockError = error
            }
        }
        if let error = blockError {
            throw error
        }
    }
    
}
