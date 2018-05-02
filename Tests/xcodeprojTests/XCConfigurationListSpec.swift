import Foundation
import XCTest
@testable import xcodeproj

final class XCConfigurationListSpec: XCTestCase {

    var subject: XCConfigurationList!

    override func setUp() {
        super.setUp()
        self.subject = XCConfigurationList(buildConfigurations: ["12345"],
                                           defaultConfigurationName: "Debug")
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(XCConfigurationList.isa, "XCConfigurationList")
    }

    func test_plistKeyAndValue() {
        let proj = PBXProj(rootObject: "", objectVersion: 1, archiveVersion: 1)
        proj.objects.projects = ["ref": PBXProject.init(name: "App", buildConfigurationList: "reference", compatibilityVersion: "47", mainGroup: "")]
        let (commentedString, _) = subject.plistKeyAndValue(proj: proj, reference: "reference")
        XCTAssertEqual(commentedString, CommentedString("reference", comment: "Build configuration list for PBXProject \"App\""))
    }
}
