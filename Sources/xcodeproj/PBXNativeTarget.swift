import Foundation
import Unbox

/// This is the element for a build target that produces a binary content (application or library).
public struct PBXNativeTarget: PBXTarget {
    
    /// Element reference.
    public var reference: String

    /// Target build configuration list.
    public var buildConfigurationList: String
    
    /// Target build phases.
    public var buildPhases: [String]
    
    /// Target build rules.
    public var buildRules: [String]
    
    /// Target dependencies.
    public var dependencies: [String]
    
    /// Target name.
    public var name: String
    
    /// Target product name.
    public var productName: String?
    
    /// Target product reference.
    public var productReference: String?
    
    /// Target product type.
    public var productType: PBXProductType?
    
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
    public init(reference: String,
                buildConfigurationList: String,
                buildPhases: [String],
                buildRules: [String],
                dependencies: [String],
                name: String,
                productName: String? = nil,
                productReference: String? = nil,
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

// MARK: - PBXNativeTarget Extension (ProjectElement)

extension PBXNativeTarget: ProjectElement {
    
    public static var isa: String = "PBXNativeTarget"
    
    public static func == (lhs: PBXNativeTarget,
                           rhs: PBXNativeTarget) -> Bool {
        return lhs.reference == rhs.reference &&
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
    
    public init(reference: String, dictionary: [String : Any]) throws {
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

// MARK: - PBXNativeTarget Extension (Extras)

extension PBXNativeTarget {
    
    /// Returns a new native target by adding a new build phase.
    ///
    /// - Parameter buildPhase: build phase to be added.
    /// - Returns: native target with the build phase added.
    public func adding(buildPhase: String) -> PBXNativeTarget {
        var buildPhases = self.buildPhases
        buildPhases.append(buildPhase)
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
    public func removing(buildPhase: String) -> PBXNativeTarget {
        var buildPhases = self.buildPhases
        if let index = self.buildPhases.index(of: buildPhase) {
            buildPhases.remove(at: index)
        }
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
    public func adding(buildRule: String) -> PBXNativeTarget {
        var buildRules = self.buildRules
        buildRules.append(buildRule)
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
    public func removing(buildRule: String) -> PBXNativeTarget {
        var buildRules = self.buildRules
        if let index = buildRules.index(of: buildRule) {
            buildRules.remove(at: index)
        }
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
    public func adding(dependency: String) -> PBXNativeTarget {
        var dependencies = self.dependencies
        dependencies.append(dependency)
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
    public func removing(dependency: String) -> PBXNativeTarget {
        var dependencies = self.dependencies
        if let index = dependencies.index(of: dependency) {
            dependencies.remove(at: index)
        }
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
    
}

// MARK: - PBXNativeTarget Extension (PlistSerializable)

extension PBXNativeTarget: PlistSerializable {
    
    func plistKeyAndValue(proj: PBXProj) -> (key: CommentedString, value: PlistValue) {
        var dictionary: [CommentedString: PlistValue] = [:]
        
        dictionary["isa"] = .string(CommentedString(PBXNativeTarget.isa))
        let buildConfigurationListComment = "Build configuration list for PBXNativeTarget \"\(name)\""
        dictionary["buildConfigurationList"] = .string(CommentedString(buildConfigurationList,
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
