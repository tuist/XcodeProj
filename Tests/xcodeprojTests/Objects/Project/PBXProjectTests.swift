import XCTest
@testable import XcodeProj

final class PBXProjectTests: XCTestCase {
    func test_attributes() throws {
        // Given
        let target = PBXTarget(name: "")
        target.reference.fix("app")

        let testTarget = PBXTarget(name: "")
        testTarget.reference.fix("test")
        let pbxproj = PBXProj()
        let mainGroup = PBXGroup()
        let project = PBXProject(name: "",
                                 buildConfigurationList: XCConfigurationList(),
                                 compatibilityVersion: "",
                                 mainGroup: mainGroup,
                                 attributes: ["LastUpgradeCheck": "0940"],
                                 targetAttributes: [target: ["TestTargetID": "123"]])
        project.setTargetAttributes(["custom": "abc", "TestTargetID": testTarget], target: target)

        // When
        let plist = project.plistKeyAndValue(proj: pbxproj, reference: "")
        let attributes = plist.value.dictionary?["attributes"]?.dictionary ?? [:]

        // Then
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
