import Foundation

public enum PBXObject: Hashable {
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
    
    // MARK: - Init
    
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
    
    // MARK: - Hashable
    
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
}

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

extension Array where Element == PBXObject {
    
    var buildFiles: [PBXBuildFile] {
        return self
            .map { element in
                switch element {
                case .pbxBuildFile(let buildFile):
                    return buildFile
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    var aggregateTargets: [PBXAggregateTarget] {
        return self
            .map { element in
                switch element {
                case .pbxAggregateTarget(let target):
                    return target
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    var containerItemProxies: [PBXContainerItemProxy] {
        return self
            .map { element in
                switch element {
                case .pbxContainerItemProxy(let proxy):
                    return proxy
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    var copyFilesBuildPhases: [PBXCopyFilesBuildPhase] {
        return self
            .map { element in
                switch element {
                case .pbxCopyFilesBuildPhase(let buildPhase):
                    return buildPhase
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    var groups: [PBXGroup] {
        return self
            .map { element in
                switch element {
                case .pbxGroup(let group):
                    return group
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    var fileElements: [PBXFileElement] {
        return self
            .map { element in
                switch element {
                case .pbxFileElement(let fileElement):
                    return fileElement
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    var configurationLists: [XCConfigurationList] {
        return self
            .map { element in
                switch element {
                case .xcConfigurationList(let configurationList):
                    return configurationList
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    var buildConfigurations: [XCBuildConfiguration] {
        return self
            .map { element in
                switch element {
                case .xcBuildConfiguration(let buildConfiguration):
                    return buildConfiguration
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    var variantGroups: [PBXVariantGroup] {
        return self
            .map { element in
                switch element {
                case .pbxVariantGroup(let variantGroup):
                    return variantGroup
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    var targetDependencies: [PBXTargetDependency] {
        return self
            .map { element in
                switch element {
                case .pbxTargetDependency(let targetDependency):
                    return targetDependency
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    var sourcesBuildPhases: [PBXSourcesBuildPhase] {
        return self
            .map { element in
                switch element {
                case .pbxSourcesBuildPhase(let buildPhase):
                    return buildPhase
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    var shellScriptBuildPhases: [PBXShellScriptBuildPhase] {
        return self
            .map { element in
                switch element {
                case .pbxShellScriptBuildPhase(let buildPhase):
                    return buildPhase
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    var resourcesBuildPhases: [PBXResourcesBuildPhase] {
        return self
            .map { element in
                switch element {
                case .pbxResourcesBuildPhase(let buildPhase):
                    return buildPhase
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    var frameworksBuildPhases: [PBXFrameworksBuildPhase] {
        return self
            .map { element in
                switch element {
                case .pbxFrameworksBuildPhase(let buildPhase):
                    return buildPhase
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    var headersBuildPhases: [PBXHeadersBuildPhase] {
        return self
            .map { element in
                switch element {
                case .pbxHeadersBuildPhase(let buildPhase):
                    return buildPhase
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    var nativeTargets: [PBXNativeTarget] {
        return self
            .map { element in
                switch element {
                case .pbxNativeTarget(let target):
                    return target
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    var fileReferences: [PBXFileReference] {
        return self
            .map { element in
                switch element {
                case .pbxFileReference(let fileReference):
                    return fileReference
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
    var projects: [PBXProject] {
        return self
            .map { element in
                switch element {
                case .pbxProject(let project):
                    return project
                default:
                    return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
    }
    
}
