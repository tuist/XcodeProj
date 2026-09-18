import Foundation
import PathKit
import Testing
import XcodeProjectFormat
@testable import XcodeProj

/// Converts the existing `project.pbxproj` fixtures to `project.xcproj` and back, and checks that
/// what the two formats share survives the trip.
@Suite struct XCProjEncoderTests {
    private func convert(_ path: Path, name: String) throws -> (original: PBXProj, converted: PBXProj) {
        let original = try PBXProj(path: path)
        let data = try original.xcprojData()
        // Apple's decoder validates the file, so a successful read is also a format check.
        let converted = try PBXProj(xcprojData: data, projectName: name)
        return (original, converted)
    }

    @Test func convertIOSProject() throws {
        let (original, converted) = try convert(fixturesPath() + "iOS/Project.xcodeproj/project.pbxproj", name: "Project")
        expectTargetsMatch(original, converted)
        expectBuildSettingsMatch(original, converted)
        expectFileTreeMatches(original, converted)
    }

    @Test func convertSynchronizedRootGroupsProject() throws {
        let (original, converted) = try convert(
            fixturesPath() + "SynchronizedRootGroups/SynchronizedRootGroups.xcodeproj/project.pbxproj",
            name: "SynchronizedRootGroups"
        )
        expectTargetsMatch(original, converted)
        expectFileTreeMatches(original, converted)

        let originalFolders = try #require(original.rootObject?.targets.first?.fileSystemSynchronizedGroups)
        let convertedFolders = try #require(converted.rootObject?.targets.first?.fileSystemSynchronizedGroups)
        #expect(originalFolders.map(\.path) == convertedFolders.map(\.path))
    }

    @Test func convertProjectWithBuildConfigurationFilesInSynchronizedGroup() throws {
        let (original, converted) = try convert(
            fixturesPath() + "Xcode16BuildConfigurations/Xcode16BuildConfigurations.xcodeproj/project.pbxproj",
            name: "Xcode16BuildConfigurations"
        )
        expectTargetsMatch(original, converted)

        // The xcconfig anchored in a synchronized folder has to survive as an anchor plus a path.
        let originalConfigurations = original.rootObject?.targets.flatMap { $0.buildConfigurationList?.buildConfigurations ?? [] } ?? []
        let convertedConfigurations = converted.rootObject?.targets.flatMap { $0.buildConfigurationList?.buildConfigurations ?? [] } ?? []
        #expect(
            originalConfigurations.map(\.baseConfigurationReferenceRelativePath)
                == convertedConfigurations.map(\.baseConfigurationReferenceRelativePath)
        )
        #expect(
            originalConfigurations.map { $0.baseConfigurationAnchor?.path }
                == convertedConfigurations.map { $0.baseConfigurationAnchor?.path }
        )
    }

    @Test func convertFileSharedAcrossTargets() throws {
        let (original, converted) = try convert(
            fixturesPath() + "FileSharedAcrossTargets/FileSharedAcrossTargets.xcodeproj/project.pbxproj",
            name: "FileSharedAcrossTargets"
        )
        expectTargetsMatch(original, converted)
        // One file belongs to several targets, so it carries several memberships.
        #expect(
            original.rootObject?.targets.map { $0.buildPhases.map { ($0.files ?? []).count } }
                == converted.rootObject?.targets.map { $0.buildPhases.map { ($0.files ?? []).count } }
        )
    }

    @Test func convertTargetWithCustomBuildRules() throws {
        let (original, converted) = try convert(
            fixturesPath() + "TargetWithCustomBuildRules/TargetWithCustomBuildRules.xcodeproj/project.pbxproj",
            name: "TargetWithCustomBuildRules"
        )
        let originalRules = try #require(original.rootObject?.targets.first?.buildRules)
        let convertedRules = try #require(converted.rootObject?.targets.first?.buildRules)
        #expect(originalRules.map(\.compilerSpec) == convertedRules.map(\.compilerSpec))
        #expect(originalRules.map(\.fileType) == convertedRules.map(\.fileType))
        #expect(originalRules.map(\.filePatterns) == convertedRules.map(\.filePatterns))
        #expect(originalRules.map(\.script) == convertedRules.map(\.script))
        #expect(originalRules.map(\.outputFiles) == convertedRules.map(\.outputFiles))
    }

    @Test func convertProjectWithLocalSwiftPackages() throws {
        let (original, converted) = try convert(
            fixturesPath() + "iOS/ProjectWithXCLocalSwiftPackageReferences.xcodeproj/project.pbxproj",
            name: "ProjectWithXCLocalSwiftPackageReferences"
        )
        #expect(
            original.rootObject?.localPackages.map(\.relativePath).sorted()
                == converted.rootObject?.localPackages.map(\.relativePath).sorted()
        )
    }

    @Test func encodedFileIsValidForApplesDecoder() throws {
        let original = try PBXProj(path: fixturesPath() + "iOS/Project.xcodeproj/project.pbxproj")
        let data = try original.xcprojData()
        #expect(throws: Never.self) {
            try XCSchema.Project(jsonRepresentation: data)
        }
    }

    /// Xcode resolves a version group's `current-version` against the version group's own children,
    /// not from the project root. A full tree path like `App/Model.xcdatamodeld/Model.xcdatamodel`
    /// is a valid `GroupTreeReference` and passes Apple's schema validator, but Xcode itself rejects
    /// it with "Invalid reference" and refuses to open the project. The encoder emits a single
    /// component name path relative to the version group instead.
    @Test func versionGroupCurrentVersionIsRelativeToTheGroup() throws {
        let model = PBXFileReference(sourceTree: .group, path: "Model.xcdatamodel")
        let versionGroup = XCVersionGroup(
            currentVersion: model,
            path: "Model.xcdatamodeld",
            sourceTree: .group,
            versionGroupType: "wrapper.xcdatamodel",
            children: [model]
        )
        let nested = PBXGroup(children: [versionGroup], sourceTree: .group, name: "App")
        let mainGroup = PBXGroup(children: [nested], sourceTree: .group)
        let targetList = XCConfigurationList(
            buildConfigurations: [XCBuildConfiguration(name: "Release")],
            defaultConfigurationName: "Release"
        )
        let target = PBXNativeTarget(name: "App", buildConfigurationList: targetList)
        let proj = try Self.makeProj(
            mainGroup: mainGroup,
            target: target,
            extraObjects: [model, versionGroup, nested]
        )

        let encoded = try XCProjEncoder(proj: proj, settings: .default).encode()
        guard case let .group(appGroup) = encoded.topLevelReferences[0],
              case let .versionGroup(encodedVersionGroup) = appGroup.children[0]
        else {
            Issue.record("Expected a nested version group in the encoded project")
            return
        }

        guard case let .namePath(namePath) = try #require(encodedVersionGroup.currentVersion) else {
            Issue.record("current-version was not emitted as a name path")
            return
        }
        let expected: [XCSchema.NamePathComponent] = [.child("Model.xcdatamodel")]
        #expect(
            namePath.components == expected,
            "current-version must be a single component relative to the version group, not a full tree path"
        )
    }

    /// A file reference's `name` is not written, so a name path built from it points at nothing and
    /// Xcode rejects the project with "Invalid reference".
    @Test func namePathOfAFileReferenceFollowsItsPath() throws {
        let xcconfig = PBXFileReference(sourceTree: .group, name: "Shared", path: "Configs/Debug.xcconfig")
        let configuration = XCBuildConfiguration(name: "Release", baseConfiguration: xcconfig)
        let targetList = XCConfigurationList(buildConfigurations: [configuration], defaultConfigurationName: "Release")
        let target = PBXNativeTarget(name: "App", buildConfigurationList: targetList)
        let mainGroup = PBXGroup(children: [xcconfig], sourceTree: .group)
        let proj = try Self.makeProj(
            mainGroup: mainGroup,
            target: target,
            extraObjects: [xcconfig, configuration]
        )

        let text = try String(decoding: proj.xcprojData(), as: UTF8.self)

        #expect(
            text.contains("\"Debug.xcconfig\""),
            "the xcconfig has to be referenced as the file spells it"
        )
        #expect(
            !text.contains("\"Shared\""),
            "PBXFileReference.name is not written, so nothing can be referenced by it"
        )
    }

    /// Xcode rejects `"App/copy"` and `"App/script"` with "Could not uniquely resolve the build
    /// phase name" even when the target holds one, because it can hold many. Apple's schema
    /// validator accepts both spellings, so only an identifier makes such a phase addressable.
    @Test(arguments: ["CopyFiles", "Run Script", "Sources", "Frameworks", "Resources", "Headers"])
    func namelessRepeatablePhasesCarryAnIdentifier(rawKind: String) throws {
        let kind = try #require(BuildPhase(rawValue: rawKind))
        let phase: PBXBuildPhase = switch kind {
        case .copyFiles: PBXCopyFilesBuildPhase(dstPath: "include", dstSubfolderSpec: .productsDirectory)
        case .runScript: PBXShellScriptBuildPhase(shellScript: "echo hi")
        case .sources: PBXSourcesBuildPhase()
        case .frameworks: PBXFrameworksBuildPhase()
        case .resources: PBXResourcesBuildPhase()
        default: PBXHeadersBuildPhase()
        }
        let file = PBXFileReference(sourceTree: .group, path: "Main.swift")
        let buildFile = PBXBuildFile(file: file)
        phase.files = [buildFile]

        let configuration = XCBuildConfiguration(name: "Release")
        let targetList = XCConfigurationList(buildConfigurations: [configuration], defaultConfigurationName: "Release")
        let target = PBXNativeTarget(name: "App", buildConfigurationList: targetList, buildPhases: [phase])
        let mainGroup = PBXGroup(children: [file], sourceTree: .group)
        let proj = try Self.makeProj(
            mainGroup: mainGroup,
            target: target,
            extraObjects: [phase, file, buildFile, configuration]
        )

        let schemaKind = switch kind {
        case .copyFiles: "copy"
        case .runScript: "script"
        case .sources: "compile-sources"
        default: rawKind.lowercased()
        }
        let data = try proj.xcprojData()
        let emittedByName = String(decoding: data, as: UTF8.self).contains("\"App/\(schemaKind)\"")
        let repeatable = kind == .copyFiles || kind == .runScript

        #expect(
            emittedByName == !repeatable,
            repeatable
                ? "a nameless \(schemaKind) phase is not addressable by name and needs an identifier"
                : "a target holds one \(schemaKind) phase, so the name is enough"
        )

        // Whichever spelling it is, the membership has to survive the trip back.
        let decoded = try PBXProj(xcprojData: data, projectName: "App")
        #expect(decoded.rootObject?.targets.first?.buildPhases.first?.files?.count == 1)
    }

    // MARK: - Ambiguity

    @Test func usesIdentifiersForAmbiguousNames() throws {
        // A file's build phase memberships live on the file itself, so an ambiguous file name only
        // matters for the things that are addressed by reference. A target's product is one of
        // them, so a product sharing its name with a sibling has to fall back to an identifier.
        let productA = PBXFileReference(sourceTree: .buildProductsDir, path: "App.app")
        let productB = PBXFileReference(sourceTree: .buildProductsDir, path: "App.app")

        let configuration = XCBuildConfiguration(name: "Release")
        let targetList = XCConfigurationList(buildConfigurations: [configuration], defaultConfigurationName: "Release")
        let target = PBXNativeTarget(name: "App", buildConfigurationList: targetList, product: productA, productType: .application)
        let products = PBXGroup(children: [productA, productB], sourceTree: .group, name: "Products")
        let mainGroup = PBXGroup(children: [products], sourceTree: .group)
        let proj = try Self.makeProj(
            mainGroup: mainGroup,
            target: target,
            productsGroup: products,
            extraObjects: [productA, productB, products, configuration]
        )

        let encoded = try XCProjEncoder(proj: proj, settings: .default).encode()
        guard case let .group(productsGroup) = encoded.topLevelReferences[0],
              case let .fileReference(first) = productsGroup.children[0],
              case let .fileReference(second) = productsGroup.children[1]
        else {
            Issue.record("Expected a products group with two file references")
            return
        }

        #expect(first.objectID != nil, "The product a target points at needs an identifier")
        #expect(second.objectID == nil, "Nothing points at the sibling, so it stays identifier free")
        #expect(encoded.targets.first?.commonProperties.product == .objectID(XCSchema.ObjectID(productA.uuid)))

        // The file still decodes, and the target still finds its product.
        let decoded = try PBXProj(xcprojData: proj.xcprojData(), projectName: "App")
        #expect(decoded.rootObject?.targets.first?.product?.uuid == productA.uuid)
    }

    @Test func omitsIdentifiersForAmbiguousNamesNothingPointsAt() throws {
        // Two files with the same name that nothing refers to stay identifier free, because their
        // build phase memberships are recorded on the files themselves.
        let fileA = PBXFileReference(sourceTree: .group, path: "A/Shared.swift")
        let fileB = PBXFileReference(sourceTree: .group, path: "B/Shared.swift")
        let sources = PBXSourcesBuildPhase()
        let buildFile = PBXBuildFile(file: fileA)
        sources.files = [buildFile]

        let configuration = XCBuildConfiguration(name: "Release")
        let targetList = XCConfigurationList(buildConfigurations: [configuration], defaultConfigurationName: "Release")
        let target = PBXNativeTarget(name: "App", buildConfigurationList: targetList, buildPhases: [sources])
        let mainGroup = PBXGroup(children: [fileA, fileB], sourceTree: .group)
        let proj = try Self.makeProj(
            mainGroup: mainGroup,
            target: target,
            extraObjects: [fileA, fileB, sources, buildFile, configuration]
        )

        let encoded = try XCProjEncoder(proj: proj, settings: .default).encode()
        guard case let .fileReference(reference) = encoded.topLevelReferences[0] else {
            Issue.record("Expected a file reference")
            return
        }
        #expect(reference.objectID == nil)

        let decoded = try PBXProj(xcprojData: proj.xcprojData(), projectName: "App")
        let decodedSources = try #require(decoded.rootObject?.targets.first?.buildPhases.first)
        #expect(decodedSources.files?.count == 1)
        #expect(decodedSources.files?.first?.file?.path == "A/Shared.swift")
    }

    @Test func usesIdentifiersForAmbiguousBuildPhases() throws {
        // Two script phases without names cannot be told apart by kind and name.
        let first = PBXShellScriptBuildPhase(shellScript: "echo first")
        let second = PBXShellScriptBuildPhase(shellScript: "echo second")
        let file = PBXFileReference(sourceTree: .group, path: "Main.swift")
        let buildFile = PBXBuildFile(file: file)
        first.files = [buildFile]

        let configuration = XCBuildConfiguration(name: "Release")
        let targetList = XCConfigurationList(buildConfigurations: [configuration], defaultConfigurationName: "Release")
        let target = PBXNativeTarget(name: "App", buildConfigurationList: targetList, buildPhases: [first, second])
        let mainGroup = PBXGroup(children: [file], sourceTree: .group)
        let proj = try Self.makeProj(
            mainGroup: mainGroup,
            target: target,
            extraObjects: [first, second, file, buildFile, configuration]
        )

        let decoded = try PBXProj(xcprojData: proj.xcprojData(), projectName: "App")
        let phases = try #require(decoded.rootObject?.targets.first?.buildPhases)
        #expect(phases.count == 2)
        #expect(phases[0].files?.count == 1)
        #expect(phases[1].files?.count == 0)
    }

    // MARK: - Helpers

    /// Builds a minimal project around one target, so the ambiguity tests only have to describe
    /// what they are actually testing.
    static func makeProj(
        mainGroup: PBXGroup,
        target: PBXTarget,
        productsGroup: PBXGroup? = nil,
        extraObjects: [PBXObject]
    ) throws -> PBXProj {
        let projectConfiguration = XCBuildConfiguration(name: "Release")
        let projectList = XCConfigurationList(
            buildConfigurations: [projectConfiguration],
            defaultConfigurationName: "Release"
        )
        let project = PBXProject(
            name: "App",
            buildConfigurationList: projectList,
            compatibilityVersion: nil,
            preferredProjectObjectVersion: nil,
            minimizedProjectReferenceProxies: nil,
            mainGroup: mainGroup,
            productsGroup: productsGroup,
            targets: [target]
        )
        let proj = PBXProj(rootObject: project, objects: extraObjects + [
            target.buildConfigurationList as PBXObject?,
            target,
            projectConfiguration,
            projectList,
            mainGroup,
            project,
        ].compactMap { $0 })
        try ReferenceGenerator(outputSettings: PBXOutputSettings()).generateReferences(proj: proj)
        return proj
    }

    private func expectTargetsMatch(
        _ original: PBXProj,
        _ converted: PBXProj,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        #expect(
            original.rootObject?.targets.map(\.name) == converted.rootObject?.targets.map(\.name),
            sourceLocation: sourceLocation
        )
        #expect(
            original.rootObject?.targets.map(\.productType) == converted.rootObject?.targets.map(\.productType),
            sourceLocation: sourceLocation
        )
        #expect(
            original.rootObject?.targets.map { $0.buildPhases.map(\.buildPhase) }
                == converted.rootObject?.targets.map { $0.buildPhases.map(\.buildPhase) },
            sourceLocation: sourceLocation
        )
        #expect(
            original.rootObject?.targets.map(\.dependencies.count) == converted.rootObject?.targets.map(\.dependencies.count),
            sourceLocation: sourceLocation
        )
    }

    private func expectBuildSettingsMatch(
        _ original: PBXProj,
        _ converted: PBXProj,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        for (originalTarget, convertedTarget) in zip(original.rootObject?.targets ?? [], converted.rootObject?.targets ?? []) {
            let originalConfigurations = originalTarget.buildConfigurationList?.buildConfigurations ?? []
            let convertedConfigurations = convertedTarget.buildConfigurationList?.buildConfigurations ?? []
            #expect(
                originalConfigurations.map(\.name) == convertedConfigurations.map(\.name),
                sourceLocation: sourceLocation
            )
            for (originalConfiguration, convertedConfiguration) in zip(originalConfigurations, convertedConfigurations) {
                #expect(
                    originalConfiguration.buildSettings == convertedConfiguration.buildSettings,
                    "Build settings of \(originalTarget.name)/\(originalConfiguration.name) changed",
                    sourceLocation: sourceLocation
                )
            }
        }
    }

    private func expectFileTreeMatches(
        _ original: PBXProj,
        _ converted: PBXProj,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        // Elements are described by their path, because that is what both formats store. A
        // `PBXFileReference` name that differs from its path, such as the language name Xcode gives
        // the children of a variant group, has no place in the schema and is not expected back.
        func describe(_ elements: [PBXFileElement]) -> [String] {
            elements.flatMap { element -> [String] in
                let name = element.path ?? element.name ?? ""
                guard let group = element as? PBXGroup else { return [name] }
                return [name] + describe(group.children).map { "\(name)/\($0)" }
            }
        }
        #expect(
            describe(original.rootObject?.mainGroup.children ?? []) == describe(converted.rootObject?.mainGroup.children ?? []),
            sourceLocation: sourceLocation
        )
    }
}

/// The places where the two models say the same thing in different words, checked against Apple's
/// schema rather than against what looked reasonable.
@Suite struct XCProjSchemaAgreementTests {
    @Test func aScriptPhaseWithoutANameStaysNameless() throws {
        // The schema initializer insists on a name, so a nameless phase would otherwise come back
        // as `"name": ""` and stop matching the file Xcode wrote.
        let phase = PBXShellScriptBuildPhase(shellScript: "echo hi")
        let file = PBXFileReference(sourceTree: .group, path: "Main.swift")
        let configuration = XCBuildConfiguration(name: "Release")
        let list = XCConfigurationList(buildConfigurations: [configuration], defaultConfigurationName: "Release")
        let target = PBXNativeTarget(name: "App", buildConfigurationList: list, buildPhases: [phase])
        let mainGroup = PBXGroup(children: [file], sourceTree: .group)
        let proj = try XCProjEncoderTests.makeProj(mainGroup: mainGroup, target: target, extraObjects: [phase, file, configuration])

        let encoded = try XCProjEncoder(proj: proj, settings: .default).encode()
        guard case let .script(properties) = encoded.targets.first?.commonProperties.buildPhases.first else {
            Issue.record("Expected a script phase")
            return
        }
        #expect(properties.baseProperties.name == nil)

        let decoded = try PBXProj(xcprojData: proj.xcprojData(), projectName: "App")
        #expect((decoded.rootObject?.targets.first?.buildPhases.first as? PBXShellScriptBuildPhase)?.name == nil)
    }

    @Test func exceptionSetSenseFollowsFolderMembership() throws {
        // `membershipExceptions` excludes files from a target the folder belongs to, and includes
        // them in one it does not. The property list keeps a single list; the JSON names the sense.
        let folder = PBXFileSystemSynchronizedRootGroup(sourceTree: .group, path: "Sources")
        let configuration = XCBuildConfiguration(name: "Release")
        let list = XCConfigurationList(buildConfigurations: [configuration], defaultConfigurationName: "Release")
        let owner = PBXNativeTarget(name: "App", buildConfigurationList: list)
        owner.fileSystemSynchronizedGroups = [folder]
        let otherConfiguration = XCBuildConfiguration(name: "Release")
        let otherList = XCConfigurationList(buildConfigurations: [otherConfiguration], defaultConfigurationName: "Release")
        let other = PBXNativeTarget(name: "Tests", buildConfigurationList: otherList)
        let excluded = PBXFileSystemSynchronizedBuildFileExceptionSet(
            target: owner, membershipExceptions: ["Excluded.swift"], publicHeaders: nil, privateHeaders: nil,
            additionalCompilerFlagsByRelativePath: nil, attributesByRelativePath: nil
        )
        let included = PBXFileSystemSynchronizedBuildFileExceptionSet(
            target: other, membershipExceptions: ["Shared.swift"], publicHeaders: nil, privateHeaders: nil,
            additionalCompilerFlagsByRelativePath: nil, attributesByRelativePath: nil
        )
        folder.exceptions = [excluded, included]
        let mainGroup = PBXGroup(children: [folder], sourceTree: .group)
        let proj = try XCProjEncoderTests.makeProj(
            mainGroup: mainGroup, target: owner,
            extraObjects: [folder, excluded, included, configuration, other, otherList, otherConfiguration]
        )
        proj.rootObject?.targets.append(other)

        let encoded = try XCProjEncoder(proj: proj, settings: .default).encode()
        guard case let .folder(schemaFolder) = encoded.topLevelReferences.first else {
            Issue.record("Expected a folder")
            return
        }
        var senses: [String: XCSchema.ExceptionSetSense] = [:]
        for case let .target(set) in schemaFolder.membershipExceptions {
            senses[set.target.targetName] = set.commonProperties.sense
        }
        #expect(senses["App"] == .exclusions)
        #expect(senses["Tests"] == .inclusions)

        // Both come back as the one list the property list has.
        let decoded = try PBXProj(xcprojData: proj.xcprojData(), projectName: "App")
        let decodedFolder = decoded.rootObject?.mainGroup.children.first as? PBXFileSystemSynchronizedRootGroup
        let sets = decodedFolder?.exceptions?.compactMap { $0 as? PBXFileSystemSynchronizedBuildFileExceptionSet } ?? []
        #expect(sets.first { $0.target?.name == "App" }?.membershipExceptions == ["Excluded.swift"])
        #expect(sets.first { $0.target?.name == "Tests" }?.membershipExceptions == ["Shared.swift"])
    }

    @Test func aLocalDependencyExpressedThroughAProxyAloneIsLocal() throws {
        // Some property lists point at a target of the same project through the proxy only, with
        // the project as its portal and no `target` shortcut.
        let configuration = XCBuildConfiguration(name: "Release")
        let list = XCConfigurationList(buildConfigurations: [configuration], defaultConfigurationName: "Release")
        let toolConfiguration = XCBuildConfiguration(name: "Release")
        let toolList = XCConfigurationList(buildConfigurations: [toolConfiguration], defaultConfigurationName: "Release")
        let tool = PBXNativeTarget(name: "Tool", buildConfigurationList: toolList)
        let app = PBXNativeTarget(name: "App", buildConfigurationList: list)
        let mainGroup = PBXGroup(children: [], sourceTree: .group)
        let proj = try XCProjEncoderTests.makeProj(
            mainGroup: mainGroup, target: app,
            extraObjects: [configuration, tool, toolList, toolConfiguration]
        )
        let project = try #require(proj.rootObject)
        project.targets.append(tool)
        let proxy = PBXContainerItemProxy(containerPortal: .project(project), remoteGlobalID: .object(tool), proxyType: .nativeTarget, remoteInfo: "Tool")
        let dependency = PBXTargetDependency(name: "Tool", targetProxy: proxy)
        proj.objects.add(object: proxy)
        proj.objects.add(object: dependency)
        app.dependencies = [dependency]

        let encoded = try XCProjEncoder(proj: proj, settings: .default).encode()
        #expect(encoded.targets.first?.commonProperties.dependencies == [.localTarget(XCSchema.LocalTargetReference(targetName: "Tool"), [])])
    }

    @Test func exceptionSetDataThePropertyListCannotHoldIsRejected() throws {
        // Asset tags in an exception set have no field on either property list exception set type.
        var text = try String(contentsOf: everythingXCProjPath.url, encoding: .utf8)
        text = text.replacingOccurrences(
            of: "\"exclusions\": [\n            \"Excluded.swift\",\n          ],",
            with: "\"exclusions\": [\n            \"Excluded.swift\",\n          ],\n          \"asset-tags\": { \"Excluded.swift\": [ \"Tag\" ] },"
        )
        #expect(text.contains("asset-tags"), "The fixture edit did not apply")
        #expect(throws: XCProjError.unsupportedBuildFileAttribute("asset-tags in a folder exception set")) {
            try PBXProj(xcprojData: Data(text.utf8), projectName: "Everything")
        }
    }
}
