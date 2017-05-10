import Foundation
import Unbox

// This is the element for referencing localized resources.
public struct PBXVariantGroup: Hashable {
    
    // MARK: - Attributes
    
    // Variant group reference.
    public let reference: UUID
    
    // Variant group isa.
    public let isa: String = "PBXVariantGroup"
    
    // The objects are a reference to a PBXFileElement element
    public let children: Set<UUID>
    
    // The filename
    public let name: String
    
    // Variant group source tree.
    public let sourceTree: PBXSourceTree
    
    // MARK: - Init
    
    /// Initializes the PBXVariantGroup with its values.
    ///
    /// - Parameters:
    ///   - reference: variant group reference.
    ///   - children: group children references.
    ///   - name: name of the variant group
    ///   - sourceTree: the group source tree.
    public init(reference: UUID,
                children: Set<UUID>,
                name: String,
                sourceTree: PBXSourceTree) {
        self.reference = reference
        self.children = children
        self.name = name
        self.sourceTree = sourceTree
    }
    
    /// Initializes the variant group with the element reference an a dictionary with its properties.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: dictionary with the element properties.
    /// - Throws: an error in case any property is missing or the format is wrong.
    public init(reference: UUID, dictionary: [String: Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.children = try unboxer.unbox(key: "children")
        self.name = try unboxer.unbox(key: "name")
        self.sourceTree = try unboxer.unbox(key: "sourceTree")
    }
    
    /// Returns a new variant group by adding a new children.
    ///
    /// - Parameter child: child to be added.
    /// - Returns: new variant group with the child added.
    public func adding(child: UUID) -> PBXVariantGroup {
        var children = self.children
        children.insert(child)
        return PBXVariantGroup(reference: reference,
                               children: children,
                               name: name,
                               sourceTree: sourceTree)
    }
    
    /// Returns a new new variant group removing one of its children.
    ///
    /// - Parameter child: child to be removed.
    /// - Returns: new variant group with the child removed.
    public func removing(child: UUID) -> PBXVariantGroup {
        var children = self.children
        children.remove(child)
        return PBXVariantGroup(reference: reference,
                               children: children,
                               name: name,
                               sourceTree: sourceTree)
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXVariantGroup,
                           rhs: PBXVariantGroup) -> Bool {
        return lhs.reference == rhs.reference &&
        lhs.isa == rhs.isa &&
        lhs.children == rhs.children &&
        lhs.name == rhs.name &&
        lhs.sourceTree == rhs.sourceTree
    }
    
    public var hashValue: Int { return self.reference.hashValue }

}
