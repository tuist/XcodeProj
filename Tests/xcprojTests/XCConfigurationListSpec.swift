import Foundation
import XCTest
@testable import xcproj

final class XCConfigurationListSpec: XCTestCase {

    var subject: XCConfigurationList!

    override func setUp() {
        super.setUp()
        self.subject = XCConfigurationList(reference: "reference",
                                           buildConfigurations: ["12345"],
                                           defaultConfigurationName: "Debug")
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(XCConfigurationList.isa, "XCConfigurationList")
    }

    func test_plistKeyAndValue() {
        let proj = PBXProj(archiveVersion: 1, objectVersion: 1, rootObject: "")
        proj.projects = [PBXProject.init(name: "App", reference: "", buildConfigurationList: "reference", compatibilityVersion: "47", mainGroup: "")]
        let (commentedString, _) = subject.plistKeyAndValue(proj: proj)
        XCTAssertEqual(commentedString, CommentedString("reference", comment: "Build configuration list for PBXProject \"App\""))
    }
}
