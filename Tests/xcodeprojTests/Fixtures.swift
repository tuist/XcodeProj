import Foundation
import PathKit

@testable import xcodeproj

func iosProjectDictionary() -> Dictionary<String, Any> {
    let fixtures = Path(#file).parent().parent().parent() + Path("Fixtures")
    let iosProject = fixtures + Path("iOS/Project.xcodeproj/project.pbxproj")
    return loadPlist(path: iosProject.absolute().string)!
}
