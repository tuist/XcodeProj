import Basic
import Foundation

public extension PBXProj {
    /// Returns root project.
    public func rootProject() throws -> PBXProject? {
        return try rootObject?.object()
    }

    /// Returns root project's root group.
    public func rootGroup() throws -> PBXGroup? {
        let project = try rootProject()
        return try project?.mainGroup.object()
    }
}
