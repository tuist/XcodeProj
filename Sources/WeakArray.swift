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
 This typealias allows you to create a `WeakArray` with any class type.
 e.g.
 `var weakArray = WeakArray<ConsistencyManager>()`
 */
public typealias WeakArray<T: AnyObject> = AnyWeakArray<WeakBox<T>>

/**
 This class defines an array which doesn't hold strong references to its elements.
 If an element in the array gets dealloced at some point, accessing that element will just return nil.
 It takes advantage of out Array+Weak extension, so all the functions here are just pass throughs to the Array class.
 You cannot put structs into the WeakArray because structs cannot be declared with weak. You can only put classes into the array.
 KNOWN BUGS
 You can't create a WeakArray<SomeProtocol>. This is because of an Apple bug: https://bugs.swift.org/browse/SR-1176.
 So, instead of this, it's recommended to create your own wrapper class and create a typealias (as seen above).
 */

public struct AnyWeakArray<T: WeakHolder>: ExpressibleByArrayLiteral {
    
    // MARK: Internal
    /// The internal data is an array of closures which return weak T's
    fileprivate var data: [T]
    
    // MARK: Initializers
    /**
     Creates an empty array
     */
    public init() {
        data = []
    }
    
    /**
     Creates an array with a certain capacity. All elements in the array will be nil.
     */
    public init(count: Int) {
        data = Array(repeating: T(element: nil), count: count)
    }
    
    /**
     Array literal initializer. Allows you to initialize a WeakArray with array notation.
     */
    public init(arrayLiteral elements: T.Element?...) {
        data = elements.map { element in
            return T.init(element: element)
        }
    }
    
    /**
     Creates an array with the inner type `[T]` where T is a WeakHolder.
     */
    public init(_ data: [T]) {
        self.data = data
    }
    
    // MARK: Public Properties
    /// How many elements the array stores
    public var count: Int {
        return data.count
    }
    
    // MARK: Public Methods
    /**
     Append an element to the array.
     */
    public mutating func append(_ element: T.Element?) {
        data.append(T.init(element: element))
    }
    
    /**
     This method iterates through the array and removes any element which is nil.
     It also returns an array of nonoptional values for convenience.
     This method runs in O(n), so you should only call this method every time you need it. You should only call it once.
     */
    public mutating func prune() -> [T.Element] {
        return data.prune()
    }
    
    /**
     This function is similar to the map function on Array.
     It takes a function that maps T to U and returns a WeakArray of the same length with this function applied to each element.
     It does not prune any nil elements as part of this map so the resulting count will be equal to the current count.
     */
    public func map<U>(_ transform: (T.Element?) throws -> U.Element?) rethrows -> AnyWeakArray<U> {
        let newArray: [U] = try data.map(transform)
        return AnyWeakArray<U>(newArray)
    }
    
    /**
     This function is similar to the flatMap function on Array.
     It takes a function that maps T to U? and returns a WeakArray with this function applied to each element.
     It automatically prunes any nil elements as part of this flatMap and removes them.
     */
    public func flatMap<U>(_ transform: (T.Element?) throws -> U.Element?) rethrows -> AnyWeakArray<U> {
        let newArray: [U] = try data.flatMap(transform)
        return AnyWeakArray<U>(newArray)
    }
    
    /**
     This function is similar to the filter function on Array.
     The `isIncluded` closure simply returns whether you want the element in the array.
     */
    public func filter(_ isIncluded: (T.Element?) throws -> Bool) rethrows -> AnyWeakArray<T> {
        let newArray: [T] = try data.filter(isIncluded)
        return AnyWeakArray<T>(newArray)
    }
}

// MARK: MutableCollectionType Implementation
extension AnyWeakArray: MutableCollection {
    
    // Required by SequenceType
    public func makeIterator() -> IndexingIterator<AnyWeakArray<T>> {
        // Rather than implement our own generator, let's take advantage of the generator provided by IndexingGenerator
        return IndexingIterator<AnyWeakArray<T>>(_elements: self)
    }
    
    // Required by _CollectionType
    public func index(after i: Int) -> Int {
        return data.index(after: i)
    }
    
    // Required by _CollectionType
    public var endIndex: Int {
        return data.endIndex
    }
    
    // Required by _CollectionType
    public var startIndex: Int {
        return data.startIndex
    }
    
    /**
     Getter and setter array
     */
    public subscript(index: Int) -> T.Element? {
        get {
            return data[index].element
        }
        set {
            data[index] = T.init(element: newValue)
        }
    }
}
