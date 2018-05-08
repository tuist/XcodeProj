import Basic
import Foundation

// MARK: - PBXProj Error

enum PBXProjError: Error, CustomStringConvertible {
    case notFound(path: AbsolutePath)
    var description: String {
        switch self {
        case let .notFound(path):
            return ".pbxproj not found at path \(path.asString)"
        }
    }
}
