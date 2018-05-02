// Generated using Sourcery 0.13.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation

extension PBXAggregateTarget {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXAggregateTarget else { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXBuildFile {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXBuildFile else { return false }
      if self.fileRef != rhs.fileRef { return false }
      if !NSDictionary(dictionary: self.settings ?? [:]).isEqual(to: rhs.settings ?? [:]) { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXBuildPhase {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXBuildPhase else { return false }
      if self.buildActionMask != rhs.buildActionMask { return false }
      if self.files != rhs.files { return false }
      if self.runOnlyForDeploymentPostprocessing != rhs.runOnlyForDeploymentPostprocessing { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXBuildRule {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXBuildRule else { return false }
      if self.compilerSpec != rhs.compilerSpec { return false }
      if self.filePatterns != rhs.filePatterns { return false }
      if self.fileType != rhs.fileType { return false }
      if self.isEditable != rhs.isEditable { return false }
      if self.name != rhs.name { return false }
      if self.outputFiles != rhs.outputFiles { return false }
      if self.outputFilesCompilerFlags != rhs.outputFilesCompilerFlags { return false }
      if self.script != rhs.script { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXContainerItem {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXContainerItem else { return false }
      if self.comments != rhs.comments { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXContainerItemProxy {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXContainerItemProxy else { return false }
      if self.containerPortal != rhs.containerPortal { return false }
      if self.proxyType != rhs.proxyType { return false }
      if self.remoteGlobalIDString != rhs.remoteGlobalIDString { return false }
      if self.remoteInfo != rhs.remoteInfo { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXCopyFilesBuildPhase {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXCopyFilesBuildPhase else { return false }
      if self.dstPath != rhs.dstPath { return false }
      if self.dstSubfolderSpec != rhs.dstSubfolderSpec { return false }
      if self.name != rhs.name { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXFileElement {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXFileElement else { return false }
      if self.sourceTree != rhs.sourceTree { return false }
      if self.path != rhs.path { return false }
      if self.name != rhs.name { return false }
      if self.includeInIndex != rhs.includeInIndex { return false }
      if self.usesTabs != rhs.usesTabs { return false }
      if self.indentWidth != rhs.indentWidth { return false }
      if self.tabWidth != rhs.tabWidth { return false }
      if self.wrapsLines != rhs.wrapsLines { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXFileReference {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXFileReference else { return false }
      if self.fileEncoding != rhs.fileEncoding { return false }
      if self.explicitFileType != rhs.explicitFileType { return false }
      if self.lastKnownFileType != rhs.lastKnownFileType { return false }
      if self.lineEnding != rhs.lineEnding { return false }
      if self.languageSpecificationIdentifier != rhs.languageSpecificationIdentifier { return false }
      if self.xcLanguageSpecificationIdentifier != rhs.xcLanguageSpecificationIdentifier { return false }
      if self.plistStructureDefinitionIdentifier != rhs.plistStructureDefinitionIdentifier { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXFrameworksBuildPhase {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXFrameworksBuildPhase else { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXGroup {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXGroup else { return false }
      if self.children != rhs.children { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXHeadersBuildPhase {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXHeadersBuildPhase else { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXLegacyTarget {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXLegacyTarget else { return false }
      if self.buildToolPath != rhs.buildToolPath { return false }
      if self.buildArgumentsString != rhs.buildArgumentsString { return false }
      if self.passBuildSettingsInEnvironment != rhs.passBuildSettingsInEnvironment { return false }
      if self.buildWorkingDirectory != rhs.buildWorkingDirectory { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXNativeTarget {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXNativeTarget else { return false }
      if self.productInstallPath != rhs.productInstallPath { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXProject {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXProject else { return false }
      if self.name != rhs.name { return false }
      if self.buildConfigurationList != rhs.buildConfigurationList { return false }
      if self.compatibilityVersion != rhs.compatibilityVersion { return false }
      if self.developmentRegion != rhs.developmentRegion { return false }
      if self.hasScannedForEncodings != rhs.hasScannedForEncodings { return false }
      if self.knownRegions != rhs.knownRegions { return false }
      if self.mainGroup != rhs.mainGroup { return false }
      if self.productRefGroup != rhs.productRefGroup { return false }
      if self.projectDirPath != rhs.projectDirPath { return false }
      if self.projectReferences != rhs.projectReferences { return false }
      if self.projectRoots != rhs.projectRoots { return false }
      if self.targets != rhs.targets { return false }
      if !NSDictionary(dictionary: self.attributes ).isEqual(to: rhs.attributes ) { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXReferenceProxy {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXReferenceProxy else { return false }
      if self.fileType != rhs.fileType { return false }
      if self.path != rhs.path { return false }
      if self.remoteRef != rhs.remoteRef { return false }
      if self.sourceTree != rhs.sourceTree { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXResourcesBuildPhase {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXResourcesBuildPhase else { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXRezBuildPhase {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXRezBuildPhase else { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXShellScriptBuildPhase {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXShellScriptBuildPhase else { return false }
      if self.name != rhs.name { return false }
      if self.inputPaths != rhs.inputPaths { return false }
      if self.outputPaths != rhs.outputPaths { return false }
      if self.shellPath != rhs.shellPath { return false }
      if self.shellScript != rhs.shellScript { return false }
      if self.showEnvVarsInLog != rhs.showEnvVarsInLog { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXSourcesBuildPhase {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXSourcesBuildPhase else { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXTarget {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXTarget else { return false }
      if self.buildConfigurationList != rhs.buildConfigurationList { return false }
      if self.buildPhases != rhs.buildPhases { return false }
      if self.buildRules != rhs.buildRules { return false }
      if self.dependencies != rhs.dependencies { return false }
      if self.name != rhs.name { return false }
      if self.productName != rhs.productName { return false }
      if self.productReference != rhs.productReference { return false }
      if self.productType != rhs.productType { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXTargetDependency {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXTargetDependency else { return false }
      if self.name != rhs.name { return false }
      if self.target != rhs.target { return false }
      if self.targetProxy != rhs.targetProxy { return false }
      return super.isEqual(to: rhs)
    }
}
extension PBXVariantGroup {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? PBXVariantGroup else { return false }
      return super.isEqual(to: rhs)
    }
}
extension XCBuildConfiguration {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? XCBuildConfiguration else { return false }
      if self.baseConfigurationReference != rhs.baseConfigurationReference { return false }
      if !NSDictionary(dictionary: self.buildSettings ).isEqual(to: rhs.buildSettings ) { return false }
      if self.name != rhs.name { return false }
      return super.isEqual(to: rhs)
    }
}
extension XCConfigurationList {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? XCConfigurationList else { return false }
      if self.buildConfigurations != rhs.buildConfigurations { return false }
      if self.defaultConfigurationIsVisible != rhs.defaultConfigurationIsVisible { return false }
      if self.defaultConfigurationName != rhs.defaultConfigurationName { return false }
      return super.isEqual(to: rhs)
    }
}
extension XCVersionGroup {
    /// :nodoc:
    @objc override public func isEqual(to object: Any?) -> Bool {
      guard let rhs = object as? XCVersionGroup else { return false }
      if self.currentVersion != rhs.currentVersion { return false }
      if self.versionGroupType != rhs.versionGroupType { return false }
      return super.isEqual(to: rhs)
    }
}
