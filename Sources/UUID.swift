import Foundation
import CryptoSwift

// Object reference
public typealias UUID = String

internal func generateUUID(path: String) -> String {
    return path.md5().uppercased()
}
