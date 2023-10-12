import Foundation
import PathKit
import XcodeProj

func fixturesPath() -> Path {
    Path(#file).parent().parent().parent().parent() + "Fixtures"
}

func iosProjectDictionary() -> (Path, [String: Any]) {
    let iosProject = fixturesPath() + "iOS/Project.xcodeproj/project.pbxproj"
    return (iosProject, loadPlist(path: iosProject.string)!)
}

func fileSharedAcrossTargetsDictionary() -> (Path, [String: Any]) {
    let fileSharedAcrossTargetsProject = fixturesPath() + "FileSharedAcrossTargets/FileSharedAcrossTargets.xcodeproj/project.pbxproj"
    return (fileSharedAcrossTargetsProject, loadPlist(path: fileSharedAcrossTargetsProject.string)!)
}


func targetWithCustomBuildRulesDictionary() -> (Path, [String: Any]) {
    let targetWithCustomBuildRulesProject = fixturesPath() + "TargetWithCustomBuildRules/TargetWithCustomBuildRules.xcodeproj/project.pbxproj"
    return (targetWithCustomBuildRulesProject, loadPlist(path: targetWithCustomBuildRulesProject.string)!)
}

func iosProjectWithXCLocalSwiftPackageReference() -> (Path, [String: Any]) {
    let iosProjectWithXCLocalSwiftPackageReference = fixturesPath() + "iOS/ProjectWithXCLocalSwiftPackageReference.xcodeproj/project.pbxproj"
    return (iosProjectWithXCLocalSwiftPackageReference, loadPlist(path: iosProjectWithXCLocalSwiftPackageReference.string)!)
}

func iosProjectWithRelativeXCLocalSwiftPackageReferences() -> (Path, [String: Any]) {
    let iosProjectWithXCLocalSwiftPackageReference = fixturesPath() + "iOS/ProjectWithRelativeXCLocalSwiftPackageReference/ProjectWithRelativeXCLocalSwiftPackageReference.xcodeproj/project.pbxproj"
    return (iosProjectWithXCLocalSwiftPackageReference, loadPlist(path: iosProjectWithXCLocalSwiftPackageReference.string)!)
}

func iosProjectWithXCLocalSwiftPackageReferences() -> (Path, [String: Any]) {
    let iosProjectWithXCLocalSwiftPackageReference = fixturesPath() + "iOS/ProjectWithXCLocalSwiftPackageReferences.xcodeproj/project.pbxproj"
    return (iosProjectWithXCLocalSwiftPackageReference, loadPlist(path: iosProjectWithXCLocalSwiftPackageReference.string)!)
}
