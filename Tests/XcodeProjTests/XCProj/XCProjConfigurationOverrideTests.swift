import PathKit
import Testing
@testable import XcodeProj

/// Exercises default/override collisions through an on-disk project, including both output formats.
@Suite struct XCProjConfigurationOverrideTests {
    private let fixture = fixturesPath() + "XCProj/ConfigurationOverrides.xcodeproj"

    @Test func decodePreservesConfigurationOverrides() throws {
        let project = try XcodeProj(path: fixture)
        #expect(project.projectFormat == .xcproj)
        try expectBuildSettings(project.pbxproj)
    }

    @Test(arguments: [ProjectFormat.xcproj, .pbxproj])
    func roundTripPreservesConfigurationOverrides(format: ProjectFormat) throws {
        let project = try XcodeProj(path: fixture)
        let temporary = try Path.uniqueTemporary()
        defer { try? temporary.delete() }
        let destination = temporary + "Converted.xcodeproj"
        try project.write(path: destination, format: format)
        let reopened = try XcodeProj(path: destination)
        #expect(reopened.projectFormat == format)

        // Encoding can replace a default plus an override with explicit per-configuration
        // settings, so compare their meaning rather than requiring identical JSON bytes.
        try expectBuildSettings(reopened.pbxproj)
    }

    private func expectBuildSettings(_ proj: PBXProj) throws {
        let project = try #require(proj.rootObject)
        let target = try #require(project.targets.first { $0.name == "App" })
        let targetConfigurations = try #require(target.buildConfigurationList)
        let condition = "[sdk=iphoneos*][arch=arm64]"
        for name in ["Debug", "Release", "Profile"] {
            let projectConfig = try #require(project.buildConfigurationList.buildConfigurations.first { $0.name == name })
            let targetConfig = try #require(targetConfigurations.buildConfigurations.first { $0.name == name })
            #expect(projectConfig.buildSettings["SWIFT_OPTIMIZATION_LEVEL"] == .string(name == "Debug" ? "-Onone" : "-O"))
            #expect(projectConfig.buildSettings["GCC_PREPROCESSOR_DEFINITIONS" + condition]
                == .array(name == "Debug" ? ["DEBUG=1", "TRACE=1"] : ["DEFAULT=1"]))
            #expect(targetConfig.buildSettings["INFOPLIST_FILE"]
                == .string("Config/\(name == "Release" ? "Base" : name).plist"))
            #expect(targetConfig.buildSettings["OTHER_SWIFT_FLAGS" + condition]
                == .array(name == "Debug" ? ["-DDEBUG", "-DTRACE"] : ["-DDEFAULT"]))
        }
    }
}
