import Foundation
import XCTest
import PathKit

@testable import xcodeproj

final class XCWorkspaceDataSpec: XCTestCase {

    var subject: XCWorkspace.Data!
    var fileRef: XCWorkspace.Data.FileRef!
    
    override func setUp() {
        super.setUp()
        fileRef = "path"
        subject = XCWorkspace.Data(path: Path("test"), references: [])
    }
    
    
    func test_equal_returnsTheCorrectValue() {
        let another = XCWorkspace.Data(path: Path("test"), references: [])
        XCTAssertEqual(subject, another)
    }
    
    func test_addingReference_returnsANewWorkspaceDatawithTheReferenceAdded() {
        let got = subject.adding(reference: "path2")
        XCTAssertTrue(got.references.contains("path2"))
    }
    
    func test_removingReference_returnsANewWorkspaceDataWithTheReferenceRemoved() {
        let got = subject.removing(reference: "path")
        XCTAssertFalse(got.references.contains("path"))
    }
    
    // MARK: - Integration
    
    func test_integration_init_returnsTheModelWithTheRightProperties() {
        
    }
}
