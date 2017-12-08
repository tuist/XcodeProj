import Foundation

// MARK: - Promising

protocol Promising {
    associatedtype T
    init(action: @escaping ((T?, Error?) -> Void) -> Void)
    func observe(observer: @escaping (T?, Error?) -> Void)
}

// MARK: - Promise

final class Promise<T>: Promising {
    
    /// Promise action.
    let action: ((T?, Error?) -> Void) -> Void
    
    /// Promise observers.
    fileprivate var observers: [(T?, Error?) -> Void] = []
    
    /// True if the promise is running.
    fileprivate var isRunning: Bool = false
    
    /// Promise result
    fileprivate var _result: (T?, Error?)?
    fileprivate var result: (T?, Error?)? {
        set {
            serialQueue.sync {
                self._result = newValue
                if let newValue = newValue {
                    observers.forEach({ $0(newValue.0, newValue.1) })
                }
                observers.removeAll()
            }
        }
        get {
            return serialQueue.sync {
                return self._result
            }
        }
    }
    
    /// Serial queue used to serialize the access to result.
    fileprivate let serialQueue: DispatchQueue = DispatchQueue(label: "Promise")

    /// Initialize the promise with the action
    ///
    /// - Parameter action: action that is executed when the Promise is observed.
    init(action: @escaping ((T?, Error?) -> Void) -> Void) {
        self.action = action
    }

    /// Observe the Promise
    ///
    /// - Parameter observer: observation closure
    func observe(observer: @escaping (T?, Error?) -> Void) {
        if let result = result {
            observer(result.0, result.1)
            return
        }
        observers.append(observer)
        if isRunning { return }
        isRunning = true
        action { (value, error) in
            self.result = (value, error)
            self.isRunning = false
        }
    }

    /// Starts the promise action
    func start() {
        self.observe(observer: { (_, _) in })
    }
    
}

// MARK: - Promise extension.

extension Promise {
    
    /// Waits until the promise finishes and returns the result synchronously.
    ///
    /// - Returns: promise result.
    func wait() -> (T?, Error?) {
        let semaphore = DispatchSemaphore(value: 0)
        var value: T?
        var error: Error?
        self.observe { (_value, _error) in
            value = _value
            error = _error
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .distantFuture)
        return (value, error)
    }
}

/// MARK: - Aggregated errors

struct AggregatedErrors: Error {
    var errors: [Error]
}


// MARK: - Array Extension <Promise>

extension Array where Element: Promising {
    
    /// Merges the results of multiple promises into a single promise.
    ///
    /// - Returns: promise merging the result of the promises
    func merge() -> Promise<[Element.T]> {
        return Promise { (completion) in
            var values: [Element.T] = []
            var errors: [Error] = []
            let queue: DispatchQueue = DispatchQueue(label: "Array<Promising>.mege")
            let group = DispatchGroup()
            self.forEach {
                group.enter()
                $0.observe { (value, error) in
                    queue.async {
                        if let value = value {
                            values.append(value)
                        } else if let error = error {
                            errors.append(error)
                        }
                        group.leave()
                    }
                }
            }
            _ = group.wait(timeout: .distantFuture)
            if !errors.isEmpty {
                completion(nil, AggregatedErrors(errors: errors))
            } else {
                completion(values, nil)
            }
        }
    }
    
}
