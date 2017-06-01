import Foundation
import Unbox

public struct PBXGroup: ProjectElement {
    
    // MARK: - Attributes
    
    /// Element isa.
    public let isa: String = "PBXGroup"
    
    /// Element reference.
    public let reference: UUID
    
    /// Element children.
    public let children: Set<UUID>
    
    /// Element name.
    public let name: String?
    
    /// Element source tree.
    public let sourceTree: PBXSourceTree
    
    // MARK: - Init
    
    /// Initializes the group with its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - children: group children.
    ///   - sourceTree: group source tree.
    ///   - name: group name.
    public init(reference: UUID,
                children: Set<UUID>,
                sourceTree: PBXSourceTree,
                name: String? = nil) {
        self.reference = reference
        self.children = children
        self.name = name
        self.sourceTree = sourceTree
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
        self.children = try unboxer.unbox(key: "children")
        self.name = unboxer.unbox(key: "name")
        self.sourceTree = try unboxer.unbox(key: "sourceTree")
    }
    
    // MARK: - Public
    
    /// Returns a new group adding a child.
    ///
    /// - Parameter child: new group with the child added.
    /// - Returns: new group with the child added.
    public func adding(child: UUID) -> PBXGroup {
        var children = self.children
        children.insert(child)
        return PBXGroup(reference: reference,
                        children: children,
                        sourceTree: sourceTree,
                        name: name)
    }
    
    /// Returns a new group removing a child.
    ///
    /// - Parameter child: child to be removed.
    /// - Returns: new group with the child added.
    public func removing(child: UUID) -> PBXGroup {
        var children = self.children
        children.remove(child)
        return PBXGroup(reference: reference,
                        children: children,
                        sourceTree: sourceTree,
                        name: name)
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXGroup,
                           rhs: PBXGroup) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.isa == rhs.isa &&
            lhs.children == rhs.children &&
            lhs.name == rhs.name &&
            lhs.sourceTree == rhs.sourceTree
    }
    
    public var hashValue: Int { return self.reference.hashValue }
    
}
