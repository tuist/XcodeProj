import Foundation

/// Controls how a `PBXProj` is written out as a `project.xcproj`.
public struct XCProjOutputSettings: Sendable, Equatable {
    /// Decides which objects carry an explicit identifier in the generated JSON.
    public enum ObjectIDPolicy: Sendable, Equatable {
        /// Emit an identifier only where the format requires one, or where a name based
        /// reference would be ambiguous.
        ///
        /// This is what Xcode itself does, and it keeps diffs small and readable.
        case minimal

        /// Emit the identifier of every object that can carry one.
        ///
        /// Useful when migrating an existing `project.pbxproj` and the existing UUIDs should
        /// survive the conversion, at the cost of a much noisier file.
        case preserveAll
    }

    /// The identifier policy applied while encoding.
    public var objectIDPolicy: ObjectIDPolicy

    /// The default settings, which emit as few identifiers as possible.
    public static let `default` = XCProjOutputSettings()

    public init(objectIDPolicy: ObjectIDPolicy = .minimal) {
        self.objectIDPolicy = objectIDPolicy
    }
}
