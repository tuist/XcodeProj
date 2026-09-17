import Foundation
import XcodeProjectFormat

/// Builds an `XCSchema.Project` out of a `PBXProj` object graph, ready to be written as a
/// `project.xcproj`.
///
/// Every `PBXBuildFile` is a membership of one file in one build phase. The schema stores that
/// membership on the file instead, so the encoder first indexes the build files of every target by
/// the file they point at, then attaches them while walking the groups and files tree.
final class XCProjEncoder {
    private let proj: PBXProj
    private let settings: XCProjOutputSettings

    /// One recorded membership of a file in a build phase.
    private struct Membership {
        var buildFile: PBXBuildFile
        var phase: PBXBuildPhase
    }

    /// Memberships keyed by the file element they apply to.
    ///
    /// Reference proxies live outside the groups and files tree, but they are file elements and are
    /// keyed the same way.
    private var membershipsByElement: [PBXObjectReference: [Membership]] = [:]

    /// The package products each target links, gathered in the same pass as the memberships.
    private var packageMembershipsByTarget: [PBXObjectReference: [Membership]] = [:]

    /// The targets that synchronize each folder, so a folder does not have to scan every target.
    private var targetsByFolder: [PBXObjectReference: [XCSchema.LocalTargetReference]] = [:]

    /// The target attributes of the project, read once because the getter rebuilds the whole
    /// dictionary on every access.
    private var targetAttributes: [PBXTarget: [String: ProjectAttribute]] = [:]

    /// Build phases that can only be referred to by identifier, because their target has more than
    /// one phase of the same kind and name.
    private var ambiguousPhases: Set<PBXObjectReference> = []

    /// The target that owns each build phase.
    private var targetsByPhase: [PBXObjectReference: PBXTarget] = [:]

    /// The name of each build phase inside its target, if it has one.
    private var phaseNames: [PBXObjectReference: String] = [:]

    /// The name path of every element in the groups and files tree, used to build references.
    private var namePathsByElement: [PBXObjectReference: XCSchema.NamePath] = [:]

    /// Elements whose name path is shared with another element, so they need an identifier instead.
    private var ambiguousElements: Set<PBXObjectReference> = []

    /// Elements something in the project points at. Only those need to stay addressable, so only
    /// those get an identifier when their name path turns out to be ambiguous.
    private var referencedElements: Set<PBXObjectReference> = []

    /// Build phases something in the project points at, for the same reason.
    private var referencedPhases: Set<PBXObjectReference> = []

    /// Elements that always carry an identifier, whatever their name path looks like.
    ///
    /// A target's product can be referenced from another project, and such references are always
    /// identifier based, so the identifier has to be there even when nothing inside this project
    /// needs it. Xcode writes them for the same reason.
    private var alwaysIdentifiedElements: Set<PBXObjectReference> = []

    init(proj: PBXProj, settings: XCProjOutputSettings) {
        self.proj = proj
        self.settings = settings
    }

    // MARK: - Entry point

    func encode() throws -> XCSchema.Project {
        guard let project = proj.rootObject else {
            throw XCProjError.missingRootObject
        }
        guard let mainGroup = project.mainGroup else {
            throw XCProjError.missingRootObject
        }

        targetAttributes = project.targetAttributes
        indexBuildPhases(project: project)
        indexBuildFiles(project: project)
        indexNamePaths(of: mainGroup.children, prefix: [])
        indexReferencedObjects(project: project)

        let configurationNames = (project.buildConfigurationList?.buildConfigurations ?? []).map(\.name)
        let topLevelReferences = try mainGroup.children.map { try makeReference($0) }
        let targets = try project.targets.map { try makeTarget($0, configurationNames: configurationNames) }

        return try XCSchema.Project(
            objectID: objectID(for: project, required: false),
            rootGroupDebugID: objectID(for: mainGroup, required: false),
            configurationListDebugID: project.buildConfigurationList.flatMap { objectID(for: $0, required: false) },
            topLevelReferences: topLevelReferences,
            packages: makePackages(project: project),
            configurations: makeConfigurations(project.buildConfigurationList),
            buildSettings: mergedBuildSettings(project.buildConfigurationList, configurationNames: configurationNames),
            defaultConfigurationName: XCSchema.ConfigurationName(
                name: project.buildConfigurationList?.defaultConfigurationName ?? configurationNames.first ?? "Release"
            ),
            targets: targets,
            localizationInfo: localizationInfo(project: project),
            requiredCapabilities: [],
            buildIndependentTargetsInParallel: buildIndependentTargetsInParallel(project: project),
            lastUpgradeCheck: marketingVersion(project.attributes["LastUpgradeCheck"]),
            lastSwiftUpdateCheck: marketingVersion(project.attributes["LastSwiftUpdateCheck"]),
            lastSwiftMigration: marketingVersion(project.attributes["LastSwiftMigration"]),
            organizationName: project.attributes["ORGANIZATIONNAME"]?.stringValue,
            classPrefix: project.attributes["CLASSPREFIX"]?.stringValue,
            productsGroup: productsGroupReference(project: project),
            importedProducts: makeImportedProducts(project: project)
        )
    }
}

extension XCProjEncoder {
    // MARK: - Identifiers

    /// The identifier to emit for an object.
    ///
    /// With the minimal policy an identifier is only emitted where the format requires one, or
    /// where a name based reference would not resolve.
    private func objectID(for object: PBXObject, required: Bool) -> XCSchema.ObjectID? {
        switch settings.objectIDPolicy {
        case .preserveAll: XCSchema.ObjectID(object.uuid)
        case .minimal: required ? XCSchema.ObjectID(object.uuid) : nil
        }
    }
}

extension XCProjEncoder {
    // MARK: - Indexing

    /// Identifies a build phase inside its target by the kind and name a reference would use.
    private struct PhaseKey: Hashable {
        var kind: BuildPhase
        var name: String?
    }

    private func indexBuildPhases(project: PBXProject) {
        for target in project.targets {
            var keyed: [(phase: PBXBuildPhase, key: PhaseKey)] = []
            var counts: [PhaseKey: Int] = [:]
            for phase in target.buildPhases {
                targetsByPhase[phase.reference] = target
                let name = Self.name(of: phase)
                if let name { phaseNames[phase.reference] = name }
                let key = PhaseKey(kind: phase.buildPhase, name: name)
                keyed.append((phase, key))
                counts[key, default: 0] += 1
            }
            // A second phase with the same kind and name makes both of them unreachable by name.
            for (phase, key) in keyed where counts[key, default: 0] > 1 {
                ambiguousPhases.insert(phase.reference)
            }
        }
    }

    private func indexBuildFiles(project: PBXProject) {
        for target in project.targets {
            for phase in target.buildPhases {
                guard let buildFiles = phase.files, !buildFiles.isEmpty else { continue }
                referencedPhases.insert(phase.reference)
                for buildFile in buildFiles {
                    let membership = Membership(buildFile: buildFile, phase: phase)
                    if let file = buildFile.file {
                        membershipsByElement[file.reference, default: []].append(membership)
                    } else if buildFile.product != nil {
                        // A build file that carries a package product instead of a file belongs to
                        // the target rather than to anything in the groups and files tree.
                        packageMembershipsByTarget[target.reference, default: []].append(membership)
                    }
                }
            }
        }
    }

    /// Records which elements and build phases are pointed at from somewhere else.
    private func indexReferencedObjects(project: PBXProject) {
        func reference(_ element: PBXFileElement?) {
            guard let element else { return }
            referencedElements.insert(element.reference)
        }

        reference(project.productsGroup)
        for configuration in project.buildConfigurationList?.buildConfigurations ?? [] {
            reference(configuration.baseConfiguration)
            reference(configuration.baseConfigurationAnchor)
        }
        for target in project.targets {
            reference(target.product)
            if let product = target.product {
                alwaysIdentifiedElements.insert(product.reference)
            }
            for configuration in target.buildConfigurationList?.buildConfigurations ?? [] {
                reference(configuration.baseConfiguration)
                reference(configuration.baseConfigurationAnchor)
            }
            for dependency in target.dependencies {
                if case let .fileReference(projectFile) = dependency.targetProxy?.containerPortal {
                    reference(projectFile)
                }
            }
            for folder in target.fileSystemSynchronizedGroups ?? [] {
                targetsByFolder[folder.reference, default: []]
                    .append(XCSchema.LocalTargetReference(targetName: target.name))
                for exception in folder.exceptions ?? [] {
                    guard let exception = exception as? PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet,
                          let phase = exception.buildPhase else { continue }
                    referencedPhases.insert(phase.reference)
                }
            }
        }
        for projectReference in project.projectReferences {
            if let projectFile: PBXFileReference = projectReference[Xcode.ProjectReference.projectReferenceKey]?.getObject() {
                reference(projectFile)
            }
        }
    }

    private func indexNamePaths(of elements: [PBXFileElement], prefix: [XCSchema.NamePathComponent]) {
        var counts: [String: Int] = [:]
        for element in elements {
            counts[Self.name(of: element), default: 0] += 1
        }
        for element in elements {
            let name = Self.name(of: element)
            let components = prefix + [.child(name)]
            namePathsByElement[element.reference] = XCSchema.NamePath(components: components)
            if counts[name, default: 0] > 1 {
                ambiguousElements.insert(element.reference)
            }
            if let versionGroup = element as? XCVersionGroup, let currentVersion = versionGroup.currentVersion {
                referencedElements.insert(currentVersion.reference)
            }
            if let group = element as? PBXGroup {
                indexNamePaths(of: group.children, prefix: components)
            }
        }
    }

    /// The name an element is known by inside the groups and files tree.
    static func name(of element: PBXFileElement) -> String {
        XCProjNaming.name(of: element)
    }

    private static func name(of phase: PBXBuildPhase) -> String? {
        switch phase {
        case let phase as PBXCopyFilesBuildPhase: phase.name
        case let phase as PBXShellScriptBuildPhase: phase.name
        default: nil
        }
    }
}

extension XCProjEncoder {
    // MARK: - References into the tree

    private func groupTreeReference(to element: PBXFileElement) -> XCSchema.GroupTreeReference {
        // Carrying an identifier and being referred to by one are separate decisions. A target's
        // product always carries one so other projects can find it, yet this project still refers
        // to it by name, which is what keeps the file readable.
        let mustUseObjectID = settings.objectIDPolicy == .preserveAll || ambiguousElements.contains(element.reference)
        if mustUseObjectID {
            return .objectID(XCSchema.ObjectID(element.uuid))
        }
        guard let namePath = namePathsByElement[element.reference] else {
            // The element is outside the main group, for instance a product of a referenced
            // project, so only an identifier can address it.
            return .objectID(XCSchema.ObjectID(element.uuid))
        }
        return .namePath(namePath)
    }
}

extension XCProjEncoder {
    // MARK: - Groups and files tree

    private func makeReference(_ element: PBXFileElement) throws -> XCSchema.Reference {
        switch element {
        case let element as PBXVariantGroup:
            try .variantGroup(makeVariantGroup(element))
        case let element as XCVersionGroup:
            try .versionGroup(makeVersionGroup(element))
        case let element as PBXFileSystemSynchronizedRootGroup:
            try .folder(makeFolder(element))
        case let element as PBXGroup:
            try .group(makeGroup(element))
        case let element as PBXFileReference:
            try .fileReference(makeFileReference(element))
        default:
            throw XCProjError.unsupportedFileElement(String(describing: type(of: element)))
        }
    }

    private func makeFileReference(_ element: PBXFileReference) throws -> XCSchema.FileReference {
        let path = try XCSchema.FilePath.make(sourceTree: element.sourceTree, path: element.path)
        return try XCSchema.FileReference(
            objectID: needsObjectID(element) ? XCSchema.ObjectID(element.uuid) : nil,
            path: path,
            // `lastKnownFileType` is Xcode's own guess from the file extension, so only the explicit
            // override is carried over.
            explicitFileType: element.explicitFileType.map(XCSchema.FileTypeID.init(fileTypeID:)),
            expectedSignature: element.expectedSignature,
            textEncoding: element.fileEncoding.map(XCSchema.TextEncoding.init(fileEncoding:)),
            lineEnding: element.lineEnding.map { try XCSchema.LineEnding(fileReferenceValue: $0) },
            includeInIndex: element.includeInIndex,
            buildFiles: buildFiles(for: element)
        )
    }

    private func makeGroup(_ element: PBXGroup) throws -> XCSchema.Group {
        let path = try XCSchema.FilePath.make(sourceTree: element.sourceTree, path: element.path)
        return try XCSchema.Group(
            objectID: needsObjectID(element) ? XCSchema.ObjectID(element.uuid) : nil,
            name: element.name ?? path.lastPathComponent,
            path: path,
            includeInIndex: element.includeInIndex,
            children: element.children.map { try makeReference($0) }
        )
    }

    private func makeVariantGroup(_ element: PBXVariantGroup) throws -> XCSchema.VariantGroup {
        let path = try XCSchema.FilePath.make(sourceTree: element.sourceTree, path: element.path)
        return try XCSchema.VariantGroup(
            objectID: needsObjectID(element) ? XCSchema.ObjectID(element.uuid) : nil,
            name: element.name ?? path.lastPathComponent,
            path: path,
            includeInIndex: element.includeInIndex,
            buildFiles: buildFiles(for: element),
            children: element.children.map { child in
                guard let file = child as? PBXFileReference else {
                    throw XCProjError.unsupportedFileElement("A variant group child of type \(type(of: child))")
                }
                return try makeFileReference(file)
            }
        )
    }

    private func makeVersionGroup(_ element: XCVersionGroup) throws -> XCSchema.VersionGroup {
        let path = try XCSchema.FilePath.make(sourceTree: element.sourceTree, path: element.path)
        return try XCSchema.VersionGroup(
            objectID: needsObjectID(element) ? XCSchema.ObjectID(element.uuid) : nil,
            name: element.name ?? path.lastPathComponent,
            path: path,
            currentVersion: element.currentVersion.map { groupTreeReference(to: $0) },
            versionedFileType: element.versionGroupType.map(XCSchema.FileTypeID.init(fileTypeID:)),
            includeInIndex: element.includeInIndex,
            buildFiles: buildFiles(for: element),
            children: element.children.map { child in
                guard let file = child as? PBXFileReference else {
                    throw XCProjError.unsupportedFileElement("A version group child of type \(type(of: child))")
                }
                return try makeFileReference(file)
            }
        )
    }

    private func makeFolder(_ element: PBXFileSystemSynchronizedRootGroup) throws -> XCSchema.Folder {
        let path = try XCSchema.FilePath.make(sourceTree: element.sourceTree, path: element.path)
        var explicitFileTypes: [XCSchema.FolderMemberID: XCSchema.FileTypeID] = [:]
        for (member, fileType) in element.explicitFileTypes ?? [:] {
            explicitFileTypes[XCSchema.FolderMemberID(value: member)] = XCSchema.FileTypeID(fileTypeID: fileType)
        }

        // A folder does not list its targets; each target lists the folders it synchronizes, so the
        // relation is indexed once rather than rediscovered per folder.
        return try XCSchema.Folder(
            objectID: needsObjectID(element) ? XCSchema.ObjectID(element.uuid) : nil,
            path: path,
            targets: Set(targetsByFolder[element.reference] ?? []),
            membershipExceptions: (element.exceptions ?? []).map { try makeFolderException($0) },
            explicitFileTypes: explicitFileTypes,
            explicitOpaqueFolders: Set((element.explicitFolders ?? []).map(XCSchema.FolderMemberID.init(value:))),
            includeInIndex: element.includeInIndex
        )
    }

    private func makeFolderException(
        _ exception: PBXFileSystemSynchronizedExceptionSet
    ) throws -> XCSchema.FolderExceptionSet {
        switch exception {
        case let exception as PBXFileSystemSynchronizedBuildFileExceptionSet:
            return try .target(XCSchema.TargetExceptionSet(
                target: XCSchema.LocalTargetReference(targetName: exception.target?.name ?? ""),
                publicHeaders: Set((exception.publicHeaders ?? []).map(XCSchema.FolderMemberID.init(value:))),
                privateHeaders: Set((exception.privateHeaders ?? []).map(XCSchema.FolderMemberID.init(value:))),
                additionalCompilerFlags: (exception.additionalCompilerFlagsByRelativePath ?? [:])
                    .reduce(into: [:]) { $0[XCSchema.FolderMemberID(value: $1.key)] = $1.value },
                commonProperties: commonExceptionProperties(
                    // `PBXFileSystemSynchronizedBuildFileExceptionSet` only models exclusions, which
                    // is what Xcode writes for a folder that is already a member of the target.
                    sense: .exclusions,
                    membershipExceptions: exception.membershipExceptions,
                    attributesByRelativePath: exception.attributesByRelativePath,
                    platformFiltersByRelativePath: exception.platformFiltersByRelativePath
                )
            ))

        case let exception as PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet:
            guard let phase = exception.buildPhase else {
                throw XCProjError.unresolvedBuildPhase("a folder build phase membership exception set")
            }
            return try .buildPhase(XCSchema.BuildPhaseExceptionSet(
                buildPhase: projectBuildPhaseReference(to: phase),
                commonProperties: commonExceptionProperties(
                    sense: .inclusions,
                    membershipExceptions: exception.membershipExceptions,
                    attributesByRelativePath: exception.attributesByRelativePath,
                    platformFiltersByRelativePath: nil
                )
            ))

        default:
            throw XCProjError.unsupportedFileElement(String(describing: type(of: exception)))
        }
    }

    private func commonExceptionProperties(
        sense: XCSchema.ExceptionSetSense,
        membershipExceptions: [String]?,
        attributesByRelativePath: [String: [String]]?,
        platformFiltersByRelativePath: [String: [String]]?
    ) throws -> XCSchema.CommonExceptionSetProperties {
        var attributes: [XCSchema.FolderMemberID: XCSchema.BuildFileAttributes] = [:]
        for (member, tokens) in attributesByRelativePath ?? [:] {
            attributes[XCSchema.FolderMemberID(value: member)] = try BuildFileAttributesMapping.attributes(from: tokens)
        }
        var platforms: [XCSchema.FolderMemberID: Set<XCSchema.PlatformFilter>] = [:]
        for (member, filters) in platformFiltersByRelativePath ?? [:] {
            platforms[XCSchema.FolderMemberID(value: member)] = Set(filters.map(XCSchema.PlatformFilter.init(platformID:)))
        }
        return XCSchema.CommonExceptionSetProperties(
            sense: sense,
            membershipExceptions: Set((membershipExceptions ?? []).map(XCSchema.FolderMemberID.init(value:))),
            platformFiltersByFolderMemberID: platforms,
            attributesByFolderMemberID: attributes,
            assetTagsByFolderMemberID: [:]
        )
    }

    /// Whether an element needs an explicit identifier to be addressable.
    ///
    /// Only an element that something points at, and whose name path is shared with a sibling,
    /// needs one. Anything else stays name addressable, which is what keeps the file readable.
    private func needsObjectID(_ element: PBXFileElement) -> Bool {
        switch settings.objectIDPolicy {
        case .preserveAll: true
        case .minimal:
            alwaysIdentifiedElements.contains(element.reference)
                || (ambiguousElements.contains(element.reference) && referencedElements.contains(element.reference))
        }
    }

    /// Whether a build phase needs an explicit identifier to be addressable.
    private func needsObjectID(_ phase: PBXBuildPhase) -> Bool {
        switch settings.objectIDPolicy {
        case .preserveAll: true
        case .minimal: ambiguousPhases.contains(phase.reference) && referencedPhases.contains(phase.reference)
        }
    }
}

extension XCProjEncoder {
    // MARK: - Build file memberships

    private func buildFiles(for element: PBXFileElement) throws -> [XCSchema.ProjectBuildFile] {
        try buildFiles(for: element.reference)
    }

    private func buildFiles(for reference: PBXObjectReference) throws -> [XCSchema.ProjectBuildFile] {
        try (membershipsByElement[reference] ?? []).map { membership in
            try XCSchema.ProjectBuildFile(
                objectID: objectID(for: membership.buildFile, required: false),
                buildPhase: projectBuildPhaseReference(to: membership.phase),
                properties: XCSchema.BuildFileProperties(buildFile: membership.buildFile)
            )
        }
    }

    private func projectBuildPhaseReference(to phase: PBXBuildPhase) throws -> XCSchema.ProjectBuildPhaseReference {
        if needsObjectID(phase) {
            return .objectID(XCSchema.ObjectID(phase.uuid))
        }
        guard let target = targetsByPhase[phase.reference] else {
            throw XCProjError.unresolvedBuildPhase(phase.uuid)
        }
        return try .named(
            target: XCSchema.LocalTargetReference(targetName: target.name),
            kind: Self.kind(of: phase),
            name: phaseNames[phase.reference]
        )
    }

    private func targetBuildPhaseReference(to phase: PBXBuildPhase) throws -> XCSchema.TargetBuildPhaseReference {
        if needsObjectID(phase) {
            return .objectID(XCSchema.ObjectID(phase.uuid))
        }
        return try .named(kind: Self.kind(of: phase), name: phaseNames[phase.reference])
    }

    private static func kind(of phase: PBXBuildPhase) -> XCSchema.BuildPhase.Kind {
        switch phase.buildPhase {
        case .sources: .sources
        case .frameworks: .frameworks
        case .resources: .resources
        case .copyFiles: .copy
        case .runScript: .script
        case .headers: .headers
        case .carbonResources: .rez
        }
    }
}

extension XCProjEncoder {
    // MARK: - Configurations

    private func makeConfigurations(_ list: XCConfigurationList?) throws -> [XCSchema.Configuration] {
        try (list?.buildConfigurations ?? []).map { try makeConfiguration($0) }
    }

    private func makeConfiguration(_ configuration: XCBuildConfiguration) throws -> XCSchema.Configuration {
        let file = try configurationFileReference(configuration)
        let objectID = objectID(for: configuration, required: false)
        return XCSchema.Configuration(
            name: XCSchema.ConfigurationName(name: configuration.name),
            file: file,
            objectID: objectID
        )
    }

    private func configurationFileReference(
        _ configuration: XCBuildConfiguration
    ) throws -> XCSchema.GroupTreeAnchoredReference? {
        if let anchor = configuration.baseConfigurationAnchor,
           let relativePath = configuration.baseConfigurationReferenceRelativePath {
            return try XCSchema.GroupTreeAnchoredReference(
                anchor: groupTreeReference(to: anchor),
                relativePath: XCSchema.NamePath(losslessPathRepresentation: relativePath)
            )
        }
        guard let baseConfiguration = configuration.baseConfiguration else { return nil }
        return XCSchema.GroupTreeAnchoredReference(
            anchor: groupTreeReference(to: baseConfiguration),
            relativePath: nil
        )
    }

    private func mergedBuildSettings(
        _ list: XCConfigurationList?,
        configurationNames: [String]
    ) -> [String: XCSchema.BuildSetting] {
        var settingsByConfiguration: [String: BuildSettings] = [:]
        for configuration in list?.buildConfigurations ?? [] {
            settingsByConfiguration[configuration.name] = configuration.buildSettings
        }
        return BuildSettingsMapping.merge(settingsByConfiguration, configurationNames: configurationNames)
    }
}

extension XCProjEncoder {
    // MARK: - Targets

    private func makeTarget(_ target: PBXTarget, configurationNames: [String]) throws -> XCSchema.Target {
        let list = target.buildConfigurationList
        let attributes = targetAttributes[target] ?? [:]

        var specialized: [XCSchema.Configuration] = []
        for configuration in list?.buildConfigurations ?? [] {
            let encoded = try makeConfiguration(configuration)
            if encoded.isSpecialized {
                specialized.append(encoded)
            }
        }

        let properties = try XCSchema.CommonTargetProperties(
            name: target.name,
            // A target is always addressable from outside the project, so it always carries an ID.
            objectID: XCSchema.ObjectID(target.uuid),
            configurationListDebugID: list.flatMap { objectID(for: $0, required: false) },
            dependencies: target.dependencies.map { try makeTargetDependency($0) },
            buildPhases: target.buildPhases.map { try makeBuildPhase($0) },
            buildRules: target.buildRules.map(makeBuildRule),
            specializedConfigurations: specialized,
            buildSettings: mergedBuildSettings(list, configurationNames: configurationNames),
            product: target.product.map { groupTreeReference(to: $0) },
            productTypeID: XCSchema.ProductTypeID(productType: target.productType),
            testHostTarget: testHostTarget(attributes["TestTargetID"]),
            legacyProvisioningStyle: legacyProvisioningStyle(attributes["ProvisioningStyle"]),
            legacyTeamID: attributes["DevelopmentTeam"]?.stringValue,
            lastSwiftUpdateCheck: nil,
            lastSwiftMigration: marketingVersion(attributes["LastSwiftMigration"]),
            packageProductTargetMembers: makePackageProductMembers(target)
        )

        switch target {
        case let target as PBXLegacyTarget:
            return .externalBuildSystem(XCSchema.ExternalBuildSystemTargetProperties(
                commonProperties: properties,
                buildToolPath: target.buildToolPath ?? "",
                buildToolArguments: target.buildArgumentsString ?? "",
                buildToolWorkingDirectory: target.buildWorkingDirectory,
                passBuildSettingsInEnvironment: target.passBuildSettingsInEnvironment
            ))
        case is PBXAggregateTarget:
            return .aggregate(properties)
        default:
            return .native(properties)
        }
    }

    private func testHostTarget(_ attribute: ProjectAttribute?) -> XCSchema.LocalTargetReference? {
        guard case let .targetReference(object) = attribute, let target = object as? PBXTarget else { return nil }
        return XCSchema.LocalTargetReference(targetName: target.name)
    }

    private func legacyProvisioningStyle(_ attribute: ProjectAttribute?) -> XCSchema.LegacyProvisioningStyle? {
        switch attribute?.stringValue {
        case "Automatic": .automatic
        case "Manual": .manual
        default: nil
        }
    }

    private func marketingVersion(_ attribute: ProjectAttribute?) -> XCSchema.MarketingVersion? {
        guard let value = attribute?.stringValue else { return nil }
        return XCSchema.MarketingVersion(projectAttributeValue: value)
    }

    private func buildIndependentTargetsInParallel(project: PBXProject) -> Bool {
        guard let value = project.attributes["BuildIndependentTargetsInParallel"]?.stringValue else { return true }
        return value != "NO"
    }

    private func localizationInfo(project: PBXProject) -> XCSchema.ProjectLocalizationInfo {
        let development = XCSchema.Language(languageID: project.developmentRegion ?? Xcode.Default.developmentRegion)
        var supported = Set(project.knownRegions.map(XCSchema.Language.init(languageID:)))
        supported.remove(development)
        return XCSchema.ProjectLocalizationInfo(development: development, supported: supported)
    }
}

extension XCProjEncoder {
    // MARK: - Target dependencies

    private func makeTargetDependency(_ dependency: PBXTargetDependency) throws -> XCSchema.TargetDependency {
        var filters = Set((dependency.platformFilters ?? []).map(XCSchema.PlatformFilter.init(platformID:)))
        if let platformFilter = dependency.platformFilter {
            filters.insert(XCSchema.PlatformFilter(platformID: platformFilter))
        }

        if let product = dependency.product {
            return try .package(packageProductReference(product), filters)
        }
        if let target = dependency.target {
            return .localTarget(XCSchema.LocalTargetReference(targetName: target.name), filters)
        }
        guard let proxy = dependency.targetProxy else {
            throw XCProjError.unresolvedTarget(dependency.name ?? "an unnamed target dependency")
        }
        guard case let .fileReference(projectFile) = proxy.containerPortal else {
            throw XCProjError.unresolvedReference(dependency.name ?? "an unnamed target dependency")
        }
        guard let remoteGlobalID = proxy.remoteGlobalID else {
            throw XCProjError.missingObjectID("The remote target '\(proxy.remoteInfo ?? "")'")
        }
        return try .remoteTarget(
            XCSchema.RemoteTarget(
                project: groupTreeReference(to: projectFile),
                target: proxy.remoteInfo ?? dependency.name ?? "",
                targetID: XCSchema.ObjectID(remoteGlobalID.uuid)
            ),
            filters
        )
    }

    private func packageProductReference(
        _ product: XCSwiftPackageProductDependency
    ) -> XCSchema.SwiftPackageProductReference {
        XCSchema.SwiftPackageProductReference(
            objectID: objectID(for: product, required: false),
            package: product.package?.name.map(XCSchema.SwiftPackageName.init(packageName:)),
            productName: product.productName,
            productType: product.isPlugin ? .buildToolPlugin : .other
        )
    }

    private func makePackageProductMembers(
        _ target: PBXTarget
    ) throws -> [XCSchema.SwiftPackageProductTargetMember] {
        var members: [XCSchema.SwiftPackageProductTargetMember] = []
        for phase in target.buildPhases {
            for buildFile in phase.files ?? [] {
                guard let product = buildFile.product else { continue }
                try members.append(XCSchema.SwiftPackageProductTargetMember(
                    packageProduct: packageProductReference(product),
                    buildFile: XCSchema.TargetBuildFile(
                        objectID: objectID(for: buildFile, required: false),
                        buildPhase: targetBuildPhaseReference(to: phase),
                        properties: XCSchema.BuildFileProperties(buildFile: buildFile)
                    )
                ))
            }
        }
        return members
    }
}

extension XCProjEncoder {
    // MARK: - Build phases

    private func makeBuildPhase(_ phase: PBXBuildPhase) throws -> XCSchema.BuildPhase {
        let base = XCSchema.BuildPhaseProperties(
            objectID: needsObjectID(phase) ? XCSchema.ObjectID(phase.uuid) : nil,
            name: phaseNames[phase.reference]
        )
        switch phase {
        case let phase as PBXCopyFilesBuildPhase:
            return try .copy(XCSchema.CopyFilesBuildPhaseProperties(
                objectID: base.objectID,
                name: base.name,
                bundleBasePath: CopyFilesDestinationMapping.bundleBasePath(for: phase.dstSubfolderSpec),
                relativePath: phase.dstPath ?? "",
                scope: phase.runOnlyForDeploymentPostprocessing ? .install : .always
            ))
        case let phase as PBXShellScriptBuildPhase:
            return .script(XCSchema.ScriptBuildPhaseProperties(
                objectID: base.objectID,
                name: base.name ?? "",
                shellPath: phase.shellPath ?? "/bin/sh",
                script: phase.shellScript ?? "",
                logEnvironmentVariables: phase.showEnvVarsInLog,
                inputPaths: phase.inputPaths,
                inputFileListPaths: phase.inputFileListPaths ?? [],
                outputPaths: phase.outputPaths,
                outputFileListPaths: phase.outputFileListPaths ?? [],
                dependencyFile: phase.dependencyFile,
                runOnEveryBuild: phase.alwaysOutOfDate,
                scope: phase.runOnlyForDeploymentPostprocessing ? .install : .always
            ))
        default:
            switch phase.buildPhase {
            case .sources: return .sources(base)
            case .frameworks: return .frameworks(base)
            case .resources: return .resources(base)
            case .headers: return .headers(base)
            case .carbonResources: return .rez(base)
            case .copyFiles, .runScript:
                throw XCProjError.unsupportedBuildPhase(kind: phase.buildPhase.rawValue)
            }
        }
    }

    private func makeBuildRule(_ rule: PBXBuildRule) -> XCSchema.BuildRule {
        XCSchema.BuildRule(
            objectID: objectID(for: rule, required: false),
            processor: rule.compilerSpec,
            name: rule.name,
            fileType: rule.fileType.isEmpty ? nil : XCSchema.FileTypeID(fileTypeID: rule.fileType),
            filePatterns: rule.filePatterns,
            script: rule.script,
            inputFiles: rule.inputFiles ?? [],
            inputFileLists: [],
            outputFiles: rule.outputFiles,
            outputFileLists: [],
            outputFilesCompilerFlags: rule.outputFilesCompilerFlags ?? [],
            dependencyFile: rule.dependencyFile,
            runOncePerArchitecture: rule.runOncePerArchitecture ?? true
        )
    }
}

extension XCProjEncoder {
    // MARK: - Swift packages

    private func makePackages(project: PBXProject) -> [XCSchema.SwiftPackage] {
        var packages: [XCSchema.SwiftPackage] = []
        for package in project.remotePackages {
            packages.append(XCSchema.SwiftPackage(
                location: .remote(XCSchema.RemoteSwiftPackage(
                    repositoryURL: package.repositoryURL ?? "",
                    versionConstraint: package.versionRequirement.map(XCSchema.SwiftPackageVersionConstraint.init(versionRequirement:))
                )),
                traits: package.traits ?? []
            ))
        }
        for package in project.localPackages {
            packages.append(XCSchema.SwiftPackage(
                location: .local(XCSchema.LocalSwiftPackage(path: package.relativePath)),
                traits: package.traits ?? []
            ))
        }
        return packages
    }
}

extension XCProjEncoder {
    // MARK: - Imported products

    private func productsGroupReference(project: PBXProject) -> XCSchema.GroupTreeReference? {
        project.productsGroup.map { groupTreeReference(to: $0) }
    }

    private func makeImportedProducts(project: PBXProject) throws -> [XCSchema.RemoteProduct] {
        var products: [XCSchema.RemoteProduct] = []
        for reference in project.projectReferences {
            guard let projectFile: PBXFileReference = reference[Xcode.ProjectReference.projectReferenceKey]?.getObject(),
                  let productGroup: PBXGroup = reference[Xcode.ProjectReference.productGroupKey]?.getObject()
            else { continue }

            let projectReference = groupTreeReference(to: projectFile)
            for child in productGroup.children {
                guard let proxy = child as? PBXReferenceProxy else {
                    throw XCProjError.unsupportedFileElement(
                        "A \(type(of: child)) in the products group of a referenced project"
                    )
                }
                guard let remote = proxy.remote, let remoteGlobalID = remote.remoteGlobalID else {
                    throw XCProjError.missingObjectID("The imported product '\(proxy.path ?? "")'")
                }
                try products.append(XCSchema.RemoteProduct(
                    project: projectReference,
                    target: remote.remoteInfo ?? "",
                    productID: XCSchema.ObjectID(remoteGlobalID.uuid),
                    path: proxy.path ?? proxy.name ?? "",
                    fileType: proxy.fileType.map(XCSchema.FileTypeID.init(fileTypeID:)),
                    buildFiles: buildFiles(for: proxy.reference)
                ))
            }
        }
        return products
    }
}
