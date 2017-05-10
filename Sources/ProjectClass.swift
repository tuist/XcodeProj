import Foundation

/// Protocol that represents a project element.
public protocol ProjectElement: Hashable {

    /// String with the element name.
    var isa: String { get }

    /// Element unique reference.
    var reference: UUID { get }

    /// Constructor that initializes the project element with the reference and a dictionary with its properties.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: dictionary with the element properties.
    /// - Throws: throws an error in case any of the propeties are missing or they have the wrong type.
    init(reference: UUID, dictionary: [String: Any]) throws
}
