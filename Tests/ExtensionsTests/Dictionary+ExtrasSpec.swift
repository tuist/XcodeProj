import Foundation
import Spectre
import PathKit
import XCTest

@testable import xcodeproj

class DictionaryExtrasSpec: XCTestCase {
    
    var fixtures: Path!
    
    override func setUp() {
        super.setUp()
        fixtures = Path(#file).parent().parent().parent() + Path("Fixtures")
    }
    
    func test_loadPlist_returnsANilValue_whenTheFileDoesntExist() {
        XCTAssertNil(loadPlist(path: "test"))
    }
    
    func test_loadPlist_returnsTheDictionary_whenTheFileDoesExist() {
        let iosProject = fixtures + Path("iOS/Project.xcodeproj/project.pbxproj")
        XCTAssertNotNil(loadPlist(path: iosProject.absolute().string))
    }
}

