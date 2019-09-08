import XCTest
@testable import XcodeProj

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
    
    func test_addLocalPackage() throws {
        // Given
        let objects = PBXObjects(objects: [])

        let buildPhase = PBXFrameworksBuildPhase(
            files: [],
            inputFileListPaths: nil,
            outputFileListPaths: nil, buildActionMask: PBXBuildPhase.defaultBuildActionMask,
            runOnlyForDeploymentPostprocessing: true
        )
        let target = PBXNativeTarget(name: "Target",
                                     buildConfigurationList: nil,
                                     buildPhases: [buildPhase])
        objects.add(object: target)
        
        let configurationList = XCConfigurationList.fixture()
        let mainGroup = PBXGroup.fixture()
        objects.add(object: configurationList)
        objects.add(object: mainGroup)

        let project = PBXProject(name: "Project",
                                 buildConfigurationList: configurationList,
                                 compatibilityVersion: "0",
                                 mainGroup: mainGroup,
                                 targets: [target])

        objects.add(object: project)
        
        // When
        let packageProduct = try project.addLocalSwiftPackage(path: "Product",
                                         productName: "Product",
                                         targetName: "Target")
        
        // Then
        let projectObjects = try project.objects()
        
        let buildFile = XCTAssertNotNilAndUnwrap(projectObjects.buildFiles.first)
        XCTAssertEqual(packageProduct, buildFile.value.product)
        
        let fileReference = XCTAssertNotNilAndUnwrap(projectObjects.fileReferences.first?.value)
        XCTAssertEqual(fileReference.name, "Product")
    }
}
