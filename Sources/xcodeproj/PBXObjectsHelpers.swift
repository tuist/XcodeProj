import Basic
import Foundation

public enum XCodeProjEditingError: Error, CustomStringConvertible {
    case fileNotExists(path: AbsolutePath)
    case groupNotFound(group: PBXGroup)

    public var description: String {
        switch self {
        case let .fileNotExists(path):
            return "\(path.asString) does not exist"
        case let .groupNotFound(group):
            return "Group not found in project: \(group)"
        }
    }
}

// MARK: - PBXObjects Extension (Internal)

extension PBXObjects {
//
//    /// Returns the object with the given configuration list (project or target)
//    ///
//    /// - Parameter reference: configuration list reference.
//    /// - Returns: target or project with the given configuration list.
//    func objectWithConfigurationList(reference: String) -> PBXReferencedObject<PBXObject>? {
//        return projects.first(where: { $0.value.buildConfigurationList == reference }).flatMap({ PBXReferencedObject(reference: $0.key.value, object: $0.value) }) ??
//            nativeTargets.first(where: { $0.value.buildConfigurationList == reference }).flatMap({ PBXReferencedObject(reference: $0.key.value, object: $0.value) }) ??
//            aggregateTargets.first(where: { $0.value.buildConfigurationList == reference }).flatMap({ PBXReferencedObject(reference: $0.key.value, object: $0.value) }) ??
//            legacyTargets.first(where: { $0.value.buildConfigurationList == reference }).flatMap({ PBXReferencedObject(reference: $0.key.value, object: $0.value) })
//    }
}
