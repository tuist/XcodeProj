import Foundation

// This element is an abstract parent for specialized targets.
public protocol PBXTarget: ProjectElement {
    
    /// Target build configuration list.
    var buildConfigurationList: UUID { get }
    
    /// Target build phases.
    var buildPhases: [UUID] { get }
    
    /// Target build rules.
    var buildRules: [UUID] { get }
    
    /// Target dependencies.
    var dependencies: [UUID] { get }
    
    /// Target name.
    var name: String { get }
    
    /// Target product name.
    var productName: String? { get }
    
    /// Target product reference.
    var productReference: UUID? { get }
    
    /// Target product type.
    var productType: PBXProductType? { get }
    
}
