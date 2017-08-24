import Foundation

/// Class that represents a project element.
public class ProjectElement: Referenceable, Hashable {

    public var hashValue: Int { return self.reference.hashValue }

    /// Element unique reference.
    public var reference: String = ""

    init(reference: String) {
        self.reference = reference
    }

    /// Constructor that initializes the project element with the reference and a dictionary with its properties.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: dictionary with the element properties.
    /// - Throws: throws an error in case any of the propeties are missing or they have the wrong type.
    init(reference: String, dictionary: [String: Any]) throws {
        self.reference = reference
    }

    public static func == (lhs: ProjectElement,
                           rhs: ProjectElement) -> Bool {
        return lhs.reference == rhs.reference
    }
}

public protocol Referenceable {
    var reference: String { get }
}
