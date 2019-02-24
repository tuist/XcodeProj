 // Generated using Sourcery 0.13.1 — https://github.com/krzysztofzablocki/Sourcery


 // FIXME: EDITING THIS JUST TO SHOW THE DIFF

 import Foundation

 extension PBXBuildFile {

    public static func == (lhs: PBXBuildFile, rhs: PBXBuildFile) -> Bool {
        if lhs.fileReference != rhs.fileReference { return false }
        if !NSDictionary(dictionary: lhs.settings ?? [:]).isEqual(to: rhs.settings ?? [:]) { return false }
        return (lhs as PBXObject) == (rhs as PBXObject)
    }
 }

 extension PBXBuildPhase {

    public static func == (lhs: PBXBuildPhase, rhs: PBXBuildPhase) -> Bool {
        if lhs.buildActionMask != rhs.buildActionMask { return false }
        if lhs.fileReferences != rhs.fileReferences { return false }
        if lhs.inputFileListPaths != rhs.inputFileListPaths { return false }
        if lhs.outputFileListPaths != rhs.outputFileListPaths { return false }
        if lhs.runOnlyForDeploymentPostprocessing != rhs.runOnlyForDeploymentPostprocessing { return false }
        return (lhs as PBXContainerItem) == (rhs as PBXContainerItem)
    }
 }

 extension PBXBuildRule {

    public static func == (lhs: PBXBuildRule, rhs: PBXBuildRule) -> Bool {
        if lhs.compilerSpec != rhs.compilerSpec { return false }
        if lhs.filePatterns != rhs.filePatterns { return false }
        if lhs.fileType != rhs.fileType { return false }
        if lhs.isEditable != rhs.isEditable { return false }
        if lhs.name != rhs.name { return false }
        if lhs.outputFiles != rhs.outputFiles { return false }
        if lhs.outputFilesCompilerFlags != rhs.outputFilesCompilerFlags { return false }
        if lhs.script != rhs.script { return false }
        return (lhs as PBXObject) == (rhs as PBXObject)
    }

 }

 extension PBXContainerItem {

    public static func == (lhs: PBXContainerItem, rhs: PBXContainerItem) -> Bool {
        if lhs.comments != rhs.comments { return false }
        return (lhs as PBXObject) == (rhs as PBXObject)
    }

 }

 extension PBXContainerItemProxy {

     public static func == (lhs: PBXContainerItemProxy, rhs: PBXContainerItemProxy) -> Bool {
         if lhs.containerPortalReference != rhs.containerPortalReference { return false }
         if lhs.proxyType != rhs.proxyType { return false }
         if lhs.remoteGlobalIDReference != rhs.remoteGlobalIDReference { return false }
         if lhs.remoteInfo != rhs.remoteInfo { return false }
         return (lhs as PBXObject) == (rhs as PBXObject)
     }
 }

 extension PBXCopyFilesBuildPhase {
     public static func == (lhs: PBXCopyFilesBuildPhase, rhs: PBXCopyFilesBuildPhase) -> Bool {
         if lhs.dstPath != rhs.dstPath { return false }
         if lhs.dstSubfolderSpec != rhs.dstSubfolderSpec { return false }
         if lhs.name != rhs.name { return false }
         return (lhs as PBXBuildPhase) == (rhs as PBXBuildPhase)
     }
 }

 extension PBXFileElement {

     public static func == (lhs: PBXFileElement, rhs: PBXFileElement) -> Bool {
         if lhs.sourceTree != rhs.sourceTree { return false }
         if lhs.path != rhs.path { return false }
         if lhs.name != rhs.name { return false }
         if lhs.includeInIndex != rhs.includeInIndex { return false }
         if lhs.usesTabs != rhs.usesTabs { return false }
         if lhs.indentWidth != rhs.indentWidth { return false }
         if lhs.tabWidth != rhs.tabWidth { return false }
         if lhs.wrapsLines != rhs.wrapsLines { return false }
         return (lhs as PBXContainerItem) == (rhs as PBXContainerItem)
     }
 }

 extension PBXFileReference {
     public static func == (lhs: PBXFileReference, rhs: PBXFileReference) -> Bool {
         if lhs.fileEncoding != rhs.fileEncoding { return false }
         if lhs.explicitFileType != rhs.explicitFileType { return false }
         if lhs.lastKnownFileType != rhs.lastKnownFileType { return false }
         if lhs.lineEnding != rhs.lineEnding { return false }
         if lhs.languageSpecificationIdentifier != rhs.languageSpecificationIdentifier { return false }
         if lhs.xcLanguageSpecificationIdentifier != rhs.xcLanguageSpecificationIdentifier { return false }
         if lhs.plistStructureDefinitionIdentifier != rhs.plistStructureDefinitionIdentifier { return false }
         return (lhs as PBXFileElement) == (rhs as PBXFileElement)
     }
 }

 extension PBXFrameworksBuildPhase {
     public static func == (lhs: PBXFrameworksBuildPhase, rhs: PBXFrameworksBuildPhase) -> Bool {
         return (lhs as PBXBuildPhase) == (rhs as PBXBuildPhase)
     }
 }

 extension PBXGroup {

     public static func == (lhs: PBXGroup, rhs: PBXGroup) -> Bool {
         if lhs.childrenReferences != rhs.childrenReferences { return false }
         return (lhs as PBXFileElement) == (rhs as PBXFileElement)
     }
 }

 extension PBXHeadersBuildPhase {
    
     public static func == (lhs: PBXHeadersBuildPhase, rhs: PBXHeadersBuildPhase) -> Bool {
         return (lhs as PBXBuildPhase) == (rhs as PBXBuildPhase)
     }
 }

 extension PBXLegacyTarget {

     public static func == (lhs: PBXLegacyTarget, rhs: PBXLegacyTarget) -> Bool {
         if lhs.buildToolPath != rhs.buildToolPath { return false }
         if lhs.buildArgumentsString != rhs.buildArgumentsString { return false }
         if lhs.passBuildSettingsInEnvironment != rhs.passBuildSettingsInEnvironment { return false }
         if lhs.buildWorkingDirectory != rhs.buildWorkingDirectory { return false }
         return (lhs as PBXTarget) == (rhs as PBXTarget)
     }
 }

 extension PBXNativeTarget {
    
     public static func == (lhs: PBXNativeTarget, rhs: PBXNativeTarget) -> Bool {
         if lhs.productInstallPath != rhs.productInstallPath { return false }
         return (lhs as PBXTarget) == (rhs as PBXTarget)
     }
 }

 extension PBXProject {
    
     public static func == (lhs: PBXProject, rhs: PBXProject) -> Bool {
         if lhs.name != rhs.name { return false }
         if lhs.buildConfigurationListReference != rhs.buildConfigurationListReference { return false }
         if lhs.compatibilityVersion != rhs.compatibilityVersion { return false }
         if lhs.developmentRegion != rhs.developmentRegion { return false }
         if lhs.hasScannedForEncodings != rhs.hasScannedForEncodings { return false }
         if lhs.knownRegions != rhs.knownRegions { return false }
         if lhs.mainGroupReference != rhs.mainGroupReference { return false }
         if lhs.productsGroupReference != rhs.productsGroupReference { return false }
         if lhs.projectDirPath != rhs.projectDirPath { return false }
         if lhs.projectReferences != rhs.projectReferences { return false }
         if lhs.projectRoots != rhs.projectRoots { return false }
         if lhs.targetReferences != rhs.targetReferences { return false }
         if !NSDictionary(dictionary: lhs.attributes).isEqual(to: rhs.attributes) { return false }
         if !NSDictionary(dictionary: lhs.targetAttributeReferences).isEqual(to: rhs.targetAttributeReferences) { return false }
         return (lhs as PBXObject) == (rhs as PBXObject)
     }
 }

 extension PBXReferenceProxy {
    
     public static func == (lhs: PBXReferenceProxy, rhs: PBXReferenceProxy) -> Bool {
         if lhs.fileType != rhs.fileType { return false }
         if lhs.path != rhs.path { return false }
         if lhs.remoteReference != rhs.remoteReference { return false }
         if lhs.sourceTree != rhs.sourceTree { return false }
         return (lhs as PBXFileElement) == (rhs as PBXFileElement)
     }
 }

 extension PBXResourcesBuildPhase {
    
     public static func == (lhs: PBXResourcesBuildPhase, rhs: PBXResourcesBuildPhase) -> Bool {
         return (lhs as PBXBuildPhase) == (rhs as PBXBuildPhase)
     }
 }

 extension PBXRezBuildPhase {
    
     public static func == (lhs: PBXRezBuildPhase, rhs: PBXRezBuildPhase) -> Bool {
         return (lhs as PBXBuildPhase) == (rhs as PBXBuildPhase)
     }
 }

 extension PBXShellScriptBuildPhase {
    
     public static func == (lhs: PBXShellScriptBuildPhase, rhs: PBXShellScriptBuildPhase) -> Bool {
         if lhs.name != rhs.name { return false }
         if lhs.inputPaths != rhs.inputPaths { return false }
         if lhs.outputPaths != rhs.outputPaths { return false }
         if lhs.shellPath != rhs.shellPath { return false }
         if lhs.shellScript != rhs.shellScript { return false }
         if lhs.showEnvVarsInLog != rhs.showEnvVarsInLog { return false }
         return (lhs as PBXBuildPhase) == (rhs as PBXBuildPhase)
     }
 }

 extension PBXSourcesBuildPhase {
    
     public static func == (lhs: PBXSourcesBuildPhase, rhs: PBXSourcesBuildPhase) -> Bool {
         return (lhs as PBXBuildPhase) == (rhs as PBXBuildPhase)
     }
 }

 extension PBXTarget {
    
     public static func == (lhs: PBXTarget, rhs: PBXTarget) -> Bool {
         if lhs.buildConfigurationListReference != rhs.buildConfigurationListReference { return false }
         if lhs.buildPhaseReferences != rhs.buildPhaseReferences { return false }
         if lhs.buildRuleReferences != rhs.buildRuleReferences { return false }
         if lhs.dependencyReferences != rhs.dependencyReferences { return false }
         if lhs.name != rhs.name { return false }
         if lhs.productName != rhs.productName { return false }
         if lhs.productReference != rhs.productReference { return false }
         if lhs.productType != rhs.productType { return false }
         return (lhs as PBXContainerItem) == (rhs as PBXContainerItem)
     }
 }

 extension PBXTargetDependency {
    
     public static func == (lhs: PBXTargetDependency, rhs: PBXTargetDependency) -> Bool {
         if lhs.name != rhs.name { return false }
         if lhs.targetReference != rhs.targetReference { return false }
         if lhs.targetProxyReference != rhs.targetProxyReference { return false }
         return (lhs as PBXObject) == (rhs as PBXObject)
     }
 }

 extension PBXVariantGroup {
    
     public static func == (lhs: PBXVariantGroup, rhs: PBXVariantGroup) -> Bool {
         return (lhs as PBXGroup) == (rhs as PBXGroup)
     }
 }

 extension XCBuildConfiguration {
    
     public static func == (lhs: XCBuildConfiguration, rhs: XCBuildConfiguration) -> Bool {
         if lhs.baseConfigurationReference != rhs.baseConfigurationReference { return false }
         if !NSDictionary(dictionary: lhs.buildSettings).isEqual(to: rhs.buildSettings) { return false }
         if lhs.name != rhs.name { return false }
         return (lhs as PBXObject) == (rhs as PBXObject)
     }
 }

 extension XCConfigurationList {
    
     public static func == (lhs: XCConfigurationList, rhs: XCConfigurationList) -> Bool {
         if lhs.buildConfigurationReferences != rhs.buildConfigurationReferences { return false }
         if lhs.defaultConfigurationIsVisible != rhs.defaultConfigurationIsVisible { return false }
         if lhs.defaultConfigurationName != rhs.defaultConfigurationName { return false }
         return (lhs as PBXObject) == (rhs as PBXObject)
     }
 }

 extension XCVersionGroup {
    
     public static func == (lhs: XCVersionGroup, rhs: XCVersionGroup) -> Bool {
         if lhs.currentVersionReference != rhs.currentVersionReference { return false }
         if lhs.versionGroupType != rhs.versionGroupType { return false }
         return (lhs as PBXObject) == (rhs as PBXObject)
     }
 }
