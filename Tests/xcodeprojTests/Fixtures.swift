import Foundation
import PathKit
import xcodeprojextensions

func iosProjectDictionary() -> (Path, Dictionary<String, Any>) {
    let fixtures = Path(#file).parent().parent().parent() + Path("Fixtures")
    let iosProject = fixtures + Path("iOS/Project.xcodeproj/project.pbxproj")
    return (iosProject, loadPlist(path: iosProject.absolute().string)!)
}
