import Foundation
import Unbox

// This is the element for referencing other target through content proxies.
public struct PBXTargetDependency: Isa {
    
    // MARK: - Attributes
    
    /// Target dependency reference.
    public let reference: UUID
    
    /// Target dependency isa.
    public let isa: String = "PBXTargetDependency"
    
    /// Target reference.
    public let target: UUID
    
    /// Target proxy
    public let targetProxy: UUID
    
    /// Initializes the target dependency.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - target: element target.
    ///   - targetProxy: element target proxy.
    public init(reference: UUID,
                target: UUID,
                targetProxy: UUID) {
        self.reference = reference
        self.target = target
        self.targetProxy = targetProxy
    }
    
    /// Initializes the target dependency with its reference and a dictionary that contains its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: dictionary with the attributes.
    /// - Throws: throws an error in case of any attribute is missing or the type is not the expected one.
    public init(reference: String, dictionary: [String: Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.target = try unboxer.unbox(key: "target")
        self.targetProxy = try unboxer.unbox(key: "targetProxy")
    }
    
}
