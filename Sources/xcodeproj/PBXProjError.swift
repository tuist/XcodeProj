import Foundation
import Basic

// MARK: - PBXProj Error

enum PBXProjError: Error, CustomStringConvertible {
    case notFound(path: AbsolutePath)
    var description: String {
        switch self {
        case .notFound(let path):
            return ".pbxproj not found at path \(path.asString)"
        }
    }
}
