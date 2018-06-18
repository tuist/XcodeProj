import Foundation

/// This element indicates a file reference that is used in a PBXBuildPhase (either as an include or resource).
public final class PBXBuildFile: PBXObject {

    // MARK: - Attributes

    /// Element file reference.
    public var fileReference: PBXObjectReference?

    /// Element settings
    public var settings: [String: Any]?

    // MARK: - Init

    /// Initiazlies the build file with its attributes.
    ///
    /// - Parameters:
    ///   - fileReference: build file reference.
    ///   - settings: build file settings.
    public init(fileReference: PBXObjectReference,
                settings: [String: Any]? = nil) {
        self.fileReference = fileReference
        self.settings = settings
        super.init()
    }

    // MARK: - Decodable

    enum CodingKeys: String, CodingKey {
        case fileRef
        case settings
    }

    public required init(from decoder: Decoder) throws {
        let objects = decoder.context.objects
        let objectReferenceRepository = decoder.context.objectReferenceRepository
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let fileRefString: String = try container.decodeIfPresent(.fileRef) {
            fileReference = objectReferenceRepository.getOrCreate(reference: fileRefString, objects: objects)
        }
        settings = try container.decodeIfPresent([String: Any].self, forKey: .settings)
        try super.init(from: decoder)
    }
}

// MARK: - Public

public extension PBXBuildFile {
    /// Materializes the file reference and returns the object.
    ///
    /// - Returns: PBXFileReference object that the build file refers to.
    /// - Throws: An error if the object doesn't exist in the project.
    public func file() throws -> PBXFileReference? {
        return try fileReference?.object()
    }
}

// MARK: - Internal utils

extension PBXBuildFile {
    /// Returns the name of the file the build file points to.
    ///
    /// - Returns: file name.
    /// - Throws: an error if the name cannot be obtained.
    func fileName() throws -> String? {
        guard let fileElement: PBXFileElement = try fileReference?.object() else { return nil }
        return fileElement.fileName()
    }

    /// Returns the type of the build phase the build file belongs to.
    ///
    /// - Returns: build phase type.
    /// - Throws: an error if this method is called before the build file is added to any project.
    func buildPhaseType() throws -> BuildPhase? {
        let projectObjects = try objects()
        if projectObjects.sourcesBuildPhases.contains(where: { _, val in val.filesReferences.map({ $0.value }).contains(reference.value) }) {
            return .sources
        } else if projectObjects.frameworksBuildPhases
            .contains(where: { _, val in val.filesReferences.map({ $0.value }).contains(reference.value) }) {
            return .frameworks
        } else if projectObjects.resourcesBuildPhases.contains(where: { _, val in val.filesReferences.map({ $0.value }).contains(reference.value) }) {
            return .resources
        } else if projectObjects.copyFilesBuildPhases.contains(where: { _, val in val.filesReferences.map({ $0.value }).contains(reference.value) }) {
            return .copyFiles
        } else if projectObjects.headersBuildPhases.contains(where: { _, val in val.filesReferences.map({ $0.value }).contains(reference.value) }) {
            return .headers
        } else if projectObjects.carbonResourcesBuildPhases
            .contains(where: { _, val in val.filesReferences.map({ $0.value }).contains(reference.value) }) {
            return .carbonResources
        }
        return nil
    }

    /// Returns the name of the build phase the build file belongs to.
    ///
    /// - Returns: build phase name.
    /// - Throws: an error if the name cannot be obtained.
    func buildPhaseName() throws -> String? {
        let type = try buildPhaseType()
        let projectObjects = try objects()
        switch type {
        case .copyFiles?:
            return projectObjects.copyFilesBuildPhases.first(where: { _, val in val.filesReferences.contains(self.reference) })?.value.name ?? type?.rawValue
        default:
            return type?.rawValue
        }
    }
}

// MARK: - PlistSerializable

extension PBXBuildFile: PlistSerializable {
    var multiline: Bool { return false }

    func plistKeyAndValue(proj _: PBXProj, reference: String) throws -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXBuildFile.isa))
        if let fileReference = fileReference {
            let fileElement: PBXFileElement? = try? fileReference.object()
            dictionary["fileRef"] = .string(CommentedString(fileReference.value, comment: fileElement?.fileName()))
        }
        if let settings = settings {
            dictionary["settings"] = settings.plist()
        }
        let comment = try buildPhaseName().flatMap({ "\(try fileName() ?? "(null)") in \($0)" })
        return (key: CommentedString(reference, comment: comment),
                value: .dictionary(dictionary))
    }
}
