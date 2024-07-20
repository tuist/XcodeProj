import Foundation


/// Class representing an element that may contain other elements.
public class PBXFileSystemSynchronizedBuildFileExceptionSet: PBXObject {
    
    // MARK: - Attributes
    
    /// A list of relative paths to children subfolders for which exceptions are applied.
    public var membershipExceptions: [String]?
    
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
    
    public init(target: PBXTarget, membershipExceptions: [String]) {
        self.targetReference = target.reference
        self.membershipExceptions = membershipExceptions
        super.init()
    }
    
    // MARK: - Decodable

    fileprivate enum CodingKeys: String, CodingKey {
        case target
        case membershipExceptions
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let referenceRepository = decoder.context.objectReferenceRepository
        let objects = decoder.context.objects
        let targetReference: String = try container.decode(.target)
        self.targetReference = referenceRepository.getOrCreate(reference: targetReference, objects: objects)
        self.membershipExceptions = try container.decodeIfPresent(.membershipExceptions)
        try super.init(from: decoder)
    }
    
    // MARK: - Equatable

    override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXFrameworksBuildPhase else { return false }
        return isEqual(to: rhs)
    }
    
}
