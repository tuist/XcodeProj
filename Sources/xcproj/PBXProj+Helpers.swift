import Foundation
import PathKit

// MARK: - PBXProj Extension (Getters)

extension PBXProj {

    /// Infers project name from Path and sets it as project name
    ///
    /// Project name is needed for certain comments when serialising PBXProj
    ///
    /// - Parameters:
    ///   - path: path to .xcodeproj directory.
    func updateProjectName(path: Path) {
        guard path.parent().extension == "xcodeproj" else {
            return
        }
        let projectName = path.parent().lastComponentWithoutExtension
        let rootProject = objects.projects.getReference(rootObject)
        rootProject?.name = projectName
    }

}

// MARK: - PBXProj extension (Writable)

extension PBXProj: Writable {

    public func write(path: Path, override: Bool) throws {
        let encoder = PBXProjEncoder()
        let output = encoder.encode(proj: self)
        if override && path.exists {
            try path.delete()
        }
        try path.write(output)
    }

}

// MARK: - PBXProj Extension (UUID Generation)

public extension PBXProj {

    /// Returns a valid UUID for new elements.
    ///
    /// - Parameter element: project element class.
    /// - Returns: UUID available to be used.
    public func generateUUID<T: PBXObject>(for element: T.Type) -> String {
        var uuid: String = ""
        var counter: UInt = 0
        let random: String = String.random()
        let className: String = String(describing: T.self).hash.description
        repeat {
            counter += 1
            uuid = String(format: "%08X%08X%08X", className, random, counter)
        } while(objects.contains(reference: uuid))
        return uuid
    }

}
