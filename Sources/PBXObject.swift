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
    
    // MARK: - Hashable
    
    public static func == (lhs: PBXObject, rhs: PBXObject) -> Bool {
        return false
//        switch (lhs, rhs) {
//        case (.pbxLegacyTarget(let lhsElement), .pbxLegacyTarget(let rhsElement)):
//            return lhsElement == rhsElement
//        default:
//            return false
//        }
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
