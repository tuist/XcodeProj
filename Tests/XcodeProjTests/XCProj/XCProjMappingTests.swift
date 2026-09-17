import Foundation
import Testing
import XcodeProjectFormat
@testable import XcodeProj

/// Unit tests for the value conversions the adapter relies on.
@Suite struct XCProjMappingTests {
    // MARK: - Build setting keys

    @Test func buildSettingKeyParsesConditions() {
        let key = BuildSettingKey(rawValue: "OTHER_LDFLAGS[sdk=iphoneos*][arch=arm64]")
        #expect(key.name == "OTHER_LDFLAGS")
        #expect(key.conditions == ["sdk=iphoneos*", "arch=arm64"])
        #expect(key.configurationName == nil)
        #expect(key.rawValue == "OTHER_LDFLAGS[sdk=iphoneos*][arch=arm64]")
    }

    @Test func buildSettingKeyFindsAndRemovesTheConfigurationCondition() {
        let key = BuildSettingKey(rawValue: "SWIFT_FLAGS[config=Debug][sdk=iphoneos*]")
        #expect(key.configurationName == "Debug")
        #expect(key.removingConfigurationCondition().rawValue == "SWIFT_FLAGS[sdk=iphoneos*]")
    }

    @Test func buildSettingKeyKeepsMalformedKeysVerbatim() {
        let key = BuildSettingKey(rawValue: "BROKEN[config=Debug")
        #expect(key.name == "BROKEN[config=Debug")
        #expect(key.conditions.isEmpty)
        #expect(key.rawValue == "BROKEN[config=Debug")
    }

    // MARK: - Build settings split and merge

    @Test func splitAppliesUnconditionalKeysEverywhere() {
        let split = BuildSettingsMapping.split(
            ["SDKROOT": .string("iphoneos")],
            configurationNames: ["Debug", "Release"]
        )
        #expect(split["Debug"]?["SDKROOT"] == .string("iphoneos"))
        #expect(split["Release"]?["SDKROOT"] == .string("iphoneos"))
    }

    @Test func splitRoutesConditionalKeysToOneConfiguration() {
        let split = BuildSettingsMapping.split(
            ["GCC_OPTIMIZATION_LEVEL[config=Debug]": .string("0")],
            configurationNames: ["Debug", "Release"]
        )
        #expect(split["Debug"]?["GCC_OPTIMIZATION_LEVEL"] == .string("0"))
        #expect(split["Release"] == [:])
    }

    @Test func splitKeepsConditionsThatNameNoConfiguration() {
        // A wildcard has no single configuration to move to, so the key is left intact.
        let split = BuildSettingsMapping.split(
            ["FLAGS[config=*]": .string("-v")],
            configurationNames: ["Debug", "Release"]
        )
        #expect(split["Debug"]?["FLAGS[config=*]"] == .string("-v"))
        #expect(split["Release"]?["FLAGS[config=*]"] == .string("-v"))
    }

    @Test func mergeDropsTheConditionWhenEveryConfigurationAgrees() {
        let merged = BuildSettingsMapping.merge(
            ["Debug": ["SDKROOT": .string("iphoneos")], "Release": ["SDKROOT": .string("iphoneos")]],
            configurationNames: ["Debug", "Release"]
        )
        #expect(merged == ["SDKROOT": .string("iphoneos")])
    }

    @Test func mergeAddsAConditionWhenValuesDiffer() {
        let merged = BuildSettingsMapping.merge(
            ["Debug": ["LEVEL": .string("0")], "Release": ["LEVEL": .string("s")]],
            configurationNames: ["Debug", "Release"]
        )
        #expect(merged == [
            "LEVEL[config=Debug]": .string("0"),
            "LEVEL[config=Release]": .string("s"),
        ])
    }

    @Test func mergeAddsAConditionWhenOnlyOneConfigurationDefinesTheKey() {
        let merged = BuildSettingsMapping.merge(
            ["Debug": ["ONLY_ACTIVE_ARCH": .string("YES")], "Release": [:]],
            configurationNames: ["Debug", "Release"]
        )
        #expect(merged == ["ONLY_ACTIVE_ARCH[config=Debug]": .string("YES")])
    }

    @Test func mergePutsTheConfigurationConditionFirst() {
        let merged = BuildSettingsMapping.merge(
            ["Debug": ["FLAGS[sdk=iphoneos*]": .string("-a")], "Release": [:]],
            configurationNames: ["Debug", "Release"]
        )
        #expect(merged == ["FLAGS[config=Debug][sdk=iphoneos*]": .string("-a")])
    }

    @Test func splitAndMergeRoundTrip() {
        let original: [String: XCSchema.BuildSetting] = [
            "SDKROOT": .string("iphoneos"),
            "ONLY_ACTIVE_ARCH[config=Debug]": .string("YES"),
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": .array(["$(inherited)", "APP"]),
        ]
        let names = ["Debug", "Release"]
        let merged = BuildSettingsMapping.merge(
            BuildSettingsMapping.split(original, configurationNames: names),
            configurationNames: names
        )
        #expect(merged == original)
    }

    // MARK: - File paths

    // `PBXSourceTree` is not `Sendable`, so the cases cannot be passed as test arguments.
    @Test func filePathMapsEverySourceTree() throws {
        let cases: [(PBXSourceTree?, XCSchema.FilePath.Base)] = [
            (.group, .group),
            (nil, .group),
            (PBXSourceTree.none, .group),
            (.sourceRoot, .project),
            (.developerDir, .developer),
            (.buildProductsDir, .buildProducts),
            (.sdkRoot, .sdk),
            (.custom("MY_VAR"), .sourceRoot("MY_VAR")),
        ]
        for (sourceTree, expected) in cases {
            let path = try XCSchema.FilePath.make(sourceTree: sourceTree, path: "a/b.swift")
            #expect(path.base == expected, "for source tree \(String(describing: sourceTree))")
            #expect(path.path == "a/b.swift")
            if let sourceTree, sourceTree != PBXSourceTree.none {
                #expect(path.pbxSourceTree == sourceTree)
            }
        }
    }

    @Test func absolutePathsKeepTheirBase() throws {
        let path = try XCSchema.FilePath.make(sourceTree: .absolute, path: "/usr/lib/libz.tbd")
        #expect(path.base == .absolute)
        #expect(path.pbxSourceTree == .absolute)
    }

    @Test func anAbsolutePathWithAGroupSourceTreeBecomesAbsolute() throws {
        // `FilePath` refuses that combination, but a `PBXFileElement` is free to hold it.
        let path = try XCSchema.FilePath.make(sourceTree: .group, path: "/usr/lib/libz.tbd")
        #expect(path.base == .absolute)
    }

    @Test func aRelativePathWithAnAbsoluteSourceTreeIsRejected() {
        #expect(throws: (any Error).self) {
            try XCSchema.FilePath.make(sourceTree: .absolute, path: "a/b.swift")
        }
    }

    @Test func emptyPathHasNoPBXPath() throws {
        let path = try XCSchema.FilePath.make(sourceTree: .group, path: nil)
        #expect(path.pbxPath == nil)
    }

    // MARK: - Marketing versions

    @Test func marketingVersionParsesThePackedForm() {
        #expect(XCSchema.MarketingVersion(projectAttributeValue: "1600") == XCSchema.MarketingVersion(major: 16, minor: 0, update: 0))
        #expect(XCSchema.MarketingVersion(projectAttributeValue: "0920") == XCSchema.MarketingVersion(major: 9, minor: 2, update: 0))
        #expect(XCSchema.MarketingVersion(projectAttributeValue: "1531") == XCSchema.MarketingVersion(major: 15, minor: 3, update: 1))
        #expect(XCSchema.MarketingVersion(projectAttributeValue: "not a version") == nil)
    }

    @Test func marketingVersionWritesThePackedForm() {
        #expect(XCSchema.MarketingVersion(major: 16, minor: 0, update: 0).projectAttributeValue == "1600")
        #expect(XCSchema.MarketingVersion(major: 9, minor: 2, update: 0).projectAttributeValue == "0920")
        #expect(XCSchema.MarketingVersion(major: 27, minor: 2, update: 0).projectAttributeValue == "2720")
    }

    // MARK: - Build file attributes

    @Test func buildFileAttributesRoundTripThroughTokens() throws {
        let attributes = XCSchema.BuildFileAttributes(
            headerRole: .private,
            machInterfaceGeneration: .both,
            isWeak: true,
            codeSignOnCopy: true,
            codeGeneration: .skip,
            headerPreservation: .removeOnCopy,
            decompress: false,
            codeGenerationVisibility: nil
        )
        let tokens = try BuildFileAttributesMapping.tokens(from: attributes)
        #expect(tokens == ["Private", "Client", "Server", "Weak", "CodeSignOnCopy", "RemoveHeadersOnCopy", "no_codegen"])
        #expect(try BuildFileAttributesMapping.attributes(from: tokens) == attributes)
    }

    @Test func buildFileAttributesRejectUnknownTokens() {
        #expect(throws: XCProjError.unknownBuildFileAttribute("SomethingNew")) {
            try BuildFileAttributesMapping.attributes(from: ["SomethingNew"])
        }
    }

    @Test func buildFileAttributesRejectAttributesWithNoPBXSpelling() {
        let attributes = XCSchema.BuildFileAttributes(
            headerRole: nil,
            machInterfaceGeneration: nil,
            isWeak: false,
            codeSignOnCopy: false,
            codeGeneration: .default,
            headerPreservation: .keep,
            decompress: true,
            codeGenerationVisibility: nil
        )
        #expect(throws: XCProjError.unsupportedBuildFileAttribute("decompress")) {
            try BuildFileAttributesMapping.tokens(from: attributes)
        }
    }

    // MARK: - Copy files destinations

    @Test(arguments: [
        XCSchema.BundleBasePath?.none, .root, .productDir, .executablesDir, .resourcesDir,
        .javaDir, .frameworksDir, .sharedFrameworksDir, .sharedSupportDir, .plugInsDir,
    ])
    func copyFilesDestinationRoundTrips(destination: XCSchema.BundleBasePath?) throws {
        let subFolder = try CopyFilesDestinationMapping.subFolder(for: destination)
        #expect(try CopyFilesDestinationMapping.bundleBasePath(for: subFolder) == destination)
    }

    @Test func copyFilesDestinationRejectsUnmappedLocations() {
        #expect(throws: (any Error).self) {
            try CopyFilesDestinationMapping.subFolder(for: .infoPlist)
        }
    }

    // MARK: - Package version constraints

    @Test(arguments: [
        XCSchema.SwiftPackageVersionConstraint.revision("abc123"),
        .branch("main"),
        .version("1.2.3"),
        .versionRange(min: "1.0.0", max: "2.0.0"),
        .upToNextMinorVersion("1.2.0"),
        .upToNextMajorVersion("1.0.0"),
    ])
    func packageVersionConstraintRoundTrips(constraint: XCSchema.SwiftPackageVersionConstraint) {
        let requirement = constraint.versionRequirement
        #expect(XCSchema.SwiftPackageVersionConstraint(versionRequirement: requirement) == constraint)
    }

    // MARK: - Product types

    @Test func productTypeRoundTrips() {
        #expect(XCSchema.ProductTypeID(productType: .application)?.productTypeID == "com.apple.product-type.application")
        #expect(XCSchema.ProductTypeID(productType: .application)?.pbxProductType == .application)
        #expect(XCSchema.ProductTypeID(productType: PBXProductType.none) == nil)
        #expect(XCSchema.ProductTypeID(productType: nil) == nil)
    }
}
