import Foundation
import xcodeprojextensions

public enum PBXObject {
    
    case pbxNativeTarget(PBXNativeTarget)
    case pbxAggregateTarget(PBXAggregateTarget)
    case pbxBuildFile(PBXBuildFile)
    case pbxFileReference(PBXFileReference)
    case pbxProject(PBXProject)
    case pbxFileElement(PBXFileElement)
    case pbxGroup(PBXGroup)
    case pbxHeadersBuildPhase(PBXHeadersBuildPhase)
    case pbxFrameworksBuildPhase(PBXFrameworksBuildPhase)
    case pbxResourcesBuildPhase(PBXResourcesBuildPhase)
    case pbxShellScriptBuildPhase(PBXShellScriptBuildPhase)
    case pbxSourcesBuildPhase(PBXSourcesBuildPhase)
    case pbxTargetDependency(PBXTargetDependency)
    case pbxVariantGroup(PBXVariantGroup)
    case xcBuildConfiguration(XCBuildConfiguration)
    case xcConfigurationList(XCConfigurationList)
    case pbxCopyFilesBuildPhase(PBXCopyFilesBuildPhase)
    case pbxContainerItemProxy(PBXContainerItemProxy)
    
}

// MARK: - PBXObject Extension (Init)

extension PBXObject {
    
    public init(reference: String, dictionary: [String: Any]) throws {
        guard let isa = dictionary["isa"] as? String else { throw PBXObjectError.missingIsa }
        switch isa {
        case PBXNativeTarget.isa:
            self = .pbxNativeTarget(try PBXNativeTarget(reference: reference, dictionary: dictionary))
        case PBXAggregateTarget.isa:
            self = .pbxAggregateTarget(try PBXAggregateTarget(reference: reference, dictionary: dictionary))
        case PBXBuildFile.isa:
            self = .pbxBuildFile(try PBXBuildFile(reference: reference, dictionary: dictionary))
        case PBXFileReference.isa:
            self = .pbxFileReference(try PBXFileReference(reference: reference, dictionary: dictionary))
        case PBXProject.isa:
            self = .pbxProject(try PBXProject(reference: reference, dictionary: dictionary))
        case PBXFileElement.isa:
            self = .pbxFileElement(try PBXFileElement(reference: reference, dictionary: dictionary))
        case PBXGroup.isa:
            self = .pbxGroup(try PBXGroup(reference: reference, dictionary: dictionary))
        case PBXHeadersBuildPhase.isa:
            self = .pbxHeadersBuildPhase(try PBXHeadersBuildPhase(reference: reference, dictionary: dictionary))
        case PBXFrameworksBuildPhase.isa:
            self = .pbxFrameworksBuildPhase(try PBXFrameworksBuildPhase(reference: reference, dictionary: dictionary))
        case XCConfigurationList.isa:
            self = .xcConfigurationList(try XCConfigurationList(reference: reference, dictionary: dictionary))
        case PBXResourcesBuildPhase.isa:
            self = .pbxResourcesBuildPhase(try PBXResourcesBuildPhase(reference: reference, dictionary: dictionary))
        case PBXShellScriptBuildPhase.isa:
            self = .pbxShellScriptBuildPhase(try PBXShellScriptBuildPhase(reference: reference, dictionary: dictionary))
        case PBXSourcesBuildPhase.isa:
            self = .pbxSourcesBuildPhase(try PBXSourcesBuildPhase(reference: reference, dictionary: dictionary))
        case PBXTargetDependency.isa:
            self = .pbxTargetDependency(try PBXTargetDependency(reference: reference, dictionary: dictionary))
        case PBXVariantGroup.isa:
            self = .pbxVariantGroup(try PBXVariantGroup(reference: reference, dictionary: dictionary))
        case XCBuildConfiguration.isa:
            self = .xcBuildConfiguration(try XCBuildConfiguration(reference: reference, dictionary: dictionary))
        case PBXCopyFilesBuildPhase.isa:
            self = .pbxCopyFilesBuildPhase(try PBXCopyFilesBuildPhase(reference: reference, dictionary: dictionary))
        case PBXContainerItemProxy.isa:
            self = .pbxContainerItemProxy(try PBXContainerItemProxy(reference: reference, dictionary: dictionary))
        default:
            throw PBXObjectError.unknownElement(isa)
        }
    }
    
}

// MARK: - PBXObject Extension (Extras)

extension PBXObject {
    
    public var reference: String {
        switch self {
        case .pbxBuildFile(let element): return element.reference
        case .pbxAggregateTarget(let element): return element.reference
        case .pbxContainerItemProxy(let element): return element.reference
        case .pbxCopyFilesBuildPhase(let element): return element.reference
        case .pbxGroup(let element): return element.reference
        case .pbxFileElement(let element): return element.reference
        case .xcConfigurationList(let element): return element.reference
        case .xcBuildConfiguration(let element): return element.reference
        case .pbxVariantGroup(let element): return element.reference
        case .pbxTargetDependency(let element): return element.reference
        case .pbxSourcesBuildPhase(let element): return element.reference
        case .pbxShellScriptBuildPhase(let element): return element.reference
        case .pbxResourcesBuildPhase(let element): return element.reference
        case .pbxFrameworksBuildPhase(let element): return element.reference
        case .pbxHeadersBuildPhase(let element): return element.reference
        case .pbxNativeTarget(let element): return element.reference
        case .pbxFileReference(let element): return element.reference
        case .pbxProject(let element): return element.reference
        }
    }
    
}

// MARK: - PBXObject

extension PBXObject: Hashable {
    
    public var hashValue: Int {
        switch self {
        case .pbxBuildFile(let element): return element.hashValue
        case .pbxAggregateTarget(let element): return element.hashValue
        case .pbxContainerItemProxy(let element): return element.hashValue
        case .pbxCopyFilesBuildPhase(let element): return element.hashValue
        case .pbxGroup(let element): return element.hashValue
        case .pbxFileElement(let element): return element.hashValue
        case .xcConfigurationList(let element): return element.hashValue
        case .xcBuildConfiguration(let element): return element.hashValue
        case .pbxVariantGroup(let element): return element.hashValue
        case .pbxTargetDependency(let element): return element.hashValue
        case .pbxSourcesBuildPhase(let element): return element.hashValue
        case .pbxShellScriptBuildPhase(let element): return element.hashValue
        case .pbxResourcesBuildPhase(let element): return element.hashValue
        case .pbxFrameworksBuildPhase(let element): return element.hashValue
        case .pbxHeadersBuildPhase(let element): return element.hashValue
        case .pbxNativeTarget(let element): return element.hashValue
        case .pbxFileReference(let element): return element.hashValue
        case .pbxProject(let element): return element.hashValue
        }
    }
    
    public static func == (lhs: PBXObject, rhs: PBXObject) -> Bool {
        switch (lhs, rhs) {
        case (.pbxNativeTarget(let lhsElement), .pbxNativeTarget(let rhsElement)):
            return lhsElement == rhsElement
        case (.pbxAggregateTarget(let lhsElement), .pbxAggregateTarget(let rhsElement)):
            return lhsElement == rhsElement
        case (.pbxBuildFile(let lhsElement), .pbxBuildFile(let rhsElement)):
            return lhsElement == rhsElement
        case (.pbxFileReference(let lhsElement), .pbxFileReference(let rhsElement)):
            return lhsElement == rhsElement
        case (.pbxProject(let lhsElement), .pbxProject(let rhsElement)):
            return lhsElement == rhsElement
        case (.pbxFileElement(let lhsElement), .pbxFileElement(let rhsElement)):
            return lhsElement == rhsElement
        case (.pbxGroup(let lhsElement), .pbxGroup(let rhsElement)):
            return lhsElement == rhsElement
        case (.pbxHeadersBuildPhase(let lhsElement), .pbxHeadersBuildPhase(let rhsElement)):
            return lhsElement == rhsElement
        case (.pbxFrameworksBuildPhase(let lhsElement), .pbxFrameworksBuildPhase(let rhsElement)):
            return lhsElement == rhsElement
        case (.pbxResourcesBuildPhase(let lhsElement), .pbxResourcesBuildPhase(let rhsElement)):
            return lhsElement == rhsElement
        case (.pbxShellScriptBuildPhase(let lhsElement), .pbxShellScriptBuildPhase(let rhsElement)):
            return lhsElement == rhsElement
        case (.pbxSourcesBuildPhase(let lhsElement), .pbxSourcesBuildPhase(let rhsElement)):
            return lhsElement == rhsElement
        case (.pbxTargetDependency(let lhsElement), .pbxTargetDependency(let rhsElement)):
            return lhsElement == rhsElement
        case (.pbxVariantGroup(let lhsElement), .pbxVariantGroup(let rhsElement)):
            return lhsElement == rhsElement
        case (.xcBuildConfiguration(let lhsElement), .xcBuildConfiguration(let rhsElement)):
            return lhsElement == rhsElement
        case (.xcConfigurationList(let lhsElement), .xcConfigurationList(let rhsElement)):
            return lhsElement == rhsElement
        case (.pbxCopyFilesBuildPhase(let lhsElement), .pbxCopyFilesBuildPhase(let rhsElement)):
            return lhsElement == rhsElement
        case (.pbxContainerItemProxy(let lhsElement), .pbxContainerItemProxy(let rhsElement)):
            return lhsElement == rhsElement
        default:
            return false
        }
    }
    
}

/// PBXObjectError
///
/// - missingIsa: the isa attribute is missing.
/// - unknownElement: the object type is not supported.
public enum PBXObjectError: Error, CustomStringConvertible {
    case missingIsa
    case unknownElement(String)
    
    public var description: String {
        switch self {
        case .missingIsa:
            return "Isa property is missing"
        case .unknownElement(let element):
            return "The element \(element) is not supported"
        }
    }
}

// MARK: - Array Extension (PBXObject)

public extension Array where Element == PBXObject {
    
    var buildFiles: [PBXBuildFile] {
        return flatMap {
            guard case .pbxBuildFile(let object) = $0 else { return nil }
            return object
        }
    }
    
    var aggregateTargets: [PBXAggregateTarget] {
        return flatMap {
            guard case .pbxAggregateTarget(let object) = $0 else { return nil }
            return object
        }
    }
    
    var containerItemProxies: [PBXContainerItemProxy] {
        return flatMap {
            guard case .pbxContainerItemProxy(let object) = $0 else { return nil }
            return object
        }
    }
    
    var copyFilesBuildPhases: [PBXCopyFilesBuildPhase] {
        return flatMap {
            guard case .pbxCopyFilesBuildPhase(let object) = $0 else { return nil }
            return object
        }
    }
    
    var groups: [PBXGroup] {
        return flatMap {
            guard case .pbxGroup(let object) = $0 else { return nil }
            return object
        }
    }
    
    var fileElements: [PBXFileElement] {
        return flatMap {
            guard case .pbxFileElement(let object) = $0 else { return nil }
            return object
        }
    }
    
    var configurationLists: [XCConfigurationList] {
        return flatMap {
            guard case .xcConfigurationList(let object) = $0 else { return nil }
            return object
        }
    }
    
    var buildConfigurations: [XCBuildConfiguration] {
        return flatMap {
            guard case .xcBuildConfiguration(let object) = $0 else { return nil }
            return object
        }
    }
    
    var variantGroups: [PBXVariantGroup] {
        return flatMap {
            guard case .pbxVariantGroup(let object) = $0 else { return nil }
            return object
        }
    }
    
    var targetDependencies: [PBXTargetDependency] {
        return flatMap {
            guard case .pbxTargetDependency(let object) = $0 else { return nil }
            return object
        }
    }
    
    var sourcesBuildPhases: [PBXSourcesBuildPhase] {
        return flatMap {
            guard case .pbxSourcesBuildPhase(let object) = $0 else { return nil }
            return object
        }
    }
    
    var shellScriptBuildPhases: [PBXShellScriptBuildPhase] {
        return flatMap {
            guard case .pbxShellScriptBuildPhase(let object) = $0 else { return nil }
            return object
        }
    }
    
    var resourcesBuildPhases: [PBXResourcesBuildPhase] {
        return flatMap {
            guard case .pbxResourcesBuildPhase(let object) = $0 else { return nil }
            return object
        }
    }
    
    var frameworksBuildPhases: [PBXFrameworksBuildPhase] {
        return flatMap {
            guard case .pbxFrameworksBuildPhase(let object) = $0 else { return nil }
            return object
        }
    }
    
    var headersBuildPhases: [PBXHeadersBuildPhase] {
        return flatMap {
            guard case .pbxHeadersBuildPhase(let object) = $0 else { return nil }
            return object
        }
    }
    
    var nativeTargets: [PBXNativeTarget] {
        return flatMap {
            guard case .pbxNativeTarget(let object) = $0 else { return nil }
            return object
        }
    }
    
    var fileReferences: [PBXFileReference] {
        return flatMap {
            guard case .pbxFileReference(let object) = $0 else { return nil }
            return object
        }
    }

    var projects: [PBXProject] {
        return flatMap {
            guard case .pbxProject(let object) = $0 else { return nil }
            return object
        }
    }

    func fileName(from reference: String) -> String? {
        return self.fileReferences.filter { $0.reference == reference }.flatMap { $0.name }.first
    }
    
    func configName(from reference: String) -> String? {
        return self.buildConfigurations.filter { $0.reference == reference }.map { $0.name }.first
    }

}
