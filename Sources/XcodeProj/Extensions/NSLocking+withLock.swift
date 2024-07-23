import Foundation

// reimplemention of `withLock` from `NSLocking` extension that is exclusive to the macOS version of `Foundation`
extension NSLocking {
  func withLock<T>(_ body: () throws -> T) rethrows -> T {
    lock()
    defer { unlock() }
    return try body()
  }
}

