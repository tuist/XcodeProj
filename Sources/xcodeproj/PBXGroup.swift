import Foundation
import Unbox
import xcodeprojextensions

public struct PBXGroup {
    
    // MARK: - Attributes
    
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
    
}

// MARK: - PBXGroup Extension (Extras)

extension PBXGroup {
    
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
    
}

// MARK: - PBXGroup Extension (ProjectElement)

extension PBXGroup: ProjectElement {
    
    public static var isa: String = "PBXGroup"

    public static func == (lhs: PBXGroup,
                           rhs: PBXGroup) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.children == rhs.children &&
            lhs.name == rhs.name &&
            lhs.sourceTree == rhs.sourceTree
    }
    
    public var hashValue: Int { return self.reference.hashValue }
   
    public init(reference: UUID, dictionary: [String : Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.children = try unboxer.unbox(key: "children")
        self.name = unboxer.unbox(key: "name")
        self.sourceTree = try unboxer.unbox(key: "sourceTree")
    }
}

// MARK: - PBXGroup Extension (PBXProjPlistSerializable)

extension PBXGroup: PBXProjPlistSerializable {
    
    func pbxProjPlistElement(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXGroup.isa))
        dictionary["children"] = .array(children.map({ (fileReference) -> PlistValue in
            let comment = name(reference: fileReference, proj: proj)
            return .string(CommentedString(fileReference, comment: comment))
        }))
        if let name = name {
            dictionary["name"] = .string(CommentedString(name))
        }
        dictionary["sourceTree"] = .string(CommentedString(sourceTree.rawValue.quoted))
        return (key: CommentedString(self.reference,
                                                 comment: self.name),
                value: .dictionary(dictionary))
    }
    
    fileprivate func name(reference: UUID, proj: PBXProj) -> String? {
        let group = proj.objects.groups.filter({ $0.reference == reference }).first
        let file = proj.objects.fileReferences.filter({ $0.reference == reference }).first
        if let group = group, let groupName = group.name {
            return groupName
        } else if let file = file {
            return file.path ?? file.path
        }
        return nil
    }
    
}
