import Foundation
import PathKit
import XcodeProjectFormat

public extension PBXProj {
    // MARK: - Reading

    /// Initializes the project from the contents of a `project.xcproj` file.
    ///
    /// - Parameters:
    ///   - xcprojData: the JSON5 contents of a `project.xcproj` file.
    ///   - projectName: the name of the project, normally the `.xcodeproj` file name without its
    ///     extension. The JSON format does not store it, so it has to be supplied.
    convenience init(xcprojData: Data, projectName: String) throws {
        let schema = try XCSchema.Project(jsonRepresentation: xcprojData)
        let decoded = try XCProjDecoder(schema: schema, projectName: projectName).decode()
        self.init(
            rootObject: decoded.rootObject,
            objectVersion: XCProjDecoder.defaultObjectVersion,
            archiveVersion: Xcode.LastKnown.archiveVersion,
            classes: [:],
            objects: decoded.objects
        )
        // Objects that carried no identifier in the JSON still hold a temporary reference, so they
        // are given the same deterministic identifiers a generated project would get.
        try ReferenceGenerator(outputSettings: PBXOutputSettings()).generateReferences(proj: self)
    }

    /// Initializes the project from a `project.xcproj` file on disk.
    ///
    /// - Parameter xcprojPath: the path to a `project.xcproj` file.
    convenience init(xcprojPath: Path) throws {
        let name = xcprojPath.parent().lastComponentWithoutExtension
        try self.init(xcprojData: Data(contentsOf: xcprojPath.url), projectName: name)
    }

    // MARK: - Writing

    /// Returns the project as the JSON5 contents of a `project.xcproj` file.
    ///
    /// - Parameter settings: controls how many object identifiers end up in the output.
    func xcprojData(settings: XCProjOutputSettings = .default) throws -> Data {
        try XCProjEncoder(proj: self, settings: settings).encode().jsonRepresentation()
    }

    /// Writes the project to the given path as a `project.xcproj` file.
    ///
    /// - Parameters:
    ///   - path: the path of the `project.xcproj` file to write.
    ///   - override: whether an existing file at that path should be replaced.
    ///   - settings: controls how many object identifiers end up in the output.
    func writeXCProj(path: Path, override: Bool = true, settings: XCProjOutputSettings = .default) throws {
        let data = try xcprojData(settings: settings)
        if override, path.exists {
            try path.delete()
        }
        try path.parent().mkpath()
        try path.write(data)
    }
}
