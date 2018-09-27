@testable import xcodeproj
import XCTest

final class PBXProjectTests: XCTestCase {

    func test_attributes() throws {
        let target = PBXTarget(name: "")
        target.reference.fix("test")

        let project = PBXProject(name: "",
                                 buildConfigurationList: XCConfigurationList(),
                                 compatibilityVersion: "",
                                 mainGroup: PBXGroup(),
                                 attributes: ["LastUpgradeCheck": "0940"],
                                 targetAttributes: [target: ["TestTargetID": "123"]])

        project.setTargetAttributes(["custom": "abc"], target: target)

        let plist = try project.plistKeyAndValue(proj: PBXProj(), reference: "")
        let attributes = plist.value.dictionary?["attributes"]?.dictionary ?? [:]

        let expectedAttributes: [CommentedString: PlistValue] = [
            "LastUpgradeCheck": "0940",
            "TargetAttributes": ["test": [
                "custom": "abc",
            ]],
        ]
        XCTAssertEqual(attributes, expectedAttributes)
    }
}
