import Foundation
import Unbox

// This is the element for referencing other target through content proxies.
public class PBXTargetDependency: PBXObject, Hashable {
    
    // MARK: - Attributes
    
    /// Target reference.
    public var target: String
    
    /// Target proxy
    public var targetProxy: String?
    
    // MARK: - Init
    
    /// Initializes the target dependency.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - target: element target.
    ///   - targetProxy: element target proxy.
    public init(reference: String,
                target: String,
                targetProxy: String? = nil) {
        self.target = target
        self.targetProxy = targetProxy
        super.init(reference: reference)
    }
    
    /// Initializes the target dependency with its reference and a dictionary that contains its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: dictionary with the attributes.
    /// - Throws: throws an error in case of any attribute is missing or the type is not the expected one.
    public override init(reference: String, dictionary: [String: Any]) throws {
        let unboxer = Unboxer(dictionary: dictionary)
        self.target = try unboxer.unbox(key: "target")
        self.targetProxy = unboxer.unbox(key: "targetProxy")
        try super.init(reference: reference, dictionary: dictionary)
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXTargetDependency,
                           rhs: PBXTargetDependency) -> Bool {
        return lhs.reference == rhs.reference &&
        lhs.target == rhs.target &&
        lhs.targetProxy == rhs.targetProxy
    }
    
    // MARK: - PlistSerializable
}

extension PBXTargetDependency: PlistSerializable {
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXTargetDependency.isa))
        dictionary["target"] = .string(CommentedString(target, comment: proj.nativeTargets.getReference(target)?.name))
        if let targetProxy = targetProxy {
            dictionary["targetProxy"] = .string(CommentedString(targetProxy, comment: "PBXContainerItemProxy"))
        }
        return (key: CommentedString(self.reference,
                                                 comment: "PBXTargetDependency"),
                value: .dictionary(dictionary))
    }
}
