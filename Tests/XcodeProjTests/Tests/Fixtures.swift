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

func withCorruptWorkspaceDataPath() -> Path {
    fixturesPath() + "WithCorruptWorkspace/WithCorruptWorkspace.xcodeproj/project.xcworkspace/contents.xcworkspacedata"
}

func targetWithCustomBuildRulesDictionary() -> (Path, [String: Any]) {
    let targetWithCustomBuildRulesProject = fixturesPath() + "TargetWithCustomBuildRules/TargetWithCustomBuildRules.xcodeproj/project.pbxproj"
    return (targetWithCustomBuildRulesProject, loadPlist(path: targetWithCustomBuildRulesProject.string)!)
}
