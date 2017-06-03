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
        let fixtures = Path(#file).parent().parent().parent() + Path("Fixtures")
        let path = fixtures + Path("iOS/Project.xcodeproj/project.xcworkspace/contents.xcworkspacedata")
        let got = try? XCWorkspace.Data(path: path)
        XCTAssertEqual(got?.path, path)
        XCTAssertNotNil(got?.references.first?.project)
    }
    
    func test_integration_init_throwsIfThePathIsWrong() {
        do {
            _ = try XCWorkspace.Data(path: Path("test"))
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
}
