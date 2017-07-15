import Foundation
import Unbox

// This is the element for a build target that aggregates several others.
public struct PBXAggregateTarget: PBXTarget {
    
    // MARK: - Attributes

    /// Element reference.
    public let reference: UUID
    
    /// Target build configuration list.
    public var buildConfigurationList: UUID
    
    /// Target build phases.
    public var buildPhases: [UUID]
    
    /// Target build rules.
    public var buildRules: [UUID]
    
    /// Target dependencies.
    public var dependencies: [UUID]
    
    /// Target name.
    public var name: String
    
    /// Target product name.
    public var productName: String?
    
    /// Target product reference.
    public var productReference: UUID?
    
    /// Target product type.
    public var productType: PBXProductType?
    
    // MARK: - Init
    
    /// Initializes the aggregate target with its attributes.
    ///
    /// - Parameters:
    ///   - reference: element reference.
    ///   - buildConfigurationList: target build configuration list (reference).
    ///   - buildPhases: target build phases.
    ///   - buildRules: target build rules.
    ///   - dependencies: target dependencies.
    ///   - name: target name.
    ///   - productName: target product name.
    ///   - productReference: target product reference.
    ///   - productType: target product type.
    public init(reference: UUID,
                buildConfigurationList: UUID,
                buildPhases: [UUID],
                buildRules: [UUID],
                dependencies: [UUID],
                name: String,
                productName: String? = nil,
                productReference: UUID? = nil,
                productType: PBXProductType? = nil) {
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
    
}

extension PBXAggregateTarget: ProjectElement {
    
    public static var isa: String = "PBXAggregateTarget"
    
    public static func == (lhs: PBXAggregateTarget,
                           rhs: PBXAggregateTarget) -> Bool {
        return lhs.reference == rhs.reference &&
            lhs.buildConfigurationList == rhs.buildConfigurationList
    }
    
    public var hashValue: Int { return self.reference.hashValue }
    
    public init(reference: UUID, dictionary: [String : Any]) throws {
        self.reference = reference
        let unboxer = Unboxer(dictionary: dictionary)
        self.buildConfigurationList = try unboxer.unbox(key: "buildConfigurationList")
        self.buildPhases = try unboxer.unbox(key: "buildPhases")
        self.buildRules = try unboxer.unbox(key: "buildRules")
        self.dependencies = try unboxer.unbox(key: "dependencies")
        self.name = try unboxer.unbox(key: "name")
        self.productName = unboxer.unbox(key: "productName")
        self.productReference = unboxer.unbox(key: "productReference")
        self.productType = unboxer.unbox(key: "productType")
    }

}

// MARK: - PBXAggregateTarget Extension (Extras)

extension PBXAggregateTarget {
    
    /// Returns a new aggregate target with the build phase added.
    ///
    /// - Parameter buildPhase: build phase to be added.
    /// - Returns: new aggregate target with the build phase added.
    public func adding(buildPhase: UUID) -> PBXAggregateTarget {
        var buildPhases = self.buildPhases
        buildPhases.append(buildPhase)
        return PBXAggregateTarget(reference: reference,
                                  buildConfigurationList: buildConfigurationList,
                                  buildPhases: buildPhases,
                                  buildRules: buildRules,
                                  dependencies: dependencies,
                                  name: name,
                                  productName: productName,
                                  productReference: productReference,
                                  productType: productType)
    }
    
    /// Returns a new aggregate target with the build phase removed.
    ///
    /// - Parameter buildPhase: build phase to be removed.
    /// - Returns: a new aggregate target with the build phase removed.
    public func removing(buildPhase: UUID) -> PBXAggregateTarget {
        var buildPhases = self.buildPhases
        if let index = buildPhases.index(of: buildPhase) {
            buildPhases.remove(at: index)
        }
        return PBXAggregateTarget(reference: reference,
                                  buildConfigurationList: buildConfigurationList,
                                  buildPhases: buildPhases,
                                  buildRules: buildRules,
                                  dependencies: dependencies,
                                  name: name,
                                  productName: productName,
                                  productReference: productReference,
                                  productType: productType)
    }
    
    /// Returns a new aggregate target with the given build phases.
    ///
    /// - Parameter buildPhases: build phases for the new aggregate target.
    /// - Returns: new aggregate target with the given build phases.
    public func with(buildPhases: [UUID]) -> PBXAggregateTarget {
        return PBXAggregateTarget(reference: reference,
                                  buildConfigurationList: buildConfigurationList,
                                  buildPhases: buildPhases,
                                  buildRules: buildRules,
                                  dependencies: dependencies,
                                  name: name,
                                  productName: productName,
                                  productReference: productReference,
                                  productType: productType)
    }
    
    /// Returns a nenw aggregate target adding a build rule.
    ///
    /// - Parameter buildRule: build rule to be added.
    /// - Returns: new aggregate target with the build rule added.
    public func adding(buildRule: UUID) -> PBXAggregateTarget {
        var buildRules = self.buildRules
        buildRules.append(buildRule)
        return PBXAggregateTarget(reference: reference,
                                  buildConfigurationList: buildConfigurationList,
                                  buildPhases: buildPhases,
                                  buildRules: buildRules,
                                  dependencies: dependencies,
                                  name: name,
                                  productName: productName,
                                  productReference: productReference,
                                  productType: productType)
    }
    
    /// Returns a new aggregate target removing a build rule
    ///
    /// - Parameter buildRule: build rule to be removed.
    /// - Returns: new aggregate target with the build rule removed.
    public func removing(buildRule: UUID) -> PBXAggregateTarget {
        var buildRules = self.buildRules
        if let index = buildRules.index(of: buildRule) {
            buildRules.remove(at: index)
        }
        return PBXAggregateTarget(reference: reference,
                                  buildConfigurationList: buildConfigurationList,
                                  buildPhases: buildPhases,
                                  buildRules: buildRules,
                                  dependencies: dependencies,
                                  name: name,
                                  productName: productName,
                                  productReference: productReference,
                                  productType: productType)
    }
    
    /// Returns a new aggregate target with the givenb build rules.
    ///
    /// - Parameter buildRules: build rules for the new aggregate target.
    /// - Returns: new aggregate target with the given build rules.
    public func with(buildRules: [UUID]) -> PBXAggregateTarget {
        return PBXAggregateTarget(reference: reference,
                                  buildConfigurationList: buildConfigurationList,
                                  buildPhases: buildPhases,
                                  buildRules: buildRules,
                                  dependencies: dependencies,
                                  name: name,
                                  productName: productName,
                                  productReference: productReference,
                                  productType: productType)
    }
    
    /// Returns a new aggregate target with a dependency added.
    ///
    /// - Parameter dependency: dependency to be added.
    /// - Returns: new aggregate target with the dependency added.
    public func adding(dependency: UUID) -> PBXAggregateTarget {
        var dependencies = self.dependencies
        dependencies.append(dependency)
        return PBXAggregateTarget(reference: reference,
                                  buildConfigurationList: buildConfigurationList,
                                  buildPhases: buildPhases,
                                  buildRules: buildRules,
                                  dependencies: dependencies,
                                  name: name,
                                  productName: productName,
                                  productReference: productReference,
                                  productType: productType)
    }
    
    /// Returns a new aggregate target with a dependency removed.
    ///
    /// - Parameter dependency: dependency to be removed.
    /// - Returns: new aggregate target with the dependency removed.
    public func removing(dependency: UUID) -> PBXAggregateTarget {
        var dependencies = self.dependencies
        if let index = dependencies.index(of: dependency) {
            dependencies.remove(at: index)
        }
        return PBXAggregateTarget(reference: reference,
                                  buildConfigurationList: buildConfigurationList,
                                  buildPhases: buildPhases,
                                  buildRules: buildRules,
                                  dependencies: dependencies,
                                  name: name,
                                  productName: productName,
                                  productReference: productReference,
                                  productType: productType)
    }
    
    /// Returns a new aggregate target with the given depenendencies.
    ///
    /// - Parameter dependencies: dependencies for the new aggregate target.
    /// - Returns: new aggregate target with the dependencies.
    public func with(dependencies: [UUID]) -> PBXAggregateTarget {
        return PBXAggregateTarget(reference: reference,
                                  buildConfigurationList: buildConfigurationList,
                                  buildPhases: buildPhases,
                                  buildRules: buildRules,
                                  dependencies: dependencies,
                                  name: name,
                                  productName: productName,
                                  productReference: productReference,
                                  productType: productType)
    }
    
}

// MARK: - PBXAggregateTarget Extension (PlistSerializable)

extension PBXAggregateTarget: PlistSerializable {
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        dictionary["isa"] = .string(CommentedString(PBXAggregateTarget.isa))
        let buildConfigurationListComment = "Build configuration list for PBXAggregateTarget \"\(name)\""
        dictionary["buildConfigurationList"] = .string(CommentedString(PBXNativeTarget.isa,
                                                                       comment: buildConfigurationListComment))
        dictionary["buildPhases"] = .array(buildPhases
            .map { buildPhase in
                let comment: String? = proj.buildPhaseType(from: buildPhase)
                return .string(CommentedString(buildPhase, comment: comment))
        })
        dictionary["buildRules"] = .array(buildRules.map {.string(CommentedString($0))})
        dictionary["dependencies"] = .array(dependencies.map {.string(CommentedString($0,
                                                                                      comment: "PBXTargetDependency"))})
        dictionary["name"] = .string(CommentedString(name))
        if let productName = productName {
            dictionary["productName"] = .string(CommentedString(productName))
        }
        if let productType = productType {
            dictionary["productType"] = .string(CommentedString("\"\(productType.rawValue)\""))
        }
        if let productReference = productReference {
            let productReferenceComment = proj.buildFileName(reference: productReference)
            dictionary["productReference"] = .string(CommentedString(productReference,
                                                                     comment: productReferenceComment))
        }
        return (key: CommentedString(self.reference, comment: name),
                value: .dictionary(dictionary))
    }
}
