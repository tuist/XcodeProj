import Foundation

/// Generates unique deterministic reference. Must be reset if generating for a new project if totally deterministc references are wanted
public class ReferenceGenerator {

    static let shared = ReferenceGenerator()

    private var references: Set<String> = []

    public init() {

    }

    /// This resets all the cached references to again make them deterministic
    public func reset() {
        references = []
    }

    /// This generates a unique 20 character reference id to be used in ProjectElement.reference
    ///
    /// - Parameters:
    ///   - element: The type of Project Element to generate for
    ///   - uniqueId: some string value that uniquely defines the object.
    ///         It doesn't have to be completely unique as duplicates will be handled, but it provides deterministic references
    /// - Returns: The generated unique reference
    public func generateReference<T: ProjectElement>(_ element: T.Type, _ uniqueId: String) -> String {
        var reference = ""
        var counter = 0
        let className = String(describing: T.self).replacingOccurrences(of: "PBX", with: "")
        let classAcronym = String(className.characters.filter { String($0).lowercased() != String($0) })
        let uniqueHash = String(abs(uniqueId.hashValue).description.characters.prefix(18 - classAcronym.characters.count))
        repeat {
            counter += 1
            reference = "\(classAcronym)\(uniqueHash)\(String(format: "%02d", counter))"
        } while (references.contains(reference))
        references.insert(reference)
        return reference
    }}
