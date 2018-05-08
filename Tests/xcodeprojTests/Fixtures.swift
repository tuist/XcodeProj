import Basic
import Foundation
import xcodeproj

func fixturesPath() -> AbsolutePath {
    return AbsolutePath(#file).parentDirectory.parentDirectory.parentDirectory.appending(component: "Fixtures")
}

func iosProjectDictionary() -> (AbsolutePath, Dictionary<String, Any>) {
    let iosProject = fixturesPath().appending(RelativePath("iOS/Project.xcodeproj/project.pbxproj"))
    return (iosProject, loadPlist(path: iosProject.asString)!)
}
