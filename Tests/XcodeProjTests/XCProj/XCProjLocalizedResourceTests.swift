import PathKit
import Testing
@testable import XcodeProj

@Suite struct XCProjLocalizedResourceTests {
    private let fixture = fixturesPath() + "XCProj/LocalizedResources.xcodeproj"

    @Test func decodeResolvesLocalizedResourcePaths() throws {
        let project = try XcodeProj(path: fixture)
        try expectResourcePaths(project.pbxproj, sourceRoot: fixture.parent())
    }

    @Test(arguments: [ProjectFormat.xcproj, .pbxproj])
    func roundTripPreservesLocalizedResourcePaths(format: ProjectFormat) throws {
        let project = try XcodeProj(path: fixture)
        let temporary = try Path.uniqueTemporary()
        defer { try? temporary.delete() }
        let destination = temporary + "Converted.xcodeproj"
        try project.write(path: destination, format: format)
        let reopened = try XcodeProj(path: destination)
        #expect(reopened.projectFormat == format)
        try expectResourcePaths(reopened.pbxproj, sourceRoot: temporary)
    }

    @Test func legacyFixtureKeepsBaseResourcePathsAfterJSONConversion() throws {
        let source = fixturesPath() + "iOS/Project.xcodeproj"
        let original = try XcodeProj(path: source)
        let temporary = try Path.uniqueTemporary()
        defer { try? temporary.delete() }
        let destination = temporary + "Converted.xcodeproj"
        try original.write(path: destination, format: .xcproj)
        let converted = try XcodeProj(path: destination)

        let originalGroups = original.pbxproj.variantGroups
        #expect(!originalGroups.isEmpty)
        for group in originalGroups {
            let reread = try #require(converted.pbxproj.variantGroups.first { $0.name == group.name })
            // Use the same source root: the conversion moves the project, not its resources.
            #expect(try reread.fullPath(sourceRoot: source.parent()) == group.fullPath(sourceRoot: source.parent()))
        }
    }

    @Test func explicitBaseNameTakesPrecedenceOverInferredPath() throws {
        let project = try XcodeProj(path: fixture)
        let group = try #require(project.pbxproj.variantGroups.first { $0.name == "LaunchScreen.storyboard" })
        let explicit = try #require(group.children.first)
        explicit.name = "Base"
        explicit.path = "Custom/LaunchScreen.storyboard"
        group.children = Array(group.children.reversed())
        #expect(try group.fullPath(sourceRoot: fixture.parent()) == fixture.parent() + "Resources/Custom/LaunchScreen.storyboard")
    }

    private func expectResourcePaths(_ proj: PBXProj, sourceRoot: Path) throws {
        let target = try #require(proj.nativeTargets.first { $0.name == "App" })
        let phase = try #require(target.buildPhases.first { $0 is PBXResourcesBuildPhase })
        let resources = try #require(phase.files).compactMap(\.file)
        let paths = try resources.compactMap { try $0.fullPath(sourceRoot: sourceRoot) }
        #expect(Set(paths) == Set([
            sourceRoot + "Resources/Base.lproj/LaunchScreen.storyboard",
            sourceRoot + "Resources/Base.lproj/Views/Panel.xib",
            // Groups without a Base variant retain their existing directory fallback.
            sourceRoot + "Resources",
        ]))
    }
}
