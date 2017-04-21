import Foundation
import XCTest

@testable import xcodeproj

final class PBXProjSpec: XCTestCase {
    
    var project: PBXProj!
    
    override func setUp() {
        super.setUp()
        project = try! PBXProj(dictionary: iosProjectDictionary())
    }
    
    func test_initWithDictionary_hasTheCorrectArchiveVersion() {
        XCTAssertEqual(project.archiveVersion, 1)
    }
    
    func test_initWithDictionary_hasTheCorrectObjectVersion() {
        XCTAssertEqual(project.objectVersion, 46)
    }
    
    func test_initWithDictionary_hasTheCorrectClasses() throws {
        XCTAssertTrue(project.classes.isEmpty)
    }
    
}
