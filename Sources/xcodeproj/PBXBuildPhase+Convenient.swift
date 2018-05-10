import Foundation

public extension PBXBuildPhase {
    /// Adds a file to a build phase, creating a proxy build file that points to the given file reference.
    ///
    /// - Parameter reference: reference to the file element.
    /// - Returns: reference to the build file added to the build phase.
    /// - Throws: an error if the reference cannot be added
    public func addFile(_ reference: PBXObjectReference) throws -> PBXObjectReference {
        if let existing = try files.compactMap({ try $0.object() as PBXBuildFile }).first(where: { $0.fileRef == reference }) {
            return existing.reference
        }
        let projectObjects = try objects()
        let buildFile = PBXBuildFile(fileRef: reference)
        let buildFileReference = projectObjects.addObject(buildFile)
        files.append(buildFileReference)
        return buildFileReference
    }
}
