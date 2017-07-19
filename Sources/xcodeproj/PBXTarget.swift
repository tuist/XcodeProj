import Foundation

// This element is an abstract parent for specialized targets.
public protocol PBXTarget: ProjectElement {
    
    /// Target build configuration list.
    var buildConfigurationList: String { get }
    
    /// Target build phases.
    var buildPhases: [String] { get }
    
    /// Target build rules.
    var buildRules: [String] { get }
    
    /// Target dependencies.
    var dependencies: [String] { get }
    
    /// Target name.
    var name: String { get }
    
    /// Target product name.
    var productName: String? { get }
    
    /// Target product reference.
    var productReference: String? { get }
    
    /// Target product type.
    var productType: PBXProductType? { get }
    
}
