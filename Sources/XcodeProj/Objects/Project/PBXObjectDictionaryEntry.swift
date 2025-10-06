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
        case "PBXFileElement": try PBXFileElement(from: decoder)
        case "PBXBuildFile": try PBXBuildFile(from: decoder)
        case "PBXFileReference": try PBXFileReference(from: decoder)
        case "PBXLegacyTarget": try PBXLegacyTarget(from: decoder)
        case "PBXNativeTarget": try PBXNativeTarget(from: decoder)
        case "PBXAggregateTarget": try PBXAggregateTarget(from: decoder)
        case "PBXProject": try PBXProject(from: decoder)
        case "PBXGroup": try PBXGroup(from: decoder)
        case "PBXHeadersBuildPhase": try PBXHeadersBuildPhase(from: decoder)
        case "PBXFrameworksBuildPhase": try PBXFrameworksBuildPhase(from: decoder)
        case "XCConfigurationList": try XCConfigurationList(from: decoder)
        case "PBXResourcesBuildPhase": try PBXResourcesBuildPhase(from: decoder)
        case "PBXShellScriptBuildPhase": try PBXShellScriptBuildPhase(from: decoder)
        case "PBXSourcesBuildPhase": try PBXSourcesBuildPhase(from: decoder)
        case "PBXTargetDependency": try PBXTargetDependency(from: decoder)
        case "PBXVariantGroup": try PBXVariantGroup(from: decoder)
        case "XCBuildConfiguration": try XCBuildConfiguration(from: decoder)
        case "PBXCopyFilesBuildPhase": try PBXCopyFilesBuildPhase(from: decoder)
        case "PBXContainerItemProxy": try PBXContainerItemProxy(from: decoder)
        case "PBXReferenceProxy": try PBXReferenceProxy(from: decoder)
        case "XCVersionGroup": try XCVersionGroup(from: decoder)
        case "PBXRezBuildPhase": try PBXRezBuildPhase(from: decoder)
        case "PBXBuildRule": try PBXBuildRule(from: decoder)
        case "XCRemoteSwiftPackageReference": try XCRemoteSwiftPackageReference(from: decoder)
        case "XCLocalSwiftPackageReference": try XCLocalSwiftPackageReference(from: decoder)
        case "XCSwiftPackageProductDependency": try XCSwiftPackageProductDependency(from: decoder)
        case "PBXFileSystemSynchronizedRootGroup": try PBXFileSystemSynchronizedRootGroup(from: decoder)
        case "PBXFileSystemSynchronizedBuildFileExceptionSet": try PBXFileSystemSynchronizedBuildFileExceptionSet(from: decoder)
        case "PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet": try PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet(from: decoder)
        default:
            throw PBXObjectError.unknownElement(isa)
        }
    }
}
