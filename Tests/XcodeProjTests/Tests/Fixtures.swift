import Foundation
import PathKit
@testable import XcodeProj

func fixturesPath() -> Path {
    Path(#file).parent().parent().parent().parent() + "Fixtures"
}

func synchronizedRootGroupsFixture() throws -> Data {
    let synchronizedRootGroups = fixturesPath() + "SynchronizedRootGroups/SynchronizedRootGroups.xcodeproj/project.pbxproj"
    return try Data(contentsOf: synchronizedRootGroups.url)
}

func iosProjectData() throws -> Data {
    let iosProject = fixturesPath() + "iOS/Project.xcodeproj/project.pbxproj"
    return try Data(contentsOf: iosProject.url)
}

func fileSharedAcrossTargetsData() throws -> Data {
    let fileSharedAcrossTargetsProject = fixturesPath() + "FileSharedAcrossTargets/FileSharedAcrossTargets.xcodeproj/project.pbxproj"
    return try Data(contentsOf: fileSharedAcrossTargetsProject.url)
}

func targetWithCustomBuildRulesData() throws -> Data {
    let targetWithCustomBuildRulesProject = fixturesPath() + "TargetWithCustomBuildRules/TargetWithCustomBuildRules.xcodeproj/project.pbxproj"
    return try Data(contentsOf: targetWithCustomBuildRulesProject.url)
}

func iosProjectWithXCLocalSwiftPackageReference() throws -> Data {
    let iosProjectWithXCLocalSwiftPackageReference = fixturesPath() + "iOS/ProjectWithXCLocalSwiftPackageReference.xcodeproj/project.pbxproj"
    return try Data(contentsOf: iosProjectWithXCLocalSwiftPackageReference.url)
}

func iosProjectWithRelativeXCLocalSwiftPackageReferences() throws -> Data {
    let iosProjectWithXCLocalSwiftPackageReference = fixturesPath() + "iOS/ProjectWithRelativeXCLocalSwiftPackageReference/ProjectWithRelativeXCLocalSwiftPackageReference.xcodeproj/project.pbxproj"
    return try Data(contentsOf: iosProjectWithXCLocalSwiftPackageReference.url)
}

func iosProjectWithXCLocalSwiftPackageReferences() throws -> Data {
    let iosProjectWithXCLocalSwiftPackageReference = fixturesPath() + "iOS/ProjectWithXCLocalSwiftPackageReferences.xcodeproj/project.pbxproj"
    return try Data(contentsOf: iosProjectWithXCLocalSwiftPackageReference.url)
}
