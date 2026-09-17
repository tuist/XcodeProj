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

    // MARK: - Ambiguity

    @Test func usesIdentifiersForAmbiguousNames() throws {
        // A file's build phase memberships live on the file itself, so an ambiguous file name only
        // matters for the things that are addressed by reference. A target's product is one of
        // them, so a product sharing its name with a sibling has to fall back to an identifier.
        let productA = PBXFileReference(sourceTree: .buildProductsDir, path: "App.app")
        let productB = PBXFileReference(sourceTree: .buildProductsDir, path: "App.app")

        let targetList = XCConfigurationList(
            buildConfigurations: [XCBuildConfiguration(name: "Release")],
            defaultConfigurationName: "Release"
        )
        let target = PBXNativeTarget(name: "App", buildConfigurationList: targetList, product: productA, productType: .application)
        let products = PBXGroup(children: [productA, productB], sourceTree: .group, name: "Products")
        let mainGroup = PBXGroup(children: [products], sourceTree: .group)
        let proj = try makeProj(
            mainGroup: mainGroup,
            target: target,
            productsGroup: products,
            extraObjects: [productA, productB, products]
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

        let targetList = XCConfigurationList(
            buildConfigurations: [XCBuildConfiguration(name: "Release")],
            defaultConfigurationName: "Release"
        )
        let target = PBXNativeTarget(name: "App", buildConfigurationList: targetList, buildPhases: [sources])
        let mainGroup = PBXGroup(children: [fileA, fileB], sourceTree: .group)
        let proj = try makeProj(
            mainGroup: mainGroup,
            target: target,
            extraObjects: [fileA, fileB, sources, buildFile]
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

        let targetList = XCConfigurationList(
            buildConfigurations: [XCBuildConfiguration(name: "Release")],
            defaultConfigurationName: "Release"
        )
        let target = PBXNativeTarget(name: "App", buildConfigurationList: targetList, buildPhases: [first, second])
        let mainGroup = PBXGroup(children: [file], sourceTree: .group)
        let proj = try makeProj(
            mainGroup: mainGroup,
            target: target,
            extraObjects: [first, second, file, buildFile]
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
    private func makeProj(
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
        ].compactMap { $0 } + (target.buildConfigurationList?.buildConfigurations ?? []))
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
