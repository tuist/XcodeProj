import Basic
import Foundation
import xcodeproj
import XCTest

class DictionaryExtrasTests: XCTestCase {
    var fixtures: AbsolutePath!

    override func setUp() {
        super.setUp()
        fixtures = AbsolutePath(#file).parentDirectory.parentDirectory.parentDirectory.parentDirectory.appending(component: "Fixtures")
    }

    func test_loadPlist_returnsANilValue_whenTheFileDoesntExist() {
        XCTAssertNil(loadPlist(path: "test"))
    }

    func test_loadPlist_returnsTheDictionary_whenTheFileDoesExist() {
        let iosProject = fixtures.appending(RelativePath("iOS/Project.xcodeproj/project.pbxproj"))
        XCTAssertNotNil(loadPlist(path: iosProject.asString))
    }
}
