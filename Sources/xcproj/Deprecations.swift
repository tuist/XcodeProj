import Foundation

// swiftlint:disable line_length
extension PBXProj {

    @available(*, deprecated, message: "Use objects.buildFiles instead") public var buildFiles: [PBXBuildFile] { get { return objects.buildFiles.referenceValues } set(val) { objects.buildFiles = Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.aggregateTargets instead") public var aggregateTargets: [PBXAggregateTarget] { get { return objects.aggregateTargets.referenceValues } set(val) { objects.aggregateTargets = Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.containerItemProxies instead") public var containerItemProxies: [PBXContainerItemProxy] { get { return objects.containerItemProxies.referenceValues } set(val) { objects.containerItemProxies = Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.copyFilesBuildPhases instead") public var copyFilesBuildPhases: [PBXCopyFilesBuildPhase] { get { return objects.copyFilesBuildPhases.referenceValues } set(val) { objects.copyFilesBuildPhases = Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.groups instead") public var groups: [PBXGroup] { get { return objects.groups.referenceValues } set(val) { objects.groups = Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.configurationLists instead") public var configurationLists: [XCConfigurationList] { get { return objects.configurationLists.referenceValues } set(val) { objects.configurationLists = Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.versionGroups instead") public var versionGroups: [XCVersionGroup] { get { return objects.versionGroups.referenceValues } set(val) { objects.versionGroups = Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.buildConfigurations instead") public var buildConfigurations: [XCBuildConfiguration] { get { return objects.buildConfigurations.referenceValues } set(val) { objects.buildConfigurations = Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.variantGroups instead") public var variantGroups: [PBXVariantGroup] { get { return objects.variantGroups.referenceValues } set(val) { objects.variantGroups = Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.targetDependencies instead") public var targetDependencies: [PBXTargetDependency] { get { return objects.targetDependencies.referenceValues } set(val) { objects.targetDependencies = Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.sourcesBuildPhases instead") public var sourcesBuildPhases: [PBXSourcesBuildPhase] { get { return objects.sourcesBuildPhases.referenceValues } set(val) { objects.sourcesBuildPhases = Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.shellScriptBuildPhases instead") public var shellScriptBuildPhases: [PBXShellScriptBuildPhase] { get { return objects.shellScriptBuildPhases.referenceValues } set(val) { objects.shellScriptBuildPhases = Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.resourcesBuildPhases instead") public var resourcesBuildPhases: [PBXResourcesBuildPhase] { get { return objects.resourcesBuildPhases.referenceValues } set(val) { objects.resourcesBuildPhases = Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.frameworksBuildPhases instead") public var frameworksBuildPhases: [PBXFrameworksBuildPhase] { get { return objects.frameworksBuildPhases.referenceValues } set(val) { objects.frameworksBuildPhases = Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.headersBuildPhases instead") public var headersBuildPhases: [PBXHeadersBuildPhase] { get { return objects.headersBuildPhases.referenceValues } set(val) { objects.headersBuildPhases =  Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.nativeTargets instead") public var nativeTargets: [PBXNativeTarget] { get { return objects.nativeTargets.referenceValues } set(val) { objects.nativeTargets = Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.fileReferences instead") public var fileReferences: [PBXFileReference] { get { return objects.fileReferences.referenceValues } set(val) { objects.fileReferences = Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.projects instead") public var projects: [PBXProject] { get { return objects.projects.referenceValues } set(val) { objects.projects = Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.referenceProxies instead") public var referenceProxies: [PBXReferenceProxy] { get { return objects.referenceProxies.referenceValues } set(val) { objects.referenceProxies = Dictionary(references: val) } }
    @available(*, deprecated, message: "Use objects.buildPhases instead") public var buildPhases: [PBXBuildPhase] { return objects.buildPhases.referenceValues }
}
