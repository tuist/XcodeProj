import Foundation
import Unbox

/// This is the element for a build target that produces a binary content (application or library).
public struct PBXNativeTarget: PBXTarget {

    /// Element isa.
    public let isa: String = "PBXNativeTarget"
    
    /// Element reference.
    public let reference: UUID

    /// Target build configuration list.
    public let buildConfigurationList: UUID
    
    /// Target build phases.
    public let buildPhases: Set<UUID>
    
    /// Target build rules.
    public let buildRules: Set<UUID>
    
    /// Target dependencies.
    public let dependencies: Set<UUID>
    
    /// Target name.
    public let name: String
    
    /// Target product name.
    public let productName: String
    
    /// Target product reference.
    public let productReference: UUID
    
    /// Target product type.
    public let productType: PBXProductType
    
    // MARK: - Init
    
    /// Initializes the native target with its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - buildConfigurationList: target build configuration list.
    ///   - buildPhases: target build phases.
    ///   - buildRules: target build rules.
    ///   - dependencies: target dependencies.
    ///   - name: target name.
    ///   - productName: target product name.
    ///   - productReference: target product reference.
    ///   - productType: target product type.
    public init(reference: UUID,
                buildConfigurationList: UUID,
                buildPhases: Set<UUID>,
                buildRules: Set<UUID>,
                dependencies: Set<UUID>,
                name: String,
                productName: String,
                productReference: UUID,
                productType: PBXProductType) {
        self.reference = reference
        self.buildConfigurationList = buildConfigurationList
        self.buildPhases = buildPhases
        self.buildRules = buildRules
        self.dependencies = dependencies
        self.name = name
        self.productName = productName
        self.productReference = productReference
        self.productType = productType
    }
    
    /// Initializes the native target with a reference and the dictionary that contains the element properties.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - dictionary: dictionary with the element properties.
    /// - Throws: an error in case of any of the properties is missing or the type is incorrect.
    public init(reference: UUID, dictionary: [String : Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.buildConfigurationList = try unboxer.unbox(key: "buildConfigurationList")
        self.buildPhases = try unboxer.unbox(key: "buildPhases")
        self.buildRules = try unboxer.unbox(key: "buildRules")
        self.dependencies = try unboxer.unbox(key: "dependencies")
        self.name = try unboxer.unbox(key: "name")
        self.productName = try unboxer.unbox(key: "productName")
        self.productReference = try unboxer.unbox(key: "productReference")
        self.productType = try unboxer.unbox(key: "productType")
    }
    
    // MARK: - Public
    
    /// Returns a new native target by adding a new build phase.
    ///
    /// - Parameter buildPhase: build phase to be added.
    /// - Returns: native target with the build phase added.
    public func adding(buildPhase: UUID) -> PBXNativeTarget {
        var buildPhases = self.buildPhases
        buildPhases.insert(buildPhase)
        return PBXNativeTarget(reference: reference,
                               buildConfigurationList: buildConfigurationList,
                               buildPhases: buildPhases,
                               buildRules: buildRules,
                               dependencies: dependencies,
                               name: name,
                               productName: productName,
                               productReference: productReference,
                               productType: productType)
    }
    
    /// Returns a new native target by removing a new build phase.
    ///
    /// - Parameter buildPhase: build phase to be removed.
    /// - Returns: native target with the build phase removed.
    public func removing(buildPhase: UUID) -> PBXNativeTarget {
        var buildPhases = self.buildPhases
        buildPhases.remove(buildPhase)
        return PBXNativeTarget(reference: reference,
                               buildConfigurationList: buildConfigurationList,
                               buildPhases: buildPhases,
                               buildRules: buildRules,
                               dependencies: dependencies,
                               name: name,
                               productName: productName,
                               productReference: productReference,
                               productType: productType)
    }
    
    /// Returns a new native target by adding a new build rule.
    ///
    /// - Parameter buildRule: build rule to be added.
    /// - Returns: native target with the build rule added.
    public func adding(buildRule: UUID) -> PBXNativeTarget {
        var buildRules = self.buildRules
        buildRules.insert(buildRule)
        return PBXNativeTarget(reference: reference,
                               buildConfigurationList: buildConfigurationList,
                               buildPhases: buildPhases,
                               buildRules: buildRules,
                               dependencies: dependencies,
                               name: name,
                               productName: productName,
                               productReference: productReference,
                               productType: productType)
    }
    
    /// Returns a new native target with the build rule added.
    ///
    /// - Parameter buildRule: build rule to be added.
    /// - Returns: native target with the build rule.
    public func removing(buildRule: UUID) -> PBXNativeTarget {
        var buildRules = self.buildRules
        buildRules.remove(buildRule)
        return PBXNativeTarget(reference: reference,
                               buildConfigurationList: buildConfigurationList,
                               buildPhases: buildPhases,
                               buildRules: buildRules,
                               dependencies: dependencies,
                               name: name,
                               productName: productName,
                               productReference: productReference,
                               productType: productType)
    }
    
    /// Returns a new native target with a dependency added.
    ///
    /// - Parameter dependency: dependency to be added.
    /// - Returns: native target with the dependency added.
    public func adding(dependency: UUID) -> PBXNativeTarget {
        var dependencies = self.dependencies
        dependencies.insert(dependency)
        return PBXNativeTarget(reference: reference,
                               buildConfigurationList: buildConfigurationList,
                               buildPhases: buildPhases,
                               buildRules: buildRules,
                               dependencies: dependencies,
                               name: name,
                               productName: productName,
                               productReference: productReference,
                               productType: productType)
    }
    
    /// Returns a new native target with the dependency removed.
    ///
    /// - Parameter dependency: dependency to be removed.
    /// - Returns: native target with the dependency added.
    public func removing(dependency: UUID) -> PBXNativeTarget {
        var dependencies = self.dependencies
        dependencies.remove(dependency)
        return PBXNativeTarget(reference: reference,
                               buildConfigurationList: buildConfigurationList,
                               buildPhases: buildPhases,
                               buildRules: buildRules,
                               dependencies: dependencies,
                               name: name,
                               productName: productName,
                               productReference: productReference,
                               productType: productType)
    }
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXNativeTarget,
                           rhs: PBXNativeTarget) -> Bool {
        return lhs.reference == rhs.reference &&
        lhs.isa == rhs.isa &&
        lhs.buildConfigurationList == rhs.buildConfigurationList &&
        lhs.buildPhases == rhs.buildPhases &&
        lhs.buildRules == rhs.buildRules &&
        lhs.dependencies == rhs.dependencies &&
        lhs.name == rhs.name &&
        lhs.productName == rhs.productName &&
        lhs.productReference == rhs.productReference &&
        lhs.productType == rhs.productType
    }
    
    public var hashValue: Int { return self.reference.hashValue }

}
