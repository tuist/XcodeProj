import Basic
import Foundation

/// Represents a .pbxproj file
public final class PBXProj: Decodable {

    // MARK: - Properties

    public let objects: PBXObjects

    /// Project archive version.
    public var archiveVersion: UInt

    /// Project object version.
    public var objectVersion: UInt

    /// Project classes.
    public var classes: [String: Any]

    /// Project root object.
    public var rootObjectReference: PBXObjectReference?

    /// Initializes the project with its attributes.
    ///
    /// - Parameters:
    ///   - rootObjectReference: project root object.
    ///   - objectVersion: project object version.
    ///   - archiveVersion: project archive version.
    ///   - classes: project classes.
    ///   - objects: project objects
    public init(rootObjectReference: PBXObjectReference? = nil,
                objectVersion: UInt = 0,
                archiveVersion: UInt = 1,
                classes: [String: Any] = [:],
                objects: [String: PBXObject] = [:]) {
        self.archiveVersion = archiveVersion
        self.objectVersion = objectVersion
        self.classes = classes
        self.rootObjectReference = rootObjectReference
        self.objects = PBXObjects(objects: objects)
    }

    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case archiveVersion
        case objectVersion
        case classes
        case objects
        case rootObject
    }

    public required init(from decoder: Decoder) throws {
        let objects = decoder.context.objects
        let objectReferenceRepository = decoder.context.objectReferenceRepository
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rootObjectReference: String = try container.decode(.rootObject)
        self.rootObjectReference = objectReferenceRepository.getOrCreate(reference: rootObjectReference, objects: objects)
        objectVersion = try container.decodeIntIfPresent(.objectVersion) ?? 0
        archiveVersion = try container.decodeIntIfPresent(.archiveVersion) ?? 1
        classes = try container.decodeIfPresent([String: Any].self, forKey: .classes) ?? [:]
        let objectsDictionary: [String: Any] = try container.decodeIfPresent([String: Any].self, forKey: .objects) ?? [:]
        let objectsDictionaries: [String: [String: Any]] = (objectsDictionary as? [String: [String: Any]]) ?? [:]
        try objectsDictionaries.forEach { reference, dictionary in
            let object = try PBXObject.parse(reference: reference, dictionary: dictionary, userInfo: decoder.userInfo)
            objects.addObject(object)
        }
        self.objects = objects
    }
}

// MARK: - PBXProj Extension (Utils)

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

// MARK: - Build

public extension PBXProj {
    /// Returns root project.
    public func rootProject() throws -> PBXProject? {
        return try rootObjectReference?.object()
    }

    /// Returns root project's root group.
    public func rootGroup() throws -> PBXGroup? {
        let project = try rootProject()
        return try project?.mainGroup.object()
    }
}

// MARK: - PBXProj Extension (Equatable)

extension PBXProj: Equatable {
    public static func == (lhs: PBXProj, rhs: PBXProj) -> Bool {
        let equalClasses = NSDictionary(dictionary: lhs.classes).isEqual(to: rhs.classes)
        return lhs.archiveVersion == rhs.archiveVersion &&
            lhs.objectVersion == rhs.objectVersion &&
            equalClasses &&
            lhs.objects == rhs.objects
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
