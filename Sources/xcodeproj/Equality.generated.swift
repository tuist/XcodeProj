// Generated using Sourcery 0.13.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation

extension PBXAggregateTarget {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXAggregateTarget else { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXBuildFile {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXBuildFile else { return false }
        if fileRef != rhs.fileRef { return false }
        if !NSDictionary(dictionary: settings ?? [:]).isEqual(to: rhs.settings ?? [:]) { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXBuildPhase {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXBuildPhase else { return false }
        if buildActionMask != rhs.buildActionMask { return false }
        if files != rhs.files { return false }
        if runOnlyForDeploymentPostprocessing != rhs.runOnlyForDeploymentPostprocessing { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXBuildRule {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXBuildRule else { return false }
        if compilerSpec != rhs.compilerSpec { return false }
        if filePatterns != rhs.filePatterns { return false }
        if fileType != rhs.fileType { return false }
        if isEditable != rhs.isEditable { return false }
        if name != rhs.name { return false }
        if outputFiles != rhs.outputFiles { return false }
        if outputFilesCompilerFlags != rhs.outputFilesCompilerFlags { return false }
        if script != rhs.script { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXContainerItem {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXContainerItem else { return false }
        if comments != rhs.comments { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXContainerItemProxy {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXContainerItemProxy else { return false }
        if containerPortal != rhs.containerPortal { return false }
        if proxyType != rhs.proxyType { return false }
        if remoteGlobalIDString != rhs.remoteGlobalIDString { return false }
        if remoteInfo != rhs.remoteInfo { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXCopyFilesBuildPhase {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXCopyFilesBuildPhase else { return false }
        if dstPath != rhs.dstPath { return false }
        if dstSubfolderSpec != rhs.dstSubfolderSpec { return false }
        if name != rhs.name { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXFileElement {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXFileElement else { return false }
        if sourceTree != rhs.sourceTree { return false }
        if path != rhs.path { return false }
        if name != rhs.name { return false }
        if includeInIndex != rhs.includeInIndex { return false }
        if usesTabs != rhs.usesTabs { return false }
        if indentWidth != rhs.indentWidth { return false }
        if tabWidth != rhs.tabWidth { return false }
        if wrapsLines != rhs.wrapsLines { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXFileReference {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXFileReference else { return false }
        if fileEncoding != rhs.fileEncoding { return false }
        if explicitFileType != rhs.explicitFileType { return false }
        if lastKnownFileType != rhs.lastKnownFileType { return false }
        if lineEnding != rhs.lineEnding { return false }
        if languageSpecificationIdentifier != rhs.languageSpecificationIdentifier { return false }
        if xcLanguageSpecificationIdentifier != rhs.xcLanguageSpecificationIdentifier { return false }
        if plistStructureDefinitionIdentifier != rhs.plistStructureDefinitionIdentifier { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXFrameworksBuildPhase {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXFrameworksBuildPhase else { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXGroup {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXGroup else { return false }
        if children != rhs.children { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXHeadersBuildPhase {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXHeadersBuildPhase else { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXLegacyTarget {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXLegacyTarget else { return false }
        if buildToolPath != rhs.buildToolPath { return false }
        if buildArgumentsString != rhs.buildArgumentsString { return false }
        if passBuildSettingsInEnvironment != rhs.passBuildSettingsInEnvironment { return false }
        if buildWorkingDirectory != rhs.buildWorkingDirectory { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXNativeTarget {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXNativeTarget else { return false }
        if productInstallPath != rhs.productInstallPath { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXProject {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXProject else { return false }
        if name != rhs.name { return false }
        if buildConfigurationList != rhs.buildConfigurationList { return false }
        if compatibilityVersion != rhs.compatibilityVersion { return false }
        if developmentRegion != rhs.developmentRegion { return false }
        if hasScannedForEncodings != rhs.hasScannedForEncodings { return false }
        if knownRegions != rhs.knownRegions { return false }
        if mainGroup != rhs.mainGroup { return false }
        if productRefGroup != rhs.productRefGroup { return false }
        if projectDirPath != rhs.projectDirPath { return false }
        if projectReferences != rhs.projectReferences { return false }
        if projectRoots != rhs.projectRoots { return false }
        if targets != rhs.targets { return false }
        if !NSDictionary(dictionary: attributes).isEqual(to: rhs.attributes) { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXReferenceProxy {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXReferenceProxy else { return false }
        if fileType != rhs.fileType { return false }
        if path != rhs.path { return false }
        if remoteRef != rhs.remoteRef { return false }
        if sourceTree != rhs.sourceTree { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXResourcesBuildPhase {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXResourcesBuildPhase else { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXRezBuildPhase {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXRezBuildPhase else { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXShellScriptBuildPhase {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXShellScriptBuildPhase else { return false }
        if name != rhs.name { return false }
        if inputPaths != rhs.inputPaths { return false }
        if outputPaths != rhs.outputPaths { return false }
        if shellPath != rhs.shellPath { return false }
        if shellScript != rhs.shellScript { return false }
        if showEnvVarsInLog != rhs.showEnvVarsInLog { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXSourcesBuildPhase {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXSourcesBuildPhase else { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXTarget {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXTarget else { return false }
        if buildConfigurationList != rhs.buildConfigurationList { return false }
        if buildPhases != rhs.buildPhases { return false }
        if buildRules != rhs.buildRules { return false }
        if dependencies != rhs.dependencies { return false }
        if name != rhs.name { return false }
        if productName != rhs.productName { return false }
        if productReference != rhs.productReference { return false }
        if productType != rhs.productType { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXTargetDependency {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXTargetDependency else { return false }
        if name != rhs.name { return false }
        if target != rhs.target { return false }
        if targetProxy != rhs.targetProxy { return false }
        return super.isEqual(to: rhs)
    }
}

extension PBXVariantGroup {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? PBXVariantGroup else { return false }
        return super.isEqual(to: rhs)
    }
}

extension XCBuildConfiguration {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? XCBuildConfiguration else { return false }
        if baseConfigurationReference != rhs.baseConfigurationReference { return false }
        if !NSDictionary(dictionary: buildSettings).isEqual(to: rhs.buildSettings) { return false }
        if name != rhs.name { return false }
        return super.isEqual(to: rhs)
    }
}

extension XCConfigurationList {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? XCConfigurationList else { return false }
        if buildConfigurations != rhs.buildConfigurations { return false }
        if defaultConfigurationIsVisible != rhs.defaultConfigurationIsVisible { return false }
        if defaultConfigurationName != rhs.defaultConfigurationName { return false }
        return super.isEqual(to: rhs)
    }
}

extension XCVersionGroup {
    /// :nodoc:
    @objc public override func isEqual(to object: Any?) -> Bool {
        guard let rhs = object as? XCVersionGroup else { return false }
        if currentVersion != rhs.currentVersion { return false }
        if versionGroupType != rhs.versionGroupType { return false }
        return super.isEqual(to: rhs)
    }
}
