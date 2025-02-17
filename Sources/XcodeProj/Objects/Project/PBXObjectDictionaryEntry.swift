import Foundation

struct PBXObjectDictionaryEntry: Decodable {
    let object: PBXObject

    enum CodingKeys: CodingKey {
        case isa
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let isa = try container.decode(String.self, forKey: .isa)

        object = switch isa {
        case PBXFileElement.isa: try PBXFileElement(from: decoder)
        case PBXBuildFile.isa: try PBXBuildFile(from: decoder)
        case PBXFileReference.isa: try PBXFileReference(from: decoder)
        case PBXLegacyTarget.isa: try PBXLegacyTarget(from: decoder)
        case PBXNativeTarget.isa: try PBXNativeTarget(from: decoder)
        case PBXAggregateTarget.isa: try PBXAggregateTarget(from: decoder)
        case PBXProject.isa: try PBXProject(from: decoder)
        case PBXGroup.isa: try PBXGroup(from: decoder)
        case PBXHeadersBuildPhase.isa: try PBXHeadersBuildPhase(from: decoder)
        case PBXFrameworksBuildPhase.isa: try PBXFrameworksBuildPhase(from: decoder)
        case XCConfigurationList.isa: try XCConfigurationList(from: decoder)
        case PBXResourcesBuildPhase.isa: try PBXResourcesBuildPhase(from: decoder)
        case PBXShellScriptBuildPhase.isa: try PBXShellScriptBuildPhase(from: decoder)
        case PBXSourcesBuildPhase.isa: try PBXSourcesBuildPhase(from: decoder)
        case PBXTargetDependency.isa: try PBXTargetDependency(from: decoder)
        case PBXVariantGroup.isa: try PBXVariantGroup(from: decoder)
        case XCBuildConfiguration.isa: try XCBuildConfiguration(from: decoder)
        case PBXCopyFilesBuildPhase.isa: try PBXCopyFilesBuildPhase(from: decoder)
        case PBXContainerItemProxy.isa: try PBXContainerItemProxy(from: decoder)
        case PBXReferenceProxy.isa: try PBXReferenceProxy(from: decoder)
        case XCVersionGroup.isa: try XCVersionGroup(from: decoder)
        case PBXRezBuildPhase.isa: try PBXRezBuildPhase(from: decoder)
        case PBXBuildRule.isa: try PBXBuildRule(from: decoder)
        case XCRemoteSwiftPackageReference.isa: try XCRemoteSwiftPackageReference(from: decoder)
        case XCLocalSwiftPackageReference.isa: try XCLocalSwiftPackageReference(from: decoder)
        case XCSwiftPackageProductDependency.isa: try XCSwiftPackageProductDependency(from: decoder)
        case PBXFileSystemSynchronizedRootGroup.isa: try PBXFileSystemSynchronizedRootGroup(from: decoder)
        case PBXFileSystemSynchronizedBuildFileExceptionSet.isa: try PBXFileSystemSynchronizedBuildFileExceptionSet(from: decoder)
        default:
            throw PBXObjectError.unknownElement(isa)
        }
    }
}
