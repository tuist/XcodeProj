import Foundation
import XCTest
import PathKit

@testable import xcodeproj

final class XCWorkspaceDataSpec: XCTestCase {

    var subject: XCWorkspaceData!
    var fileRef: XCWorkspaceData.FileRef!
    
    override func setUp() {
        super.setUp()
        fileRef = "path"
        subject = XCWorkspaceData(path: Path("test"), references: [])
    }
    
    
    func test_equal_returnsTheCorrectValue() {
        let another = XCWorkspaceData(path: Path("test"), references: [])
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
}
