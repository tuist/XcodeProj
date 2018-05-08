import Basic
import Foundation

// MARK: - PBXProj Extension (Public)

public extension PBXProj {
    /// Returns root project.
    public var rootProject: PBXProject? {
        return objects.projects.getReference(rootObject)
    }

    /// Returns root project's root group.
    public var rootGroup: PBXGroup {
        guard let rootProject = self.rootProject else {
            fatalError("Missing root project")
        }
        guard let rootGroup: PBXGroup = objects.getReference(rootProject.mainGroup) as? PBXGroup else {
            fatalError("Root project has no root group")
        }
        return rootGroup
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
    func updateProjectName(path: AbsolutePath) {
        guard path.parentDirectory.extension == "xcodeproj" else {
            return
        }
        let projectName = path.parentDirectory.components.last?.split(separator: ".").first
        let rootProject = objects.projects.getReference(rootObject)
        rootProject?.name = projectName.map(String.init) ?? ""
    }
}

// MARK: - PBXProj extension (Writable)

extension PBXProj: Writable {
    public func write(path: AbsolutePath, override: Bool) throws {
        let encoder = PBXProjEncoder()
        let output = encoder.encode(proj: self)
        if override && path.exists {
            try path.delete()
        }
        try path.write(output)
    }
}
