import Foundation
import XcodeProjectFormat

/// The naming rules the two formats have to agree on.
///
/// `project.xcproj` omits a reference's `name` whenever it equals the last component of its path,
/// so the decoder and the encoder have to derive that component the same way or converted projects
/// would gain or lose names on every round trip. `XcodeProjectFormat` has its own definition, but
/// it is `package` scoped, so it is restated here once rather than twice.
enum XCProjNaming {
    /// The last component of a path, as `NSString` defines it.
    static func lastComponent(of path: String) -> String {
        (path as NSString).lastPathComponent
    }

    /// The name a file element is known by inside the groups and files tree.
    static func name(of element: PBXFileElement) -> String {
        element.name ?? element.path.map(lastComponent(of:)) ?? ""
    }
}

extension XCSchema.FilePath {
    /// The last component of the path.
    var lastPathComponent: String {
        XCProjNaming.lastComponent(of: path)
    }
}
