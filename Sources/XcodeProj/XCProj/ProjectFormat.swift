import Foundation

/// The on-disk representation used to store an Xcode project inside an `.xcodeproj` bundle.
public enum ProjectFormat: String, Sendable, CaseIterable {
    /// The legacy OpenStep property list format, stored in `project.pbxproj`.
    case pbxproj

    /// The JSON5 based format introduced with Xcode 27, stored in `project.xcproj`.
    ///
    /// The format is documented and implemented by
    /// [apple/xcode-project-format](https://github.com/apple/xcode-project-format).
    case xcproj

    /// The name of the file that holds a project stored in this format.
    public var fileName: String {
        switch self {
        case .pbxproj: "project.pbxproj"
        case .xcproj: "project.xcproj"
        }
    }
}
