import Foundation
import PathKit
import XcodeProj
import XCTest

class DictionaryExtrasTests: XCTestCase {
    var fixtures: Path!

    override func setUp() {
        super.setUp()
        fixtures = Path(#file).parent().parent().parent().parent() + "Fixtures"
    }

    func test_loadPlist_returnsANilValue_whenTheFileDoesntExist() {
        XCTAssertNil(loadPlist(path: "test"))
    }

    func test_loadPlist_returnsTheDictionary_whenTheFileDoesExist() {
        let iosProject = fixtures + "iOS/Project.xcodeproj/project.pbxproj"
        XCTAssertNotNil(loadPlist(path: iosProject.string))
    }
}
