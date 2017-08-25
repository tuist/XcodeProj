
// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
import Foundation

extension Array where Element: WeakHolder {
    /**
     This method iterates through the array and removes any element which is nil.
     It also returns an array of nonoptional values for convenience.
     This method runs in O(n), so you should only call this method every time you need it. You should only call it once.
     */
    public mutating func prune() -> [Element.Element] {
        var nonOptionalElements: [Element.Element] = []
        self = self.filter { (element: Element.Element?) in
            if let element = element {
                nonOptionalElements.append(element)
                return true
            } else {
                return false
            }
        }
        return nonOptionalElements
    }
    
    /**
     This defines a map function which returns an array of WeakHolder.
     However, the `transform` function converts the inner elements (instead of the outer elements).
     This allows you to write code like:
     ```
     var array = [WeakStruct<UIViewController>(element: UIViewController())]()
     let viewArray: [WeakStruct<UIView>] = array.map { (viewController: UIViewController?) in
     return viewController?.view
     }
     ```
     Note how you need to specify the types of the map so it doesn't conflict with the default map.
     It will not prune out nil values so the resulting array will always maintain count.
     */
    public func map<T, U: WeakHolder>(_ transform: (Element.Element?) throws -> T?) rethrows -> [U] where U.Element == T {
        return try map { (weakHolder: Element) in
            let newElement = try transform(weakHolder.element)
            return U.init(element: newElement)
        }
    }
    
    /**
     This defines a flatMap function which returns an array of WeakHolder.
     However, the `transform` function converts the inner elements (instead of the outer elements).
     IMPORTANT: This function automatically runs a `prune()` as it goes as you may expect with `flatMap`.
     It will call the transform function on any inner element (including nil), but will filter out all nils in the final result.
     This allows you to write code like:
     ```
     var array = [WeakStruct<UIViewController>(element: UIViewController())]()
     let viewArray: [WeakStruct<UIView>] = array.flatMap { (viewController: UIViewController) in
     if viewController?.view.alpha == 0 {
     return nil
     }
     return viewController?.view
     }
     ```
     Note how you need to specify the types of the flatMap so it doesn't conflict with the default flatMap.
     */
    public func flatMap<T, U: WeakHolder>(_ transform: (Element.Element?) throws -> T?) rethrows -> [U] where U.Element == T {
        return try flatMap { (weakHolder: Element) in
            let newElement = try transform(weakHolder.element)
            return newElement.flatMap(U.init)
        }
    }
    
    /**
     This defines a filter function which returns an array of WeakHolder.
     However, the `isIncluded` function converts the inner elements (instead of the outer elements).
     This allows you to write code like:
     ```
     var array = [WeakStruct<UIViewController>(element: UIViewController())]()
     let viewArray: [WeakStruct<UIView>] = array.filter { (viewController: UIViewController?) in
     return (viewController?.view.alpha == 0) ?? false
     }
     ```
     Note how you need to specify the types of the flatMap so it doesn't conflict with the default flatMap.
     */
    public func filter(_ isIncluded: (Element.Element?) throws -> Bool) rethrows -> [Element] {
        return try filter { (weakHolder: Element) in
            return try isIncluded(weakHolder.element)
        }
    }
}
