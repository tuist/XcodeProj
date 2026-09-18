import Foundation
import PathKit
import Testing
import XcodeProjectFormat
@testable import XcodeProj

/// A `project.xcproj` can refer to an element by identifier, and Xcode refuses to open the project
/// when that identifier is not defined anywhere in the file. Neither Apple's schema validator nor
/// this library's round trip notices, because both resolve a reference against the graph that
/// produced it rather than against the file.
@Suite struct XCProjDanglingReferenceTests {
    // MARK: - The invariant

    /// Every `id:` reference in the encoded project has to be defined by some element in it.
    private func expectNoDanglingIdentifiers(
        _ data: Data,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        let text = String(decoding: data, as: UTF8.self)
        let referenced = Set(matches(of: "\"id:([0-9A-Za-z_-]+)\"", in: text))
        let defined = Set(matches(of: "\"id\"\\s*:\\s*\"([0-9A-Za-z_-]+)\"", in: text))
        #expect(
            referenced.subtracting(defined).isEmpty,
            "the file refers to \(referenced.subtracting(defined).sorted()) without defining it",
            sourceLocation: sourceLocation
        )
    }

    private func matches(of pattern: String, in text: String) -> [String] {
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(text.startIndex..., in: text)
        return regex.matches(in: text, range: range).compactMap { match in
            Range(match.range(at: 1), in: text).map { String(text[$0]) }
        }
    }

    // MARK: - Fixtures that used to produce an unopenable file

    @Test(arguments: [
        "iOS/ProjectWithoutProductsGroup.xcodeproj",
        "Xcode16ProjectReferenceOrder/Test.xcodeproj",
        "Xcode16ProjectReferenceOrder/Wrong.xcodeproj",
    ])
    func fixturesEncodeWithoutDanglingIdentifiers(fixture: String) throws {
        let proj = try PBXProj(path: fixturesPath() + fixture + "project.pbxproj")
        let data = try proj.xcprojData()
        expectNoDanglingIdentifiers(data)
        // Apple's decoder still has to accept it.
        #expect(throws: Never.self) { try XCSchema.Project(jsonRepresentation: data) }
    }

    // MARK: - A products group that is the main group

    /// `productRefGroup` pointing at the main group is how a project without a separate products
    /// group spells it. The main group is the root of the tree rather than an entry in it, so it
    /// carries no identifier and only the empty name path can address it.
    @Test func productsGroupThatIsTheMainGroupBecomesTheRootNamePath() throws {
        let source = PBXFileReference(sourceTree: .group, path: "main.swift")
        let mainGroup = PBXGroup(children: [source], sourceTree: .group)
        let configuration = XCBuildConfiguration(name: "Release")
        let targetList = XCConfigurationList(buildConfigurations: [configuration], defaultConfigurationName: "Release")
        let target = PBXNativeTarget(name: "App", buildConfigurationList: targetList)
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
            productsGroup: mainGroup,
            targets: [target]
        )
        let proj = PBXProj(rootObject: project, objects: [
            source, mainGroup, target, targetList, configuration, projectConfiguration, projectList, project,
        ])

        let data = try proj.xcprojData()
        expectNoDanglingIdentifiers(data)
        let encoded = try XCSchema.Project(jsonRepresentation: data)
        #expect(encoded.productsGroup == .namePath(XCSchema.NamePath(components: [])))
    }

    // MARK: - An element no group in the tree holds

    /// A subproject's file reference is named by `projectReferences` and by a dependency's
    /// container portal, but nothing has to list it as a child of a group. Xcode's own converter
    /// collects such an element into a "Recovered References" group, which is what keeps the
    /// reference to it resolvable.
    @Test func aProjectReferenceOutsideTheTreeIsRecovered() throws {
        let subproject = PBXFileReference(
            sourceTree: .group,
            name: "AnotherProject",
            lastKnownFileType: "wrapper.pb-project",
            path: "AnotherProject/AnotherProject.xcodeproj"
        )
        let source = PBXFileReference(sourceTree: .group, path: "main.swift")
        // The subproject reference is deliberately not a child of any group.
        let mainGroup = PBXGroup(children: [source], sourceTree: .group)
        let productsGroup = PBXGroup(children: [], sourceTree: .group, name: "AnotherProject Products")

        let configuration = XCBuildConfiguration(name: "Release")
        let targetList = XCConfigurationList(buildConfigurations: [configuration], defaultConfigurationName: "Release")
        let target = PBXNativeTarget(name: "App", buildConfigurationList: targetList)
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
            projects: [["ProductGroup": productsGroup, "ProjectRef": subproject]],
            targets: [target]
        )
        let proj = PBXProj(rootObject: project, objects: [
            subproject, source, mainGroup, productsGroup, target, targetList,
            configuration, projectConfiguration, projectList, project,
        ])

        let data = try proj.xcprojData()
        expectNoDanglingIdentifiers(data)
        let text = String(decoding: data, as: UTF8.self)
        #expect(
            text.contains("\"\(XCProjEncoder.recoveredReferencesGroupName)\""),
            "an element no group holds needs somewhere to live in the file"
        )
        #expect(throws: Never.self) { try XCSchema.Project(jsonRepresentation: data) }
    }

    // MARK: - Ambiguity below an ambiguous group

    /// A name path is only as good as every component in it. Two sibling groups spelled the same
    /// way cannot be told apart, so neither can anything inside them, and Xcode rejects a reference
    /// like `"Products/App.app"` with "Invalid reference". This is the shape a project with several
    /// subproject references has, each contributing a group named `Products`.
    @Test func childrenOfSameNamedSiblingGroupsFallBackToIdentifiers() throws {
        let product = PBXFileReference(
            sourceTree: .buildProductsDir,
            explicitFileType: "wrapper.application",
            path: "App.app",
            includeInIndex: false
        )
        let ourProducts = PBXGroup(children: [product], sourceTree: .group, name: "Products")
        let theirProducts = PBXGroup(children: [], sourceTree: .group, name: "Products")
        let mainGroup = PBXGroup(children: [theirProducts, ourProducts], sourceTree: .group)

        let configuration = XCBuildConfiguration(name: "Release")
        let targetList = XCConfigurationList(buildConfigurations: [configuration], defaultConfigurationName: "Release")
        let target = PBXNativeTarget(
            name: "App",
            buildConfigurationList: targetList,
            product: product,
            productType: .application
        )
        let proj = try XCProjEncoderTests.makeProj(
            mainGroup: mainGroup,
            target: target,
            extraObjects: [product, ourProducts, theirProducts, configuration]
        )

        let data = try proj.xcprojData()
        expectNoDanglingIdentifiers(data)
        let text = String(decoding: data, as: UTF8.self)
        #expect(
            !text.contains("\"Products/App.app\""),
            "a name path through an ambiguous group resolves to nothing"
        )
        #expect(throws: Never.self) { try XCSchema.Project(jsonRepresentation: data) }
    }

    /// The recovered group is synthesized, so nothing stops a project from already holding a group
    /// of that name. Both are then spelled the same way and neither can be addressed by name.
    @Test func aProjectThatAlreadyHasARecoveredReferencesGroupStaysResolvable() throws {
        let subproject = PBXFileReference(
            sourceTree: .group,
            name: "AnotherProject",
            lastKnownFileType: "wrapper.pb-project",
            path: "AnotherProject/AnotherProject.xcodeproj"
        )
        let existing = PBXFileReference(sourceTree: .group, path: "Old.xcodeproj")
        let squatter = PBXGroup(
            children: [existing],
            sourceTree: .group,
            name: XCProjEncoder.recoveredReferencesGroupName
        )
        let mainGroup = PBXGroup(children: [squatter], sourceTree: .group)
        let productsGroup = PBXGroup(children: [], sourceTree: .group, name: "AnotherProject Products")

        let configuration = XCBuildConfiguration(name: "Release")
        let targetList = XCConfigurationList(buildConfigurations: [configuration], defaultConfigurationName: "Release")
        let target = PBXNativeTarget(name: "App", buildConfigurationList: targetList)
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
            projects: [["ProductGroup": productsGroup, "ProjectRef": subproject]],
            targets: [target]
        )
        let proj = PBXProj(rootObject: project, objects: [
            subproject, existing, squatter, mainGroup, productsGroup, target, targetList,
            configuration, projectConfiguration, projectList, project,
        ])

        let data = try proj.xcprojData()
        expectNoDanglingIdentifiers(data)
        let text = String(decoding: data, as: UTF8.self)
        #expect(
            !text.contains("\"\(XCProjEncoder.recoveredReferencesGroupName)/"),
            "a name path through either group of that name resolves to nothing"
        )
        #expect(throws: Never.self) { try XCSchema.Project(jsonRepresentation: data) }
    }
}
