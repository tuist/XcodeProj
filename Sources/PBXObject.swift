import Foundation

/// Class that represents a project element.
public class PBXObject: Referenceable {

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

    public static var isa: String {
        return String(describing: self)
    }

    public static func parse(reference: String, dictionary: [String: Any]) throws -> PBXObject {
        guard let isa = dictionary["isa"] as? String else { throw PBXObjectError.missingIsa }
        switch isa {
        case PBXNativeTarget.isa:
            return try PBXNativeTarget(reference: reference, dictionary: dictionary)
        case PBXAggregateTarget.isa:
            return try PBXAggregateTarget(reference: reference, dictionary: dictionary)
        case PBXBuildFile.isa:
            return try PBXBuildFile(reference: reference, dictionary: dictionary)
        case PBXFileReference.isa:
            return try PBXFileReference(reference: reference, dictionary: dictionary)
        case PBXProject.isa:
            return try PBXProject(reference: reference, dictionary: dictionary)
        case PBXFileElement.isa:
            return try PBXFileElement(reference: reference, dictionary: dictionary)
        case PBXGroup.isa:
            return try PBXGroup(reference: reference, dictionary: dictionary)
        case PBXHeadersBuildPhase.isa:
            return try PBXHeadersBuildPhase(reference: reference, dictionary: dictionary)
        case PBXFrameworksBuildPhase.isa:
            return try PBXFrameworksBuildPhase(reference: reference, dictionary: dictionary)
        case XCConfigurationList.isa:
            return try XCConfigurationList(reference: reference, dictionary: dictionary)
        case PBXResourcesBuildPhase.isa:
            return try PBXResourcesBuildPhase(reference: reference, dictionary: dictionary)
        case PBXShellScriptBuildPhase.isa:
            return try PBXShellScriptBuildPhase(reference: reference, dictionary: dictionary)
        case PBXSourcesBuildPhase.isa:
            return try PBXSourcesBuildPhase(reference: reference, dictionary: dictionary)
        case PBXTargetDependency.isa:
            return try PBXTargetDependency(reference: reference, dictionary: dictionary)
        case PBXVariantGroup.isa:
            return try PBXVariantGroup(reference: reference, dictionary: dictionary)
        case XCBuildConfiguration.isa:
            return try XCBuildConfiguration(reference: reference, dictionary: dictionary)
        case PBXCopyFilesBuildPhase.isa:
            return try PBXCopyFilesBuildPhase(reference: reference, dictionary: dictionary)
        case PBXContainerItemProxy.isa:
            return try PBXContainerItemProxy(reference: reference, dictionary: dictionary)
        default:
            throw PBXObjectError.unknownElement(isa)
        }
    }
}

/// PBXObjectError
///
/// - missingIsa: the isa attribute is missing.
/// - unknownElement: the object type is not supported.
public enum PBXObjectError: Error, CustomStringConvertible {
    case missingIsa
    case unknownElement(String)

    public var description: String {
        switch self {
        case .missingIsa:
            return "Isa property is missing"
        case .unknownElement(let element):
            return "The element \(element) is not supported"
        }
    }
}

extension Array where Element: Referenceable {

    var references: [String] {
        return map { $0.reference }
    }

    func contains(reference: String) -> Bool {
        return contains { $0.reference == reference }
    }

    func getReference(_ reference: String) -> Element? {
        return first { $0.reference == reference }
    }
}

public protocol Referenceable {
    var reference: String { get }
}
