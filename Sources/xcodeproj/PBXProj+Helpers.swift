import Basic
import Foundation

// MARK: - PBXProj Extension (Public)

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

// MARK: - PBXProj Extension (Getters)

extension PBXProj {
    /// Infers project name from Path and sets it as project name
    ///
    /// Project name is needed for certain comments when serialising PBXProj
    ///
    /// - Parameters:
    ///   - path: path to .xcodeproj directory.
    func updateProjectName(path: AbsolutePath) throws {
        guard path.parentDirectory.extension == "xcodeproj" else {
            return
        }
        let projectName = path.parentDirectory.components.last?.split(separator: ".").first
        try rootProject()?.name = projectName.map(String.init) ?? ""
    }
}

// MARK: - PBXProj extension (Writable)

extension PBXProj: Writable {
    public func write(path: AbsolutePath, override: Bool) throws {
        let encoder = PBXProjEncoder()
        let output = try encoder.encode(proj: self)
        if override && path.exists {
            try path.delete()
        }
        try path.write(output)
    }
}
