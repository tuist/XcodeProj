import Foundation


/// Class representing an element that may contain other elements.
public class PBXFileSystemSynchronizedBuildFileExceptionSet: PBXObject {
    
    // MARK: - Attributes
    
    /// A list of relative paths to children subfolders for which exceptions are applied.
    public var membershipExceptions: [String]?
    
    /// Changes the default header visibility (project) to public for the following headers.
    /// Every item in the list is the relative path inside the root synchronized group.
    public var publicHeaders: [String]?
    
    /// Changes the default header visibility (project) to private for the following headers.
    /// Every item in the list is the relative path inside the root synchronized group.
    public var privateHeaders: [String]?
    
    var targetReference: PBXObjectReference
    
    public var target: PBXTarget! {
        get {
            targetReference.getObject() as? PBXTarget
        }
        set {
            targetReference = newValue.reference
        }
    }
    
    // MARK: - Init
    
    public init(target: PBXTarget, membershipExceptions: [String]?, publicHeaders: [String]?, privateHeaders: [String]?) {
        self.targetReference = target.reference
        self.membershipExceptions = membershipExceptions
        self.publicHeaders = publicHeaders
        self.privateHeaders = privateHeaders
        super.init()
    }
    
    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case target
        case membershipExceptions
        case publicHeaders
        case privateHeaders
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let referenceRepository = decoder.context.objectReferenceRepository
        let objects = decoder.context.objects
        let targetReference: String = try container.decode(.target)
        self.targetReference = referenceRepository.getOrCreate(reference: targetReference, objects: objects)
        self.membershipExceptions = try container.decodeIfPresent(.membershipExceptions)
        self.publicHeaders = try container.decodeIfPresent(.publicHeaders)
        self.privateHeaders = try container.decodeIfPresent(.privateHeaders)
        try super.init(from: decoder)
    }
    
    // MARK: - Equatable

    override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXFrameworksBuildPhase else { return false }
        return isEqual(to: rhs)
    }
    
}
