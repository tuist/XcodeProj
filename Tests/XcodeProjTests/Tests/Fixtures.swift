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
