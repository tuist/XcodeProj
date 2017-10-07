import Foundation

// This element indicate a file reference that is used in a PBXBuildPhase (either as an include or resource).
public class PBXBuildFile: PBXObject, Hashable {
    
    // MARK: - Attributes
    
    /// Element file reference.
    public var fileRef: String
    
    /// Element settings
    public var settings: [String: Any]?
    
    // MARK: - Init
    
    /// Initiazlies the build file with its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - fileRef: build file reference.
    ///   - settings: build file settings.
    public init(reference: String,
                fileRef: String,
                settings: [String: Any]? = nil) {
        self.fileRef = fileRef
        self.settings = settings
        super.init(reference: reference)
    }
    
    // MARK: - Decodable
    
    enum CodingKeys: String, CodingKey {
        case fileRef
        case settings
        case reference
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let reference: String = try container.decode(.reference)
        self.fileRef = try container.decode(.fileRef)        
        self.settings = try container.decodeIfPresent([String: Any].self, forKey: .settings) ?? [:]
        super.init(reference: reference)
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXBuildFile,
                           rhs: PBXBuildFile) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.fileRef == rhs.fileRef &&
            NSDictionary(dictionary: lhs.settings ?? [:]).isEqual(to: rhs.settings ?? [:])
    }
}

// MARK: - PBXBuildFile Extension (PlistSerializable)

extension PBXBuildFile: PlistSerializable {
    
    var multiline: Bool { return false }
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXBuildFile.isa))
        let fileName = name(fileRef: fileRef, proj: proj)
        dictionary["fileRef"] = .string(CommentedString(fileRef, comment: fileName))
        let fileType = proj.buildPhaseType(buildFileReference: reference)?.rawValue
        if let settings = settings {
            dictionary["settings"] = settings.plist()
        }
        let comment = fileName.flatMap({ fileName -> String? in return fileType.flatMap({"\(fileName) in \($0)"})})
        return (key: CommentedString(self.reference, comment: comment),
                value: .dictionary(dictionary))
    }
    
    private func name(fileRef: String, proj: PBXProj) -> String? {
        let fileReference = proj.fileReferences.getReference(fileRef)
        let variantGroup = proj.variantGroups.getReference(fileRef)
        if let fileReference = fileReference {
            return fileReference.name ?? fileReference.path
        } else if let variantGroup = variantGroup {
            return variantGroup.name
        }
        return nil
    }
    
}
