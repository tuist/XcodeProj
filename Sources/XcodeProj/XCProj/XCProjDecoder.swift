import Foundation
import XcodeProjectFormat

/// Builds a `PBXProj` object graph out of an `XCSchema.Project` decoded from a `project.xcproj`.
///
/// The two models hold the same information but arrange it differently. `project.xcproj` is a tree
/// whose files declare which build phases they belong to, while `PBXProj` is a flat table of objects
/// that refer to each other by identifier, with a separate `PBXBuildFile` for every membership. The
/// decoder walks the tree once, records every membership it passes, and resolves them into build
/// files after the targets exist.
final class XCProjDecoder {
    /// The default `objectVersion` given to a project decoded from a `project.xcproj`.
    ///
    /// The JSON format carries no archive or object version, so one has to be chosen. 77 is the
    /// version Xcode 16 and later write, and a `project.xcproj` always comes from a newer Xcode.
    static let defaultObjectVersion: UInt = 77

    private let schema: XCSchema.Project
    private let projectName: String

    /// Every object created so far, in creation order, ready to be handed to `PBXProj`.
    private var objects: [PBXObject] = []

    /// File elements that carry an explicit identifier, keyed by that identifier.
    private var elementsByID: [String: PBXFileElement] = [:]

    /// The root of name path resolution, set once the main group exists.
    private var rootGroup: PBXGroup?

    /// The children of each element, in tree order, used for name path resolution.
    private var childrenByElement: [ObjectIdentifier: [(name: String, element: PBXFileElement)]] = [:]

    /// The parent of each element, used to resolve `..` components. `PBXFileElement.parent` is only
    /// filled in once the whole graph is handed to `PBXProj`, which is after resolution runs.
    private var parentByElement: [ObjectIdentifier: PBXFileElement] = [:]

    /// Version groups whose current version still needs resolving against the finished tree.
    private var pendingCurrentVersions: [(group: XCVersionGroup, reference: XCSchema.GroupTreeReference)] = []

    /// A file membership recorded while walking the tree, resolved once the targets exist.
    private struct PendingBuildFile {
        var element: PBXFileElement
        var buildFile: XCSchema.ProjectBuildFile
    }

    private var pendingBuildFiles: [PendingBuildFile] = []

    /// Folders keyed by the targets they belong to, resolved once the targets exist.
    private var pendingFolderTargets: [(folder: PBXFileSystemSynchronizedRootGroup, targets: [String])] = []

    /// Folder exception sets, resolved once the targets and their build phases exist.
    private var pendingFolderExceptions: [(folder: PBXFileSystemSynchronizedRootGroup, exceptions: [XCSchema.FolderExceptionSet])] = []

    /// Build configurations that still need their `baseConfiguration` resolved against the tree.
    private var pendingConfigurationFiles: [(configuration: XCBuildConfiguration, file: XCSchema.GroupTreeAnchoredReference)] = []

    /// Target dependencies and package memberships, resolved once the targets exist.
    private var pendingTargetDependencies: [(target: PBXTarget, dependencies: [XCSchema.TargetDependency])] = []
    private var pendingPackageMembers: [(target: PBXTarget, members: [XCSchema.SwiftPackageProductTargetMember])] = []

    private var targetsByName: [String: PBXTarget] = [:]

    /// The package products each target uses, gathered from its dependencies and its build files.
    /// Xcode lists them on the target as well, so they are collected and assigned in one place.
    private var packageProductsByTarget: [PBXTarget: [XCSwiftPackageProductDependency]] = [:]

    /// The build files of each phase, appended as they are resolved and assigned in one go.
    ///
    /// `PBXBuildPhase.files` rebuilds its array from weak references on every access, so appending
    /// one file at a time would be quadratic in the number of files in the phase.
    private var buildFilesByPhase: [PBXObjectReference: [PBXBuildFile]] = [:]

    /// Build phases keyed by their explicit identifier.
    private var phasesByID: [String: PBXBuildPhase] = [:]

    /// Build phases keyed by target name, kind and optional name. A key with more than one phase is
    /// ambiguous and can only be referred to by identifier.
    private struct PhaseKey: Hashable {
        var targetName: String
        var kind: XCSchema.BuildPhase.Kind
        var name: String?
    }

    private var phasesByKey: [PhaseKey: [PBXBuildPhase]] = [:]

    /// Swift package references keyed by the name the schema uses for them.
    private var packagesByName: [String: XCRemoteSwiftPackageReference] = [:]

    init(schema: XCSchema.Project, projectName: String) {
        self.schema = schema
        self.projectName = projectName
    }

    /// The object graph a `project.xcproj` decodes into.
    struct Decoded {
        var rootObject: PBXProject
        var objects: [PBXObject]
    }

    // MARK: - Entry point

    func decode() throws -> Decoded {
        let configurationNames = schema.configurations.map(\.name.name)
        let projectConfigurationList = try makeConfigurationList(
            configurations: schema.configurations,
            settings: schema.buildSettings,
            configurationNames: configurationNames
        )
        if let id = schema.configurationListDebugID { projectConfigurationList.reference.fix(id.rawValue) }

        let rootGroup = try makeRootGroup()
        let packages = try makePackages()
        let targets = try makeTargets(configurationNames: configurationNames)

        let projectReferences = try makeProjectReferences(makeImportedProducts())
        let productsGroup = try resolveProductsGroup()

        let project = PBXProject(
            name: projectName,
            buildConfigurationList: projectConfigurationList,
            compatibilityVersion: nil,
            preferredProjectObjectVersion: nil,
            minimizedProjectReferenceProxies: nil,
            mainGroup: rootGroup,
            developmentRegion: schema.localizationInfo.development.languageID,
            knownRegions: knownRegions(),
            productsGroup: productsGroup,
            projects: projectReferences,
            targets: targets,
            attributes: projectAttributes()
        )
        add(project)
        if let id = schema.objectID { project.reference.fix(id.rawValue) }
        project.targetAttributes = try targetAttributes()
        project.packageReferences = packages.map(\.reference)

        // Everything that points at another object is resolved now that every object exists.
        try resolveCurrentVersions()
        try resolveConfigurationFiles()
        try resolveTargetDependencies(project: project)
        try resolvePackageMembers()
        try resolveFolderMemberships()
        try resolveBuildFiles()

        return Decoded(rootObject: project, objects: objects)
    }

    /// Builds the main group and walks the whole groups and files tree into it.
    private func makeRootGroup() throws -> PBXGroup {
        let rootGroup = PBXGroup(sourceTree: .group)
        add(rootGroup)
        if let id = schema.rootGroupDebugID { rootGroup.reference.fix(id.rawValue) }

        var children: [PBXFileElement] = []
        var named: [(name: String, element: PBXFileElement)] = []
        for reference in schema.topLevelReferences {
            let element = try makeFileElement(reference)
            children.append(element)
            named.append((name: Self.name(of: reference), element: element))
        }
        rootGroup.children = children
        register(children: named, of: rootGroup)
        self.rootGroup = rootGroup
        return rootGroup
    }

    /// Builds one project reference per referenced `.xcodeproj`, each with the products group that
    /// holds the proxies for the products imported from it.
    private func makeProjectReferences(
        _ importedProductsByProject: [String: ImportedProducts]
    ) -> [[String: PBXFileElement]] {
        var projectReferences: [[String: PBXFileElement]] = []
        for (_, imported) in importedProductsByProject.sorted(by: { $0.key < $1.key }) {
            let productsGroup = PBXGroup(children: imported.products, sourceTree: .group, name: "Products")
            add(productsGroup)
            projectReferences.append([
                Xcode.ProjectReference.projectReferenceKey: imported.projectFile,
                Xcode.ProjectReference.productGroupKey: productsGroup,
            ])
        }
        return projectReferences
    }

    private func resolveProductsGroup() throws -> PBXGroup? {
        guard let reference = schema.productsGroup else { return nil }
        // The schema always supplies a products group, defaulting to a group named "Products", so a
        // project without one is expected rather than an error.
        guard let element = try lookUpElement(reference) else { return nil }
        guard let group = element as? PBXGroup else {
            throw XCProjError.unsupportedFileElement("The products group '\(reference.description)'")
        }
        return group
    }
}

extension XCProjDecoder {
    // MARK: - Object bookkeeping

    private func add(_ object: PBXObject) {
        objects.append(object)
    }
}

extension XCProjDecoder {
    // MARK: - Project level values

    private func knownRegions() -> [String] {
        let development = schema.localizationInfo.development
        return schema.localizationInfo.supported.union([development]).map(\.languageID).sorted()
    }

    private func projectAttributes() -> [String: ProjectAttribute] {
        var attributes: [String: ProjectAttribute] = [:]
        if let organizationName = schema.organizationName {
            attributes["ORGANIZATIONNAME"] = .string(organizationName)
        }
        if let classPrefix = schema.classPrefix {
            attributes["CLASSPREFIX"] = .string(classPrefix)
        }
        if let lastUpgradeCheck = schema.lastUpgradeCheck {
            attributes["LastUpgradeCheck"] = .string(lastUpgradeCheck.projectAttributeValue)
        }
        if let lastSwiftUpdateCheck = schema.lastSwiftUpdateCheck {
            attributes["LastSwiftUpdateCheck"] = .string(lastSwiftUpdateCheck.projectAttributeValue)
        }
        if let lastSwiftMigration = schema.lastSwiftMigration {
            attributes["LastSwiftMigration"] = .string(lastSwiftMigration.projectAttributeValue)
        }
        // Xcode only writes this attribute when the project opts out of the default.
        if !schema.buildIndependentTargetsInParallel {
            attributes["BuildIndependentTargetsInParallel"] = .string("NO")
        }
        return attributes
    }

    private func targetAttributes() throws -> [PBXTarget: [String: ProjectAttribute]] {
        var result: [PBXTarget: [String: ProjectAttribute]] = [:]
        for schemaTarget in schema.targets {
            guard let target = targetsByName[schemaTarget.name] else { continue }
            let properties = schemaTarget.commonProperties
            var attributes: [String: ProjectAttribute] = [:]
            if let style = properties.legacyProvisioningStyle {
                attributes["ProvisioningStyle"] = .string(style == .automatic ? "Automatic" : "Manual")
            }
            if let teamID = properties.legacyTeamID {
                attributes["DevelopmentTeam"] = .string(teamID)
            }
            if let version = properties.lastSwiftMigration {
                attributes["LastSwiftMigration"] = .string(version.projectAttributeValue)
            }
            if let testHost = properties.testHostTarget {
                guard let hostTarget = targetsByName[testHost.targetName] else {
                    throw XCProjError.unresolvedTarget(testHost.targetName)
                }
                attributes["TestTargetID"] = .targetReference(hostTarget)
            }
            if !attributes.isEmpty {
                result[target] = attributes
            }
        }
        return result
    }
}

extension XCProjDecoder {
    // MARK: - Configurations

    private func makeConfigurationList(
        configurations: [XCSchema.Configuration],
        settings: [String: XCSchema.BuildSetting],
        configurationNames: [String]
    ) throws -> XCConfigurationList {
        let settingsByConfiguration = BuildSettingsMapping.split(settings, configurationNames: configurationNames)
        var buildConfigurations: [XCBuildConfiguration] = []
        for configuration in configurations {
            let name = configuration.name.name
            let buildConfiguration = XCBuildConfiguration(
                name: name,
                buildSettings: settingsByConfiguration[name] ?? [:]
            )
            add(buildConfiguration)
            if let id = configuration.objectID { buildConfiguration.reference.fix(id.rawValue) }
            if let file = configuration.file {
                pendingConfigurationFiles.append((configuration: buildConfiguration, file: file))
            }
            buildConfigurations.append(buildConfiguration)
        }
        let list = XCConfigurationList(
            buildConfigurations: buildConfigurations,
            defaultConfigurationName: schema.defaultConfigurationName.name
        )
        add(list)
        return list
    }

    private func resolveCurrentVersions() throws {
        for pending in pendingCurrentVersions {
            guard let file = try resolveElement(pending.reference) as? PBXFileReference else {
                throw XCProjError.unresolvedReference(pending.reference.description)
            }
            pending.group.currentVersion = file
        }
    }

    private func resolveConfigurationFiles() throws {
        for pending in pendingConfigurationFiles {
            let element = try resolveElement(pending.file.anchor)
            switch element {
            case let fileReference as PBXFileReference:
                guard pending.file.relativePath == nil else {
                    throw XCProjError.unresolvedReference(pending.file.description)
                }
                pending.configuration.baseConfiguration = fileReference
            case let folder as PBXFileSystemSynchronizedRootGroup:
                guard let relativePath = pending.file.relativePath?.description else {
                    throw XCProjError.unresolvedReference(pending.file.description)
                }
                pending.configuration.baseConfigurationAnchor = folder
                pending.configuration.baseConfigurationReferenceRelativePath = relativePath
            default:
                throw XCProjError.unresolvedReference(pending.file.description)
            }
        }
    }
}

extension XCProjDecoder {
    // MARK: - Groups and files tree

    /// The name a reference is known by inside the groups and files tree.
    static func name(of reference: XCSchema.Reference) -> String {
        switch reference {
        case let .fileReference(content): content.path.lastPathComponent
        case let .group(content): content.name
        case let .folder(content): content.path.lastPathComponent
        case let .variantGroup(content): content.name
        case let .versionGroup(content): content.name
        }
    }

    private func makeFileElement(_ reference: XCSchema.Reference) throws -> PBXFileElement {
        switch reference {
        case let .fileReference(content): try makeFileReference(content)
        case let .group(content): try makeGroup(content)
        case let .folder(content): try makeFolder(content)
        case let .variantGroup(content): try makeVariantGroup(content)
        case let .versionGroup(content): try makeVersionGroup(content)
        }
    }

    private func register(_ element: PBXFileElement, objectID: XCSchema.ObjectID?) {
        add(element)
        guard let objectID else { return }
        element.reference.fix(objectID.rawValue)
        elementsByID[objectID.rawValue] = element
    }

    private func makeFileReference(_ content: XCSchema.FileReference) throws -> PBXFileReference {
        let element = try PBXFileReference(
            sourceTree: content.path.pbxSourceTree,
            fileEncoding: content.textEncoding?.fileEncoding,
            explicitFileType: content.explicitFileType?.fileTypeID,
            path: content.path.pbxPath,
            includeInIndex: content.commonProperties.includeInIndex,
            lineEnding: content.lineEnding?.fileReferenceValue(),
            expectedSignature: content.expectedSignature
        )
        register(element, objectID: content.objectID)
        enqueue(buildFiles: content.buildFiles, for: element)
        return element
    }

    private func makeGroup(_ content: XCSchema.Group) throws -> PBXGroup {
        let element = PBXGroup(
            sourceTree: content.path.pbxSourceTree,
            // Xcode omits the name when it equals the last path component, and the schema does the
            // same, so only carry a name over when it actually differs.
            name: content.name == content.path.lastPathComponent ? nil : content.name,
            path: content.path.pbxPath,
            includeInIndex: content.commonProperties.includeInIndex
        )
        register(element, objectID: content.objectID)

        var children: [PBXFileElement] = []
        var named: [(name: String, element: PBXFileElement)] = []
        for child in content.children {
            let childElement = try makeFileElement(child)
            children.append(childElement)
            named.append((name: Self.name(of: child), element: childElement))
        }
        element.children = children
        register(children: named, of: element)
        return element
    }

    private func makeVariantGroup(_ content: XCSchema.VariantGroup) throws -> PBXVariantGroup {
        let element = PBXVariantGroup(
            sourceTree: content.path.pbxSourceTree,
            name: content.name,
            path: content.path.pbxPath,
            includeInIndex: content.commonProperties.includeInIndex
        )
        register(element, objectID: content.objectID)
        enqueue(buildFiles: content.buildFiles, for: element)

        var children: [PBXFileElement] = []
        var named: [(name: String, element: PBXFileElement)] = []
        for child in content.children {
            let childElement = try makeFileReference(child)
            children.append(childElement)
            named.append((name: child.path.lastPathComponent, element: childElement))
        }
        element.children = children
        register(children: named, of: element)
        return element
    }

    private func makeVersionGroup(_ content: XCSchema.VersionGroup) throws -> XCVersionGroup {
        let element = XCVersionGroup(
            path: content.path.pbxPath,
            name: content.name,
            sourceTree: content.path.pbxSourceTree,
            versionGroupType: content.versionedFileType?.fileTypeID,
            includeInIndex: content.commonProperties.includeInIndex
        )
        register(element, objectID: content.objectID)
        enqueue(buildFiles: content.buildFiles, for: element)

        var children: [PBXFileElement] = []
        var named: [(name: String, element: PBXFileElement)] = []
        for child in content.children {
            let childElement = try makeFileReference(child)
            children.append(childElement)
            named.append((name: child.path.lastPathComponent, element: childElement))
        }
        element.children = children
        register(children: named, of: element)

        if let currentVersion = content.currentVersion {
            // The reference is relative to the project, so it can only be resolved once the whole
            // tree has been walked.
            pendingCurrentVersions.append((group: element, reference: currentVersion))
        }
        return element
    }

    private func makeFolder(_ content: XCSchema.Folder) throws -> PBXFileSystemSynchronizedRootGroup {
        var explicitFileTypes: [String: String] = [:]
        for (member, fileType) in content.explicitFileTypes {
            explicitFileTypes[member.value] = fileType.fileTypeID
        }
        let element = PBXFileSystemSynchronizedRootGroup(
            sourceTree: content.path.pbxSourceTree,
            path: content.path.pbxPath,
            includeInIndex: content.commonProperties.includeInIndex,
            explicitFileTypes: explicitFileTypes,
            explicitFolders: content.explicitOpaqueFolders.map(\.value).sorted()
        )
        register(element, objectID: content.objectID)
        pendingFolderTargets.append((folder: element, targets: content.targets.map(\.targetName).sorted()))
        if !content.membershipExceptions.isEmpty {
            pendingFolderExceptions.append((folder: element, exceptions: content.membershipExceptions))
        }
        return element
    }

    private func register(children: [(name: String, element: PBXFileElement)], of parent: PBXFileElement) {
        childrenByElement[ObjectIdentifier(parent)] = children
        for child in children {
            parentByElement[ObjectIdentifier(child.element)] = parent
        }
    }

    private func enqueue(buildFiles: [XCSchema.ProjectBuildFile], for element: PBXFileElement) {
        for buildFile in buildFiles {
            pendingBuildFiles.append(PendingBuildFile(element: element, buildFile: buildFile))
        }
    }
}

extension XCProjDecoder {
    // MARK: - Name path resolution

    /// Resolves a reference, treating a name that matches nothing as an error.
    private func resolveElement(_ reference: XCSchema.GroupTreeReference) throws -> PBXFileElement {
        guard let element = try lookUpElement(reference) else {
            throw XCProjError.unresolvedReference(reference.description)
        }
        return element
    }

    /// Resolves a reference, returning `nil` when a name simply matches nothing.
    ///
    /// An ambiguous name, or an identifier that names no object, is a broken file rather than an
    /// absent one, so those still raise an error.
    private func lookUpElement(_ reference: XCSchema.GroupTreeReference) throws -> PBXFileElement? {
        switch reference {
        case let .objectID(objectID):
            guard let element = elementsByID[objectID.rawValue] else {
                throw XCProjError.unresolvedReference(reference.description)
            }
            return element
        case let .namePath(namePath):
            return try lookUp(namePath: namePath, description: reference.description)
        }
    }

    private func lookUp(
        namePath: XCSchema.NamePath,
        description: String
    ) throws -> PBXFileElement? {
        guard let rootGroup else { return nil }
        var level = childrenByElement[ObjectIdentifier(rootGroup)] ?? []
        var current: PBXFileElement?

        for component in namePath.components {
            switch component {
            case .relative(.current):
                continue
            case .relative(.parent):
                // The tree is walked downwards from a known root, so a parent step is only
                // meaningful after descending at least once.
                guard let element = current, let parent = parentByElement[ObjectIdentifier(element)] else {
                    return nil
                }
                current = parent
                level = childrenByElement[ObjectIdentifier(parent)] ?? []
            case let .child(name):
                var match: PBXFileElement?
                for candidate in level where candidate.name == name {
                    guard match == nil else {
                        throw XCProjError.ambiguousReference(description)
                    }
                    match = candidate.element
                }
                guard let match else { return nil }
                current = match
                level = childrenByElement[ObjectIdentifier(match)] ?? []
            }
        }
        return current
    }
}

extension XCProjDecoder {
    // MARK: - Swift packages

    private func makePackages() throws -> [PBXObject] {
        var references: [PBXObject] = []
        for package in schema.packages {
            switch package.location {
            case let .local(local):
                let reference = XCLocalSwiftPackageReference(
                    relativePath: local.path,
                    traits: package.traits.isEmpty ? nil : package.traits
                )
                add(reference)
                references.append(reference)
            case let .remote(remote):
                let reference = XCRemoteSwiftPackageReference(
                    repositoryURL: remote.repositoryURL,
                    versionRequirement: remote.versionConstraint?.versionRequirement,
                    traits: package.traits.isEmpty ? nil : package.traits
                )
                add(reference)
                references.append(reference)
                packagesByName[reference.name ?? ""] = reference
            }
        }
        return references
    }
}

extension XCProjDecoder {
    // MARK: - Targets

    private func makeTargets(configurationNames: [String]) throws -> [PBXTarget] {
        var targets: [PBXTarget] = []
        for schemaTarget in schema.targets {
            let target = try makeTarget(schemaTarget, configurationNames: configurationNames)
            targets.append(target)
            targetsByName[schemaTarget.name] = target
        }
        // Products and dependencies refer to other targets, so they are resolved once every target
        // exists.
        for schemaTarget in schema.targets {
            guard let target = targetsByName[schemaTarget.name] else { continue }
            let properties = schemaTarget.commonProperties
            if let product = properties.product {
                guard let productFile = try resolveElement(product) as? PBXFileReference else {
                    throw XCProjError.unresolvedReference(product.description)
                }
                target.product = productFile
            }
            if !properties.dependencies.isEmpty {
                pendingTargetDependencies.append((target: target, dependencies: properties.dependencies))
            }
            if !properties.packageProductTargetMembers.isEmpty {
                pendingPackageMembers.append((target: target, members: properties.packageProductTargetMembers))
            }
        }
        return targets
    }

    private func makeTarget(_ schemaTarget: XCSchema.Target, configurationNames: [String]) throws -> PBXTarget {
        let properties = schemaTarget.commonProperties
        let configurationList = try makeConfigurationList(
            configurations: targetConfigurations(properties, configurationNames: configurationNames),
            settings: properties.buildSettings,
            configurationNames: configurationNames
        )
        if let id = properties.configurationListDebugID { configurationList.reference.fix(id.rawValue) }

        let buildPhases = try properties.buildPhases.map(makeBuildPhase)
        let buildRules = properties.buildRules.map(makeBuildRule)

        let target: PBXTarget = switch schemaTarget {
        case .native:
            PBXNativeTarget(
                name: properties.name,
                buildConfigurationList: configurationList,
                buildPhases: buildPhases,
                buildRules: buildRules,
                productType: properties.productTypeID?.pbxProductType
            )
        case .aggregate:
            PBXAggregateTarget(
                name: properties.name,
                buildConfigurationList: configurationList,
                buildPhases: buildPhases,
                buildRules: buildRules,
                productType: properties.productTypeID?.pbxProductType
            )
        case let .externalBuildSystem(external):
            PBXLegacyTarget(
                name: properties.name,
                buildToolPath: external.buildToolPath,
                buildArgumentsString: external.buildToolArguments.isEmpty ? nil : external.buildToolArguments,
                passBuildSettingsInEnvironment: external.passBuildSettingsInEnvironment,
                buildWorkingDirectory: external.buildToolWorkingDirectory,
                buildConfigurationList: configurationList,
                buildPhases: buildPhases,
                buildRules: buildRules,
                productType: properties.productTypeID?.pbxProductType
            )
        }
        add(target)
        target.reference.fix(properties.objectID.rawValue)

        for phase in buildPhases {
            add(phase)
        }
        for rule in buildRules {
            add(rule)
        }
        indexBuildPhases(buildPhases, schemaPhases: properties.buildPhases, targetName: properties.name)
        return target
    }

    /// The configurations of a target, one per project configuration, carrying the target's
    /// specializations where it has any.
    private func targetConfigurations(
        _ properties: XCSchema.CommonTargetProperties,
        configurationNames: [String]
    ) -> [XCSchema.Configuration] {
        var specialized: [String: XCSchema.Configuration] = [:]
        for configuration in properties.specializedConfigurations {
            specialized[configuration.name.name] = configuration
        }
        return configurationNames.map { name in
            specialized[name] ?? XCSchema.Configuration(name: XCSchema.ConfigurationName(name: name), file: nil, objectID: nil)
        }
    }

    private func indexBuildPhases(
        _ phases: [PBXBuildPhase],
        schemaPhases: [XCSchema.BuildPhase],
        targetName: String
    ) {
        for (phase, schemaPhase) in zip(phases, schemaPhases) {
            let key = PhaseKey(targetName: targetName, kind: schemaPhase.kind, name: schemaPhase.schemaName)
            phasesByKey[key, default: []].append(phase)
            if let id = schemaPhase.objectID {
                phase.reference.fix(id.rawValue)
                phasesByID[id.rawValue] = phase
            }
        }
    }
}

extension XCProjDecoder {
    // MARK: - Build phases

    private func makeBuildPhase(_ phase: XCSchema.BuildPhase) throws -> PBXBuildPhase {
        switch phase {
        case .sources:
            return PBXSourcesBuildPhase()
        case .frameworks:
            return PBXFrameworksBuildPhase()
        case .headers:
            return PBXHeadersBuildPhase()
        case .resources:
            return PBXResourcesBuildPhase()
        case .rez:
            return PBXRezBuildPhase()
        case let .copy(properties):
            return try PBXCopyFilesBuildPhase(
                dstPath: properties.relativePath,
                dstSubfolderSpec: CopyFilesDestinationMapping.subFolder(for: properties.bundleBasePath),
                name: properties.baseProperties.name,
                runOnlyForDeploymentPostprocessing: properties.scope == .install
            )
        case let .script(properties):
            return PBXShellScriptBuildPhase(
                name: properties.baseProperties.name,
                inputPaths: properties.inputPaths,
                outputPaths: properties.outputPaths,
                inputFileListPaths: properties.inputFileListPaths.isEmpty ? nil : properties.inputFileListPaths,
                outputFileListPaths: properties.outputFileListPaths.isEmpty ? nil : properties.outputFileListPaths,
                shellPath: properties.shellPath,
                shellScript: properties.script,
                runOnlyForDeploymentPostprocessing: properties.scope == .install,
                showEnvVarsInLog: properties.logEnvironmentVariables,
                alwaysOutOfDate: properties.runOnEveryBuild,
                dependencyFile: properties.dependencyFile
            )
        case .appleScript, .javaArchive:
            throw XCProjError.unsupportedBuildPhase(kind: phase.kind.rawValue)
        }
    }

    private func makeBuildRule(_ rule: XCSchema.BuildRule) -> PBXBuildRule {
        let pbxRule = PBXBuildRule(
            compilerSpec: rule.processor,
            fileType: rule.fileType?.fileTypeID ?? "",
            filePatterns: rule.filePatterns,
            name: rule.name,
            dependencyFile: rule.dependencyFile,
            outputFiles: rule.outputFiles,
            inputFiles: rule.inputFiles.isEmpty ? nil : rule.inputFiles,
            outputFilesCompilerFlags: rule.outputFilesCompilerFlags.isEmpty ? nil : rule.outputFilesCompilerFlags,
            script: rule.script,
            runOncePerArchitecture: rule.runOncePerArchitecture
        )
        if let id = rule.objectID { pbxRule.reference.fix(id.rawValue) }
        return pbxRule
    }
}

extension XCProjDecoder {
    // MARK: - Build files

    private func resolveBuildFiles() throws {
        for pending in pendingBuildFiles {
            let phase = try resolvePhase(pending.buildFile.buildPhase)
            let buildFile = try PBXBuildFile(
                file: pending.element,
                settings: pending.buildFile.properties.buildFileSettings(),
                platformFilters: pending.buildFile.properties.buildFilePlatformFilters
            )
            add(buildFile)
            if let id = pending.buildFile.objectID { buildFile.reference.fix(id.rawValue) }
            append(buildFile, to: phase)
        }
        for (phaseReference, buildFiles) in buildFilesByPhase {
            guard let phase: PBXBuildPhase = phaseReference.getObject() else { continue }
            phase.files = buildFiles
        }
    }

    /// Records a build file for a phase. The phase is filled in once every file is known, because
    /// assigning `files` one element at a time is quadratic.
    private func append(_ buildFile: PBXBuildFile, to phase: PBXBuildPhase) {
        buildFilesByPhase[phase.reference, default: []].append(buildFile)
    }

    private func resolvePhase(_ reference: XCSchema.ProjectBuildPhaseReference) throws -> PBXBuildPhase {
        switch reference {
        case let .objectID(objectID):
            guard let phase = phasesByID[objectID.rawValue] else {
                throw XCProjError.unresolvedBuildPhase(reference.description)
            }
            return phase
        case let .named(target, kind, name):
            let key = PhaseKey(targetName: target.targetName, kind: kind, name: name)
            let matches = phasesByKey[key] ?? []
            guard let match = matches.first else {
                throw XCProjError.unresolvedBuildPhase(reference.description)
            }
            guard matches.count == 1 else {
                throw XCProjError.ambiguousBuildPhase(reference.description)
            }
            return match
        }
    }
}

extension XCProjDecoder {
    // MARK: - Target dependencies

    private func resolveTargetDependencies(project: PBXProject) throws {
        for pending in pendingTargetDependencies {
            var dependencies: [PBXTargetDependency] = []
            for dependency in pending.dependencies {
                try dependencies.append(makeTargetDependency(dependency, project: project, target: pending.target))
            }
            pending.target.dependencies = dependencies
        }
    }

    private func makeTargetDependency(
        _ dependency: XCSchema.TargetDependency,
        project: PBXProject,
        target owner: PBXTarget
    ) throws -> PBXTargetDependency {
        let pbxDependency: PBXTargetDependency
        let filters: Set<XCSchema.PlatformFilter>

        switch dependency {
        case let .localTarget(reference, platformFilters):
            guard let target = targetsByName[reference.targetName] else {
                throw XCProjError.unresolvedTarget(reference.targetName)
            }
            let proxy = PBXContainerItemProxy(
                containerPortal: .project(project),
                remoteGlobalID: .object(target),
                proxyType: .nativeTarget,
                remoteInfo: target.name
            )
            add(proxy)
            pbxDependency = PBXTargetDependency(name: target.name, target: target, targetProxy: proxy)
            filters = platformFilters

        case let .remoteTarget(remote, platformFilters):
            guard let projectFile = try resolveElement(remote.project) as? PBXFileReference else {
                throw XCProjError.unresolvedReference(remote.project.description)
            }
            let proxy = PBXContainerItemProxy(
                containerPortal: .fileReference(projectFile),
                remoteGlobalID: .string(remote.targetID.rawValue),
                proxyType: .nativeTarget,
                remoteInfo: remote.target
            )
            add(proxy)
            pbxDependency = PBXTargetDependency(name: remote.target, targetProxy: proxy)
            filters = platformFilters

        case let .package(product, platformFilters):
            let productDependency = try makePackageProductDependency(product)
            packageProductsByTarget[owner, default: []].append(productDependency)
            pbxDependency = PBXTargetDependency(product: productDependency)
            filters = platformFilters
        }

        add(pbxDependency)
        if !filters.isEmpty {
            pbxDependency.platformFilters = filters.map(\.platformID).sorted()
        }
        return pbxDependency
    }

    private func makePackageProductDependency(
        _ reference: XCSchema.SwiftPackageProductReference
    ) throws -> XCSwiftPackageProductDependency {
        let package: XCRemoteSwiftPackageReference? = try {
            guard let name = reference.package?.packageName else { return nil }
            guard let package = packagesByName[name] else {
                throw XCProjError.unresolvedPackage(name)
            }
            return package
        }()
        let dependency = XCSwiftPackageProductDependency(
            productName: reference.productName,
            package: package,
            isPlugin: reference.productType == .buildToolPlugin
        )
        add(dependency)
        if let id = reference.objectID { dependency.reference.fix(id.rawValue) }
        return dependency
    }

    private func resolvePackageMembers() throws {
        for pending in pendingPackageMembers {
            for member in pending.members {
                let productDependency = try makePackageProductDependency(member.packageProduct)
                packageProductsByTarget[pending.target, default: []].append(productDependency)

                let phaseReference = XCSchema.ProjectBuildPhaseReference(
                    targetName: pending.target.name,
                    buildPhase: member.buildFile.buildPhase
                )
                let phase = try resolvePhase(phaseReference)
                let buildFile = try PBXBuildFile(
                    product: productDependency,
                    settings: member.buildFile.properties.buildFileSettings(),
                    platformFilters: member.buildFile.properties.buildFilePlatformFilters
                )
                add(buildFile)
                if let id = member.buildFile.objectID { buildFile.reference.fix(id.rawValue) }
                append(buildFile, to: phase)
            }
        }
        for (target, products) in packageProductsByTarget {
            target.packageProductDependencies = products
        }
    }
}

extension XCProjDecoder {
    // MARK: - Folders

    private func resolveFolderMemberships() throws {
        var groupsByTarget: [String: [PBXFileSystemSynchronizedRootGroup]] = [:]
        for pending in pendingFolderTargets {
            for targetName in pending.targets {
                guard targetsByName[targetName] != nil else {
                    throw XCProjError.unresolvedTarget(targetName)
                }
                groupsByTarget[targetName, default: []].append(pending.folder)
            }
        }
        for (targetName, folders) in groupsByTarget {
            targetsByName[targetName]?.fileSystemSynchronizedGroups = folders
        }

        for pending in pendingFolderExceptions {
            var exceptions: [PBXFileSystemSynchronizedExceptionSet] = []
            for exception in pending.exceptions {
                try exceptions.append(makeFolderException(exception))
            }
            pending.folder.exceptions = exceptions
        }
    }

    private func makeFolderException(
        _ exception: XCSchema.FolderExceptionSet
    ) throws -> PBXFileSystemSynchronizedExceptionSet {
        switch exception {
        case let .target(content):
            guard let target = targetsByName[content.target.targetName] else {
                throw XCProjError.unresolvedTarget(content.target.targetName)
            }
            let common = content.commonProperties
            let compilerFlags: [String: String]? = content.additionalCompilerFlags.isEmpty
                ? nil
                : content.additionalCompilerFlags.reduce(into: [:]) { $0[$1.key.value] = $1.value }
            let set = try PBXFileSystemSynchronizedBuildFileExceptionSet(
                target: target,
                membershipExceptions: common.membershipExceptions.isEmpty ? nil : common.membershipExceptions.map(\.value).sorted(),
                publicHeaders: content.publicHeaders.isEmpty ? nil : content.publicHeaders.map(\.value).sorted(),
                privateHeaders: content.privateHeaders.isEmpty ? nil : content.privateHeaders.map(\.value).sorted(),
                additionalCompilerFlagsByRelativePath: compilerFlags,
                attributesByRelativePath: attributesByRelativePath(common),
                platformFiltersByRelativePath: platformFiltersByRelativePath(common)
            )
            add(set)
            return set

        case let .buildPhase(content):
            let phase = try resolvePhase(content.buildPhase)
            let common = content.commonProperties
            let set = try PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet(
                buildPhase: phase,
                membershipExceptions: common.membershipExceptions.isEmpty ? nil : common.membershipExceptions.map(\.value).sorted(),
                attributesByRelativePath: attributesByRelativePath(common)
            )
            add(set)
            return set
        }
    }

    private func attributesByRelativePath(
        _ common: XCSchema.CommonExceptionSetProperties
    ) throws -> [String: [String]]? {
        guard !common.attributesByFolderMemberID.isEmpty else { return nil }
        var result: [String: [String]] = [:]
        for (member, attributes) in common.attributesByFolderMemberID {
            result[member.value] = try BuildFileAttributesMapping.tokens(from: attributes)
        }
        return result
    }

    private func platformFiltersByRelativePath(
        _ common: XCSchema.CommonExceptionSetProperties
    ) -> [String: [String]]? {
        guard !common.platformFiltersByFolderMemberID.isEmpty else { return nil }
        var result: [String: [String]] = [:]
        for (member, filters) in common.platformFiltersByFolderMemberID {
            result[member.value] = filters.map(\.platformID).sorted()
        }
        return result
    }
}

extension XCProjDecoder {
    // MARK: - Imported products

    /// The products imported from one referenced project, with the file reference of that project.
    struct ImportedProducts {
        var projectFile: PBXFileReference
        var products: [PBXFileElement] = []
    }

    private func makeImportedProducts() throws -> [String: ImportedProducts] {
        var productsByProject: [String: ImportedProducts] = [:]

        for product in schema.importedProducts {
            let projectKey = product.project.description
            guard let projectFile = try resolveElement(product.project) as? PBXFileReference else {
                throw XCProjError.unsupportedFileElement("The referenced project '\(projectKey)'")
            }

            let proxy = PBXContainerItemProxy(
                containerPortal: .fileReference(projectFile),
                remoteGlobalID: .string(product.productID.rawValue),
                proxyType: .reference,
                remoteInfo: product.target
            )
            add(proxy)

            let referenceProxy = PBXReferenceProxy(
                fileType: product.fileType?.fileTypeID,
                path: product.path,
                remote: proxy,
                sourceTree: .buildProductsDir
            )
            add(referenceProxy)
            productsByProject[projectKey, default: ImportedProducts(projectFile: projectFile)]
                .products.append(referenceProxy)

            // A reference proxy is a file element, so its memberships take the ordinary path.
            enqueue(buildFiles: product.buildFiles, for: referenceProxy)
        }
        return productsByProject
    }
}

// MARK: - Schema helpers

extension XCSchema.BuildPhase {
    /// The name the schema records for this phase, if any.
    var schemaName: String? {
        switch self {
        case let .frameworks(properties),
             let .headers(properties),
             let .javaArchive(properties),
             let .resources(properties),
             let .rez(properties),
             let .sources(properties):
            properties.name
        case let .appleScript(properties): properties.baseProperties.name
        case let .copy(properties): properties.baseProperties.name
        case let .script(properties): properties.baseProperties.name
        }
    }

    /// The identifier the schema records for this phase, if any.
    var objectID: XCSchema.ObjectID? {
        switch self {
        case let .frameworks(properties),
             let .headers(properties),
             let .javaArchive(properties),
             let .resources(properties),
             let .rez(properties),
             let .sources(properties):
            properties.objectID
        case let .appleScript(properties): properties.baseProperties.objectID
        case let .copy(properties): properties.baseProperties.objectID
        case let .script(properties): properties.baseProperties.objectID
        }
    }
}

extension XCSchema.ProjectBuildPhaseReference {
    /// Widens a target relative build phase reference into a project relative one.
    init(targetName: String, buildPhase: XCSchema.TargetBuildPhaseReference) {
        switch buildPhase {
        case let .named(kind, name):
            self = .named(target: XCSchema.LocalTargetReference(targetName: targetName), kind: kind, name: name)
        case let .objectID(objectID):
            self = .objectID(objectID)
        }
    }
}
