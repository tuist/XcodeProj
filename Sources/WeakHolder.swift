// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
import Foundation

/**
 This protocol defines a box for an element.
 It's useful because we can declare both generic types (e.g. `WeakBox<T>`) and concrete types (e.g. `WeakProtocolBox`).
 */
public protocol WeakHolder {
    
    associatedtype Element
    
    /**
     A getter for the inner element. Likely, this var will be labeled as weak in your implementation.
     */
    var element: Element? { get }
    
    /**
     An initializer for the `WeakHolder`.
     This is useful to implement `map`.
     */
    init(element: Element?)
    
    /**
     A map function which returns another `WeakHolder`. This allows us to treat `WeakHolder` as a monad and create other `WeakHolders` from the current one.
     You do not need to implement this as it is implemented in the extension.
     */
    func map<T: AnyObject, U: WeakHolder>(_ transform: (Element) throws -> T) rethrows -> U where U.Element == T
}

extension WeakHolder {
    public func map<T: AnyObject, U: WeakHolder>(_ transform: (Element) throws -> T) rethrows -> U where U.Element == T {
        // First, we want to create a new element from the current element using the transform function provided
        let newElement = try element.flatMap(transform)
        // Then, we simply initialzed U with the new element.
        return U.init(element: newElement)
    }
}
