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
                                 preferredProjectObjectVersion: nil,
                                 minimizedProjectReferenceProxies: nil,
                                 mainGroup: PBXGroup(),
                                 attributes: ["LastUpgradeCheck": "0940"],
                                 targetAttributes: [target: ["TestTargetID": "123"]])

        project.setTargetAttributes(["custom": "abc", "TestTargetID": .targetReference(testTarget)], target: target)

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

    func test_attributes_writes_fixed_value_correctly() throws {
        let target = PBXTarget(name: "")
        target.reference.fix("app")

        let testTarget = PBXTarget(name: "")

        let project = PBXProject(name: "",
                                 buildConfigurationList: XCConfigurationList(),
                                 compatibilityVersion: "",
                                 preferredProjectObjectVersion: nil,
                                 minimizedProjectReferenceProxies: nil,
                                 mainGroup: PBXGroup(),
                                 attributes: ["LastUpgradeCheck": "0940"],
                                 targetAttributes: [target: ["TestTargetID": "123"]])

        project.setTargetAttributes(["custom": "abc", "TestTargetID": .targetReference(testTarget)], target: target)

        // When writing the project we need to account for any mutation of the object that may have occurred after being added to the project.
        testTarget.reference.fix("test")

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

    func test_plistKeyAndValue_returnsEmptyTargetAttributes_when_itsEmpty() throws {
        // Given
        let target = PBXTarget(name: "")
        target.reference.fix("app")

        let testTarget = PBXTarget(name: "")
        testTarget.reference.fix("test")

        let project = PBXProject(name: "Project",
                                 buildConfigurationList: XCConfigurationList(),
                                 compatibilityVersion: nil,
                                 preferredProjectObjectVersion: nil,
                                 minimizedProjectReferenceProxies: nil,
                                 mainGroup: PBXGroup())

        // When
        let plist = try project.plistKeyAndValue(proj: PBXProj(), reference: "")

        // Then
        let attributes = plist.value.dictionary?["attributes"]?.dictionary?["TargetAttributes"]?.dictionary
        XCTAssertEqual(attributes, [:])
    }

    func test_addLocalSwiftPackage() throws {
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
                                 preferredProjectObjectVersion: nil,
                                 minimizedProjectReferenceProxies: nil,
                                 mainGroup: mainGroup,
                                 targets: [target])

        objects.add(object: project)

        // When
        let packageProduct = try project.addLocalSwiftPackage(path: "Product",
                                                              productName: "Product",
                                                              targetName: target.name)

        // Then
        XCTAssertEqual(packageProduct, objects.buildFiles.first?.value.product)
        XCTAssertEqual(packageProduct, objects.swiftPackageProductDependencies.first?.value)
        XCTAssertEqual(packageProduct, target.packageProductDependencies?.first)

        XCTAssertEqual(objects.fileReferences.first?.value.name, "Product")

        XCTAssertEqual(objects.swiftPackageProductDependencies.first?.value, buildPhase.files?.first?.product)
    }

    func test_addLocalSwiftPackage_throws_frameworksPhaseError() {
        // Given
        let objects = PBXObjects(objects: [])

        let target = PBXNativeTarget(name: "Target")
        objects.add(object: target)

        let configurationList = XCConfigurationList.fixture()
        let mainGroup = PBXGroup.fixture()
        objects.add(object: configurationList)
        objects.add(object: mainGroup)

        let project = PBXProject(name: "Project",
                                 buildConfigurationList: configurationList,
                                 compatibilityVersion: "0",
                                 preferredProjectObjectVersion: nil,
                                 minimizedProjectReferenceProxies: nil,
                                 mainGroup: mainGroup,
                                 targets: [target])

        objects.add(object: project)

        // Then

        XCTAssertThrowsSpecificError(try project.addLocalSwiftPackage(path: "Product",
                                                                      productName: "Product",
                                                                      targetName: target.name),
                                     PBXProjError.frameworksBuildPhaseNotFound(targetName: target.name))
    }

    func test_removeRemotePackage() throws {
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
                                 preferredProjectObjectVersion: nil,
                                 minimizedProjectReferenceProxies: nil,
                                 mainGroup: mainGroup,
                                 targets: [target])

        objects.add(object: project)

        let _ = try project.addSwiftPackage(repositoryURL: "url",
                                            productName: "Product",
                                            versionRequirement: .branch("main"),
                                            targetName: "Target")

        // When
        project.remotePackages.removeFirst()

        // Then
        XCTAssert(project.remotePackages.isEmpty)
    }

    func test_addSwiftPackage() throws {
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
                                 preferredProjectObjectVersion: nil,
                                 minimizedProjectReferenceProxies: nil,
                                 mainGroup: mainGroup,
                                 targets: [target])

        objects.add(object: project)

        // When
        let remoteReference = try project.addSwiftPackage(repositoryURL: "url",
                                                          productName: "Product",
                                                          versionRequirement: .branch("main"),
                                                          targetName: "Target")

        // Then
        XCTAssertEqual(remoteReference, project.remotePackages.first)
        XCTAssertEqual(remoteReference, objects.remoteSwiftPackageReferences.first?.value)

        XCTAssertEqual(remoteReference, objects.buildFiles.first?.value.product?.package)
        XCTAssertEqual(objects.swiftPackageProductDependencies.first?.value, buildPhase.files?.first?.product)
    }

    func test_addSwiftPackage_duplication() throws {
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

        let secondBuildPhase = PBXFrameworksBuildPhase(
            files: [],
            inputFileListPaths: nil,
            outputFileListPaths: nil, buildActionMask: PBXBuildPhase.defaultBuildActionMask,
            runOnlyForDeploymentPostprocessing: true
        )
        let secondTarget = PBXNativeTarget(name: "SecondTarget",
                                           buildConfigurationList: nil,
                                           buildPhases: [secondBuildPhase])
        objects.add(object: secondTarget)

        let configurationList = XCConfigurationList.fixture()
        let mainGroup = PBXGroup.fixture()
        objects.add(object: configurationList)
        objects.add(object: mainGroup)

        let project = PBXProject(name: "Project",
                                 buildConfigurationList: configurationList,
                                 compatibilityVersion: "0",
                                 preferredProjectObjectVersion: nil,
                                 minimizedProjectReferenceProxies: nil,
                                 mainGroup: mainGroup,
                                 targets: [target, secondTarget])

        objects.add(object: project)

        // When
        let packageProduct = try project.addSwiftPackage(repositoryURL: "url",
                                                         productName: "Product",
                                                         versionRequirement: .branch("main"),
                                                         targetName: target.name)
        let secondPackageProduct = try project.addSwiftPackage(repositoryURL: "url",
                                                               productName: "Product",
                                                               versionRequirement: .branch("main"),
                                                               targetName: secondTarget.name)
        let thirdPackageProduct = try project.addSwiftPackage(repositoryURL: "url",
                                                              productName: "Product2",
                                                              versionRequirement: .branch("main"),
                                                              targetName: target.name)
        // Then
        XCTAssertEqual(packageProduct, secondPackageProduct)
        XCTAssertEqual(packageProduct, thirdPackageProduct)
        XCTAssertEqual(project.remotePackages.count, 1)
        XCTAssertEqual(target.packageProductDependencies?.count, 2)
        XCTAssertEqual(secondTarget.packageProductDependencies?.count, 1)
        XCTAssertNotEqual(buildPhase.files?.first?.hashValue, secondBuildPhase.files?.first?.hashValue)
        XCTAssertEqual(objects.swiftPackageProductDependencies.count, 2)

        XCTAssertThrowsSpecificError(try project.addSwiftPackage(repositoryURL: "url",
                                                                 productName: "Product",
                                                                 versionRequirement: .branch("second-main"),
                                                                 targetName: secondTarget.name),
                                     PBXProjError.multipleRemotePackages(productName: "Product"))

        XCTAssertThrowsSpecificError(try project.addSwiftPackage(repositoryURL: "url",
                                                                 productName: "Product2",
                                                                 versionRequirement: .branch("second-main"),
                                                                 targetName: target.name),
                                     PBXProjError.multipleRemotePackages(productName: "Product2"))
    }

    func test_addLocalSwiftPackage_duplication() throws {
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

        let secondBuildPhase = PBXFrameworksBuildPhase(
            files: [],
            inputFileListPaths: nil,
            outputFileListPaths: nil, buildActionMask: PBXBuildPhase.defaultBuildActionMask,
            runOnlyForDeploymentPostprocessing: true
        )
        let secondTarget = PBXNativeTarget(name: "SecondTarget",
                                           buildConfigurationList: nil,
                                           buildPhases: [secondBuildPhase])
        objects.add(object: secondTarget)

        let configurationList = XCConfigurationList.fixture()
        let mainGroup = PBXGroup.fixture()
        objects.add(object: configurationList)
        objects.add(object: mainGroup)

        let project = PBXProject(name: "Project",
                                 buildConfigurationList: configurationList,
                                 compatibilityVersion: "0",
                                 preferredProjectObjectVersion: nil,
                                 minimizedProjectReferenceProxies: nil,
                                 mainGroup: mainGroup,
                                 targets: [target, secondTarget])

        objects.add(object: project)

        // When
        let packageProduct = try project.addLocalSwiftPackage(path: "Product",
                                                              productName: "Product",
                                                              targetName: target.name)
        let secondPackageProduct = try project.addLocalSwiftPackage(path: "Product",
                                                                    productName: "Product",
                                                                    targetName: secondTarget.name)

        // Then
        XCTAssertEqual(packageProduct, secondPackageProduct)
        XCTAssertEqual(target.packageProductDependencies, secondTarget.packageProductDependencies)
        XCTAssertNotEqual(buildPhase.files?.first?.hashValue, secondBuildPhase.files?.first?.hashValue)
        XCTAssertEqual(objects.swiftPackageProductDependencies.count, 1)

        XCTAssertThrowsSpecificError(try project.addLocalSwiftPackage(path: "Sources/Product",
                                                                      productName: "Product",
                                                                      targetName: target.name),
                                     PBXProjError.multipleLocalPackages(productName: "Product"))
    }
}
