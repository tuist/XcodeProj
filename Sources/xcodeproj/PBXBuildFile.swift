import Foundation
import Unbox

// This element indicate a file reference that is used in a PBXBuildPhase (either as an include or resource).
public struct PBXBuildFile: ProjectElement {
    
    // MARK: - Attributes
    
    /// Element reference.
    public let reference: UUID
    
    /// Element isa.
    public static var isa: String = "PBXBuildFile"
    
    /// Element file reference.
    public let fileRef: UUID
    
    /// Element settings
    public let settings: [String: Any]?
    
    // MARK: - Init
    
    /// Initiazlies the build file with its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - fileRef: build file reference.
    ///   - settings: build file settings.
    public init(reference: UUID,
                fileRef: UUID,
                settings: [String: Any]? = nil) {
        self.reference = reference
        self.fileRef = fileRef
        self.settings = settings
    }
    
    /// Constructor that initializes the project element with the reference and a dictionary with its properties.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: dictionary with the element properties.
    /// - Throws: throws an error in case any of the propeties are missing or they have the wrong type.
    public init(reference: UUID, dictionary: [String : Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.fileRef = try unboxer.unbox(key: "fileRef")
        self.settings = unboxer.unbox(key: "settings")
    }
    
    // MARK: - Public
    
    /// Returns a new build file adding a new setting.
    ///
    /// - Parameters:
    ///   - setting: setting key.
    ///   - value: setting value.
    /// - Returns: new build file with the setting added.
    public func adding(setting: String, value: Any) -> PBXBuildFile {
        var settings = self.settings ?? [:]
        settings[setting] = value
        return PBXBuildFile(reference: reference,
                            fileRef: fileRef,
                            settings: settings)
    }
    
    /// Returns a new build file removing a setting.
    ///
    /// - Parameter setting: setting to be removed.
    /// - Returns: new build file with the setting removed.
    public func removing(setting: String) -> PBXBuildFile {
        var settings = self.settings ?? [:]
        settings.removeValue(forKey: setting)
        return PBXBuildFile(reference: reference,
                            fileRef: fileRef,
                            settings: settings)
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXBuildFile,
                           rhs: PBXBuildFile) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.fileRef == rhs.fileRef &&
            NSDictionary(dictionary: lhs.settings ?? [:]).isEqual(to: rhs.settings ?? [:])
    }
    
    public var hashValue: Int { return self.reference.hashValue }
}
