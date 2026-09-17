import Foundation
import XcodeProjectFormat

// MARK: - PBXSourceTree <-> XCSchema.FilePath

extension XCSchema.FilePath {
    /// Builds a schema file path out of the `sourceTree` and `path` pair used by `PBXFileElement`.
    ///
    /// - Parameters:
    ///   - sourceTree: the source tree of the file element, if it has one.
    ///   - path: the path of the file element, if it has one.
    static func make(sourceTree: PBXSourceTree?, path: String?) throws -> XCSchema.FilePath {
        let path = path ?? ""
        let base: Base = switch sourceTree {
        case .absolute: .absolute
        case .sourceRoot: .project
        case .developerDir: .developer
        case .buildProductsDir: .buildProducts
        case .sdkRoot: .sdk
        case let .custom(variable): .sourceRoot(variable)
        // `<group>` and an absent source tree both mean "relative to the parent".
        // `.none` (an empty source tree) is what Xcode writes for absolute paths in some
        // very old projects, so it is normalized the same way `.group` is.
        case .some(PBXSourceTree.group), .some(PBXSourceTree.none), Optional<PBXSourceTree>.none: .group
        }

        // `FilePath` refuses a leading `/` or `~` unless the base is `.absolute`, and refuses an
        // absolute path with any other base. Reconcile the two rather than throwing, because a
        // `PBXFileElement` is free to hold that combination.
        let looksAbsolute = path.hasPrefix("/") || path.hasPrefix("~")
        if looksAbsolute, base != .absolute {
            return try XCSchema.FilePath(base: .absolute, path: path)
        }
        if !looksAbsolute, base == .absolute {
            throw XCProjError.invalidFilePath(path: path, sourceTree: sourceTree?.description ?? "")
        }
        return try XCSchema.FilePath(base: base, path: path)
    }

    /// The source tree a `PBXFileElement` needs to express this path.
    var pbxSourceTree: PBXSourceTree {
        switch base {
        case .absolute: .absolute
        case .group: .group
        case .project: .sourceRoot
        case .developer: .developerDir
        case .buildProducts: .buildProductsDir
        case .sdk: .sdkRoot
        case let .sourceRoot(variable): .custom(variable)
        }
    }

    /// The path a `PBXFileElement` needs to express this path, or `nil` when the path is empty.
    var pbxPath: String? {
        path.isEmpty ? nil : path
    }
}
