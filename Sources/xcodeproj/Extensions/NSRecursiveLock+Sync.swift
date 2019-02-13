import Foundation

extension NSRecursiveLock {
    func sync<T>(closure: () -> (T)) -> T {
        lock()
        let value = closure()
        unlock()
        return value
    }
}
