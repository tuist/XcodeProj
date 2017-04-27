import Foundation

// This is the element for referencing localized resources.
public struct PBXVariantGroup {
    
    // MARK: - Attributes
    
    public let reference: UUID
    
    public let isa: String = "PBXVariantGroup"
    
    // The objects are a reference to a PBXFileElement element
    public let children: [UUID]
    
    // The filename
    public let name: String
    
    public let sourceTree: PBXSourceTree
    
    // MARK: - Init
    
    public init(reference: UUID,
                children: [UUID],
                name: String,
                sourceTree: PBXSourceTree) {
        self.reference = reference
        self.children = children
        self.name = name
        self.sourceTree = sourceTree
    }
}
