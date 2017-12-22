import Foundation

/// This element indicates a file reference that is used in a PBXBuildPhase (either as an include or resource).
final public class PBXBuildFile: PBXObject, Hashable {

    // MARK: - Attributes

    /// Element file reference.
    public var fileRef: String?

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
        self.fileRef = try container.decodeIfPresent(.fileRef)
        self.settings = try container.decodeIfPresent([String: Any].self, forKey: .settings)
        try super.init(from: decoder)
    }

    // MARK: - Hashable

    public static func == (lhs: PBXBuildFile,
                           rhs: PBXBuildFile) -> Bool {
        let settingsAreEqual: Bool = {
            switch (lhs.settings, rhs.settings) {
            case (.none, .none):
                return true
            case (.none, .some), (.some, .none):
                return false
            case (.some(let lhsSettings), .some(let rhsSettings)):
                return NSDictionary(dictionary: lhsSettings).isEqual(to: rhsSettings)
            }
        }()
        return lhs.reference == rhs.reference &&
            lhs.fileRef == rhs.fileRef &&
            settingsAreEqual
    }
}

// MARK: - PBXBuildFile Extension (PlistSerializable)

extension PBXBuildFile: PlistSerializable {

    var multiline: Bool { return false }

    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXBuildFile.isa))
        var fileName: String?
        if let fileRef = fileRef {
            fileName = proj.objects.fileName(fileReference: fileRef)
            dictionary["fileRef"] = .string(CommentedString(fileRef, comment: fileName))
        }
        if let settings = settings {
            dictionary["settings"] = settings.plist()
        }
        let buildPhaseName = proj.objects.buildPhaseName(buildFileReference: reference)
        let comment = buildPhaseName.flatMap({"\(fileName ?? "(null)") in \($0)"})
        return (key: CommentedString(self.reference, comment: comment),
                value: .dictionary(dictionary))
    }

}
