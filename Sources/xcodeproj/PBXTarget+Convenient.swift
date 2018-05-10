import Foundation

public extension PBXTarget {
    /// Returns the sources build phase.
    ///
    /// - Returns: sources build phase.
    /// - Throws: an error if the build phase cannot be obtained.
    public func sourcesBuildPhase() throws -> PBXSourcesBuildPhase? {
        return try buildPhases
            .compactMap({ try $0.object() as PBXSourcesBuildPhase })
            .filter({ $0.type() == .sources })
            .first
    }

    /// Returns the resources build phase.
    ///
    /// - Returns: sources build phase.
    /// - Throws: an error if the build phase cannot be obtained.
    public func resourcesBuildPhase() throws -> PBXResourcesBuildPhase? {
        return try buildPhases
            .compactMap({ try $0.object() as PBXResourcesBuildPhase })
            .filter({ $0.type() == .sources })
            .first
    }

    /// Returns the target source files.
    ///
    /// - Returns: source files.
    /// - Throws: an error if something goes wrong.
    public func sourceFiles() throws -> [PBXFileElement] {
        return try sourcesBuildPhase()?.files
            .compactMap { try $0.object() as PBXBuildFile }
            .filter { $0.fileRef != nil }
            .compactMap { try $0.fileRef!.object() as PBXFileElement }
            ?? []
    }
}
