import Foundation

// This is the element for a build target that aggregates several others.

public struct PBXAggregateTarget {
    
    // MARK: - Attributes
    
    let reference: UUID
    let isa: String = "PBXAggregateTarget"
    let buildConfigurationList: XCConfigurationList 
}
