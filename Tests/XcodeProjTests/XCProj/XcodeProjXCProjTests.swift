import Foundation
import PathKit
import Testing
@testable import XcodeProj

/// Checks that `XcodeProj` opens and writes `.xcodeproj` bundles that store the project as JSON.
@Suite struct XcodeProjXCProjTests {
    private let temporaryDirectory: Path

    init() throws {
        temporaryDirectory = try Path.uniqueTemporary()
    }

    @Test func openDetectsTheJSONFormat() throws {
        let subject = try XcodeProj(path: everythingProjectPath)
        #expect(subject.projectFormat == .xcproj)
        #expect(subject.pbxproj.rootObject?.targets.map(\.name) == ["App", "Tool", "All", "Make"])
    }

    @Test func openDetectsThePropertyListFormat() throws {
        let subject = try XcodeProj(path: fixturesPath() + "iOS/Project.xcodeproj")
        #expect(subject.projectFormat == .pbxproj)
    }

    @Test func openReportsAMissingProjectFile() throws {
        let empty = temporaryDirectory + "Empty.xcodeproj"
        try empty.mkpath()
        #expect(throws: (any Error).self) {
            try XcodeProj(path: empty)
        }
    }

    @Test func writeKeepsTheFormatItWasReadIn() throws {
        let subject = try XcodeProj(path: everythingProjectPath)
        let destination = temporaryDirectory + "Everything.xcodeproj"
        try subject.write(path: destination)

        #expect((destination + "project.xcproj").exists)
        #expect(!(destination + "project.pbxproj").exists)

        // Writing an unchanged project back must not touch the file.
        #expect(
            try Data(contentsOf: (destination + "project.xcproj").url)
                == Data(contentsOf: everythingXCProjPath.url)
        )
    }

    @Test func writeConvertsAPropertyListProjectToJSON() throws {
        let subject = try XcodeProj(path: fixturesPath() + "iOS/Project.xcodeproj")
        let destination = temporaryDirectory + "Converted.xcodeproj"
        try subject.write(path: destination, format: .xcproj)

        #expect((destination + "project.xcproj").exists)
        #expect(!(destination + "project.pbxproj").exists)

        let reopened = try XcodeProj(path: destination)
        #expect(reopened.projectFormat == .xcproj)
        #expect(reopened.pbxproj.rootObject?.targets.map(\.name) == subject.pbxproj.rootObject?.targets.map(\.name))
    }

    @Test func writeConvertsAJSONProjectToAPropertyList() throws {
        let subject = try XcodeProj(path: everythingProjectPath)
        let destination = temporaryDirectory + "Converted.xcodeproj"
        try subject.write(path: destination, format: .pbxproj)

        #expect((destination + "project.pbxproj").exists)
        #expect(!(destination + "project.xcproj").exists)

        let reopened = try XcodeProj(path: destination)
        #expect(reopened.projectFormat == .pbxproj)
        #expect(reopened.pbxproj.rootObject?.targets.map(\.name) == ["App", "Tool", "All", "Make"])
    }

    @Test func projectFormatFileNames() {
        #expect(ProjectFormat.pbxproj.fileName == "project.pbxproj")
        #expect(ProjectFormat.xcproj.fileName == "project.xcproj")
        #expect(XcodeProj.xcprojPath(Path("/tmp/A.xcodeproj")) == Path("/tmp/A.xcodeproj/project.xcproj"))
    }
}
