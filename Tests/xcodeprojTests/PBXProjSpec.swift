import Foundation
import XCTest
import PathKit

@testable import xcodeproj

final class PBXProjSpec: XCTestCase {
    
    var project: PBXProj!
    
    override func setUp() {
        super.setUp()
        let (path, dictionary) = iosProjectDictionary()
        project = try! PBXProj(path: path, dictionary: dictionary)
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
