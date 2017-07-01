import Foundation
import Unbox

/// This is the element for a build target that produces a binary content (application or library).
public struct PBXNativeTarget: PBXTarget {
    
    /// Element reference.
    public let reference: UUID

    /// Target build configuration list.
    public let buildConfigurationList: UUID
    
    /// Target build phases.
    public let buildPhases: [UUID]
    
    /// Target build rules.
    public let buildRules: [UUID]
    
    /// Target dependencies.
    public let dependencies: [UUID]
    
    /// Target name.
    public let name: String
    
    /// Target product name.
    public let productName: String?
    
    /// Target product reference.
    public let productReference: UUID?
    
    /// Target product type.
    public let productType: PBXProductType?
    
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

// MARK: - PBXNativeTarget Extension (Extras)

extension PBXNativeTarget {
    
    /// Returns a new native target by adding a new build phase.
    ///
    /// - Parameter buildPhase: build phase to be added.
    /// - Returns: native target with the build phase added.
    public func adding(buildPhase: UUID) -> PBXNativeTarget {
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
    public func removing(buildPhase: UUID) -> PBXNativeTarget {
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
    public func adding(buildRule: UUID) -> PBXNativeTarget {
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
    public func removing(buildRule: UUID) -> PBXNativeTarget {
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
    public func adding(dependency: UUID) -> PBXNativeTarget {
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
    public func removing(dependency: UUID) -> PBXNativeTarget {
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

// MARK: - PBXNativeTarget Extension (PBXProjPlistSerializable)

extension PBXNativeTarget: PBXProjPlistSerializable {
    
    func pbxProjPlistElement(proj: PBXProj) -> (key: PBXProjPlistCommentedString, value: PBXProjPlistValue) {
        var dictionary: [PBXProjPlistCommentedString: PBXProjPlistValue] = [:]
        
        dictionary["isa"] = .string(PBXProjPlistCommentedString(PBXNativeTarget.isa))
        let buildConfigurationListComment = "Build configuration list for PBXNativeTarget \"\(name)\""
        dictionary["buildConfigurationList"] = .string(PBXProjPlistCommentedString(PBXNativeTarget.isa,
                                                                                   comment: buildConfigurationListComment))
        dictionary["buildPhases"] = .array(buildPhases
            .map { buildPhase in
                let comment: String? = buildPhaseType(from: buildPhase, proj: proj)
                return .string(PBXProjPlistCommentedString(buildPhase, comment: comment))
        })
        dictionary["buildRules"] = .array(buildRules.map {.string(PBXProjPlistCommentedString($0))})
        dictionary["dependencies"] = .array(dependencies.map {.string(PBXProjPlistCommentedString($0,
                                                                                                  comment: "PBXTargetDependency"))})
        dictionary["name"] = .string(PBXProjPlistCommentedString(name))
        if let productName = productName {
            dictionary["productName"] = .string(PBXProjPlistCommentedString(productName))
        }
        if let productType = productType {
            dictionary["productType"] = .string(PBXProjPlistCommentedString("\"\(productType.rawValue)\""))
        }
        if let productReference = productReference {
            let productReferenceComment = fileName(from: productReference, proj: proj)
            dictionary["productReference"] = .string(PBXProjPlistCommentedString(productReference,
                                                                                 comment: productReferenceComment))
        }
        return (key: PBXProjPlistCommentedString(self.reference, comment: name),
                value: .dictionary(dictionary))
    }
    
    private func buildPhaseType(from reference: UUID, proj: PBXProj) -> String? {
        let sources = proj.objects.sourcesBuildPhases.map {return $0.reference}
        let frameworks = proj.objects.frameworksBuildPhases.map {return $0.reference}
        let resources = proj.objects.resourcesBuildPhases.map {return $0.reference}
        let copyFiles = proj.objects.copyFilesBuildPhases.map {return $0.reference}
        let runScript = proj.objects.shellScriptBuildPhases.map {return $0.reference}
        let headers = proj.objects.headersBuildPhases.map {return $0.reference}
        if sources.contains(reference) {
            return "Sources"
        } else if frameworks.contains(reference) {
            return "Frameworks"
        } else if resources.contains(reference) {
            return "Resources"
        } else if copyFiles.contains(reference) {
            return "Copy Files"
        } else if runScript.contains(reference) {
            return "Run Script"
        } else if headers.contains(reference) {
            return "Headers"
        }
        return nil
    }
    
    private func fileName(from reference: UUID, proj: PBXProj) -> String? {
        return proj.objects.fileReferences
            .filter {$0.reference == reference}
            .flatMap { $0.path }
            .first
    }
    
}
