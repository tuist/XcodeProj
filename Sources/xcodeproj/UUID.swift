import Foundation
import CommonCrypto

// Object reference
public typealias UUID = String

/// Top level function that generates random UUID for referencing elements in the project files.
///
/// - Parameter reference: element reference.
/// - Returns: the generated UUID
func generateUUID(reference: String) -> String {

    guard let data = reference.data(using: String.Encoding.utf8) else { return "" }

    let hash = data.withUnsafeBytes { (bytes: UnsafePointer<Data>) -> [UInt8] in
        var hash: [UInt8] = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(bytes, CC_LONG(data.count), &hash)
        return hash
    }

    return hash.map { String(format: "%02x", $0) }.joined().uppercased()
}
