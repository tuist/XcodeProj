import Foundation
import PathKit
import xcodeproj

func fixturesPath() -> Path {
    return Path(#file).parent().parent().parent() + Path("Fixtures")
}

func iosProjectDictionary() -> (Path, Dictionary<String, Any>) {
    let iosProject = fixturesPath() + Path("iOS/Project.xcodeproj/project.pbxproj")
    return (iosProject, loadPlist(path: iosProject.absolute().string)!)
}
