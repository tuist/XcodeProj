@testable import xcodeproj
import XCTest

final class PBXProjectTests: XCTestCase {
    func test_attributes() throws {
        let target = PBXTarget(name: "")
        target.reference.fix("app")

        let testTarget = PBXTarget(name: "")
        testTarget.reference.fix("test")

        let project = PBXProject(name: "",
                                 buildConfigurationList: XCConfigurationList(),
                                 compatibilityVersion: "",
                                 mainGroup: PBXGroup(),
                                 attributes: ["LastUpgradeCheck": "0940"],
                                 targetAttributes: [target: ["TestTargetID": "123"]])

        project.setTargetAttributes(["custom": "abc", "TestTargetID": testTarget], target: target)

        let plist = try project.plistKeyAndValue(proj: PBXProj(), reference: "")
        let attributes = plist.value.dictionary?["attributes"]?.dictionary ?? [:]

        let expectedAttributes: [CommentedString: PlistValue] = [
            "LastUpgradeCheck": "0940",
            "TargetAttributes": ["app": [
                "custom": "abc",
                "TestTargetID": "test",
            ]],
        ]
        XCTAssertEqual(attributes, expectedAttributes)
    }
}
