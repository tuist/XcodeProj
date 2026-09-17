import Foundation
import PathKit
import Testing
import XcodeProjectFormat
@testable import XcodeProj

/// Checks that a `project.xcproj` decodes into the `PBXProj` object graph a caller expects.
@Suite struct XCProjDecoderTests {
    private let proj: PBXProj
    private let project: PBXProject

    init() throws {
        proj = try PBXProj(xcprojPath: everythingXCProjPath)
        project = try #require(proj.rootObject)
    }

    // MARK: - Project

    @Test func projectAttributes() {
        #expect(project.name == "Everything")
        #expect(project.attributes["ORGANIZATIONNAME"]?.stringValue == "example.com")
        #expect(project.attributes["CLASSPREFIX"]?.stringValue == "EX")
        #expect(project.attributes["BuildIndependentTargetsInParallel"]?.stringValue == "NO")
        #expect(project.developmentRegion == "en")
        #expect(project.knownRegions == ["Base", "en", "ja"])
    }

    @Test func projectBuildSettingsAreSplitPerConfiguration() throws {
        let list = try #require(project.buildConfigurationList)
        #expect(list.defaultConfigurationName == "Release")
        #expect(list.buildConfigurations.map(\.name) == ["Debug", "Release"])

        let debug = try #require(list.buildConfigurations.first { $0.name == "Debug" })
        let release = try #require(list.buildConfigurations.first { $0.name == "Release" })

        // An unconditional setting reaches every configuration.
        #expect(debug.buildSettings["SDKROOT"] == .string("iphoneos"))
        #expect(release.buildSettings["SDKROOT"] == .string("iphoneos"))
        // A `config=` condition selects one configuration and is stripped from the key.
        #expect(debug.buildSettings["ONLY_ACTIVE_ARCH"] == .string("YES"))
        #expect(release.buildSettings["ONLY_ACTIVE_ARCH"] == nil)
        #expect(debug.buildSettings["ONLY_ACTIVE_ARCH[config=Debug]"] == nil)
    }

    @Test func configurationFileBecomesBaseConfiguration() throws {
        let list = try #require(project.buildConfigurationList)
        let release = try #require(list.buildConfigurations.first { $0.name == "Release" })
        #expect(release.baseConfiguration?.path == "Release.xcconfig")
    }

    // MARK: - Groups and files tree

    @Test func groupTree() throws {
        let children = project.mainGroup.children
        #expect(children.map { XCProjEncoder.name(of: $0) } == ["App", "Sources", "Remote.xcodeproj", "Products"])

        let app = try #require(children.first as? PBXGroup)
        #expect(app.sourceTree == .group)
        #expect(app.path == "App")
        // The name is omitted when it matches the last path component, as Xcode does.
        #expect(app.name == nil)
    }

    @Test func variantGroup() throws {
        let app = try #require(project.mainGroup.children.first as? PBXGroup)
        let variant = try #require(app.children.first { $0 is PBXVariantGroup } as? PBXVariantGroup)
        #expect(variant.name == "Localizable.strings")
        #expect(
            variant.children.compactMap { ($0 as? PBXFileReference)?.path }
                == ["en.lproj/Localizable.strings", "ja.lproj/Localizable.strings"]
        )
    }

    @Test func versionGroup() throws {
        let app = try #require(project.mainGroup.children.first as? PBXGroup)
        let version = try #require(app.children.first { $0 is XCVersionGroup } as? XCVersionGroup)
        #expect(version.versionGroupType == "wrapper.xcdatamodel")
        #expect(version.currentVersion?.path == "Model.xcdatamodel")
    }

    @Test func synchronizedFolder() throws {
        let folder = try #require(
            project.mainGroup.children.first { $0 is PBXFileSystemSynchronizedRootGroup } as? PBXFileSystemSynchronizedRootGroup
        )
        #expect(folder.path == "Sources")
        #expect(folder.explicitFileTypes == ["Sources/Blob.dat": "file"])
        #expect(folder.explicitFolders == ["Sources/Bundle"])

        let app = try #require(project.targets.first { $0.name == "App" })
        #expect(app.fileSystemSynchronizedGroups?.count == 1)

        let exceptions = try #require(folder.exceptions)
        #expect(exceptions.count == 2)
        let targetException = try #require(exceptions.compactMap { $0 as? PBXFileSystemSynchronizedBuildFileExceptionSet }.first)
        #expect(targetException.target?.name == "App")
        #expect(targetException.membershipExceptions == ["Sources/Excluded.swift"])
        #expect(targetException.publicHeaders == ["Sources/Exposed.h"])
        #expect(targetException.additionalCompilerFlagsByRelativePath == ["Sources/Special.m": "-fno-objc-arc"])

        let phaseException = try #require(
            exceptions.compactMap { $0 as? PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet }.first
        )
        #expect(phaseException.membershipExceptions == ["Sources/Extra.framework"])
        #expect(phaseException.buildPhase is PBXCopyFilesBuildPhase)
    }

    // MARK: - Targets

    @Test func targetKinds() throws {
        #expect(project.targets.map(\.name) == ["App", "Tool", "All", "Make"])
        #expect(project.targets[0] is PBXNativeTarget)
        #expect(project.targets[2] is PBXAggregateTarget)

        let make = try #require(project.targets[3] as? PBXLegacyTarget)
        #expect(make.buildToolPath == "/usr/bin/make")
        #expect(make.buildArgumentsString == "all")
        #expect(make.buildWorkingDirectory == "$(SRCROOT)")
        #expect(make.passBuildSettingsInEnvironment == false)
    }

    @Test func targetIdentifiersAreKept() throws {
        let app = try #require(project.targets.first { $0.name == "App" })
        #expect(app.uuid == "APPTARGET000000000000001")
    }

    @Test func targetAttributes() throws {
        let app = try #require(project.targets.first { $0.name == "App" })
        let attributes = try #require(project.targetAttributes[app])
        #expect(attributes["ProvisioningStyle"]?.stringValue == "Manual")
        #expect(attributes["DevelopmentTeam"]?.stringValue == "ABCDE12345")
        #expect(attributes["LastSwiftMigration"]?.stringValue == "2720")
    }

    @Test func targetProduct() throws {
        let app = try #require(project.targets.first { $0.name == "App" })
        #expect(app.product?.path == "App.app")
        #expect(app.productType == .application)
    }

    // MARK: - Build phases and build files

    @Test func buildPhases() throws {
        let app = try #require(project.targets.first { $0.name == "App" })
        #expect(app.buildPhases.map(\.buildPhase) == [.sources, .headers, .frameworks, .resources, .copyFiles, .runScript])

        let copy = try #require(app.buildPhases[4] as? PBXCopyFilesBuildPhase)
        #expect(copy.name == "Embed Frameworks")
        #expect(copy.dstSubfolderSpec == .frameworks)

        let script = try #require(app.buildPhases[5] as? PBXShellScriptBuildPhase)
        #expect(script.name == "Lint")
        #expect(script.shellScript == "set -euo pipefail\nswiftlint")
        #expect(script.inputPaths == ["$(SRCROOT)/App"])
        #expect(script.alwaysOutOfDate)
        #expect(script.runOnlyForDeploymentPostprocessing)
    }

    @Test func buildFilesLandInTheirPhase() throws {
        let app = try #require(project.targets.first { $0.name == "App" })
        let sources = try #require(app.buildPhases.first { $0.buildPhase == .sources })
        // AppDelegate.swift, Legacy.m and the Core Data model, in tree order.
        #expect(
            sources.files?.compactMap { $0.file?.name ?? $0.file?.path }
                == ["AppDelegate.swift", "Legacy.m", "Model.xcdatamodeld"]
        )

        let legacy = try #require(sources.files?.first { $0.file?.path == "Legacy.m" })
        #expect(legacy.settings?["COMPILER_FLAGS"] == .string("-fno-objc-arc"))
        #expect(legacy.platformFilters == ["ios"])

        let headers = try #require(app.buildPhases.first { $0.buildPhase == .headers })
        #expect(headers.files?.first?.settings?["ATTRIBUTES"] == .array(["Public"]))
    }

    @Test func importedProductBecomesAReferenceProxy() throws {
        #expect(project.projectReferences.count == 1)
        let frameworks = try #require(project.targets.first { $0.name == "App" }?.buildPhases.first { $0.buildPhase == .frameworks })
        let proxy = try #require(frameworks.files?.compactMap { $0.file as? PBXReferenceProxy }.first)
        #expect(proxy.path == "Remote.framework")
        #expect(proxy.fileType == "wrapper.framework")
        #expect(proxy.remote?.remoteGlobalID?.uuid == "REMOTEPRODUCT0000000001")
        #expect(proxy.remote?.proxyType == .reference)
    }

    // MARK: - Dependencies and packages

    @Test func dependencies() throws {
        let app = try #require(project.targets.first { $0.name == "App" })
        #expect(app.dependencies.count == 3)

        let local = app.dependencies[0]
        #expect(local.target?.name == "Tool")
        #expect(local.targetProxy?.proxyType == .nativeTarget)

        let remote = app.dependencies[1]
        #expect(remote.target == nil)
        #expect(remote.targetProxy?.remoteInfo == "Remote")
        #expect(remote.targetProxy?.remoteGlobalID?.uuid == "REMOTETARGET00000000001")

        let package = app.dependencies[2]
        #expect(package.product?.productName == "ArgumentParser")
    }

    @Test func packages() throws {
        #expect(project.remotePackages.map(\.repositoryURL) == [
            "https://github.com/apple/swift-argument-parser",
            "https://github.com/apple/swift-log",
        ])
        #expect(project.remotePackages[0].versionRequirement == .upToNextMajorVersion("1.0.0"))
        #expect(project.remotePackages[1].versionRequirement == .range(from: "1.0.0", to: "2.0.0"))
        #expect(project.remotePackages[1].traits == ["Logging"])
        #expect(project.localPackages.map(\.relativePath) == ["Packages/Local"])
    }

    @Test func packageProductMemberBecomesABuildFile() throws {
        let app = try #require(project.targets.first { $0.name == "App" })
        // Xcode lists every package product the target uses, both the one it links and the one it
        // depends on, on the target itself.
        #expect(app.packageProductDependencies?.map(\.productName).sorted() == ["ArgumentParser", "Logging"])
        let frameworks = try #require(app.buildPhases.first { $0.buildPhase == .frameworks })
        #expect(frameworks.files?.compactMap { $0.product?.productName } == ["Logging"])
    }

    // MARK: - Build rules

    @Test func buildRules() throws {
        let app = try #require(project.targets.first { $0.name == "App" })
        let rule = try #require(app.buildRules.first)
        #expect(rule.name == "Compress assets")
        #expect(rule.compilerSpec == "com.apple.compilers.proxy.script")
        #expect(rule.filePatterns == "*.raw")
        #expect(rule.outputFiles == ["$(DERIVED_FILE_DIR)/$(INPUT_FILE_BASE).png"])
        #expect(rule.runOncePerArchitecture == false)
    }

    // MARK: - Versions

    @Test func usesAnObjectVersionXcodeUnderstands() {
        #expect(proj.objectVersion == XCProjDecoder.defaultObjectVersion)
        #expect(proj.archiveVersion == Xcode.LastKnown.archiveVersion)
    }

    @Test func generatesReferencesForObjectsWithoutIdentifiers() {
        // Every object must end up with a permanent reference, otherwise writing a
        // `project.pbxproj` would emit placeholder identifiers.
        var temporaries: [String] = []
        // swiftformat:disable:next preferForLoop
        proj.objects.forEach { object in
            guard object.reference.temporary else { return }
            temporaries.append(String(describing: type(of: object)))
        }
        #expect(temporaries.isEmpty)
    }
}
