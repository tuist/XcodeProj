import Foundation
import PathKit
import xcodeproj

func fixturesPath() -> Path {
    return Path(#file).parent().parent().parent().parent() + "Fixtures"
}

func iosProjectDictionary() -> (Path, [String: Any]) {
    let iosProject = fixturesPath() + "iOS/Project.xcodeproj/project.pbxproj"
    return (iosProject, loadPlist(path: iosProject.string)!)
}
