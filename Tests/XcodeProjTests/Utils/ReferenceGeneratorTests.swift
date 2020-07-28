import Foundation
import PathKit
import XCTest
@testable import XcodeProj

class ReferenceGeneratorTests: XCTestCase {
    func test_projectReferencingRemoteXcodeprojBundle_convertsReferencesToPermanent() throws {
        let project = PBXProj(rootObject: nil, objectVersion: 0, archiveVersion: 0, classes: [:], objects: [])
        let pbxProject = project.makeProject()
        let remoteProjectFileReference = project.makeFileReference()
        let containerItemProxy = project.makeContainerItemProxy(fileReference: remoteProjectFileReference)
        let productReferenceProxy = project.makeReferenceProxy(containerItemProxy: containerItemProxy)
        let productsGroup = project.makeProductsGroup(children: [productReferenceProxy])

        pbxProject.projectReferences.append(["ProductGroup": productsGroup.reference,
                                             "ProjectRef": remoteProjectFileReference.reference])

        let referenceGenerator = ReferenceGenerator(outputSettings: PBXOutputSettings())
        try referenceGenerator.generateReferences(proj: project)

        XCTAssert(!productsGroup.reference.temporary)
        XCTAssert(!containerItemProxy.reference.temporary)
        XCTAssert(!productReferenceProxy.reference.temporary)
        XCTAssert(!remoteProjectFileReference.reference.temporary)
    }

    func test_projectReferencingRemoteXcodeprojBundle_generatesDeterministicIdentifiers() throws {
        func generateProject() throws -> [String] {
            let project = PBXProj(rootObject: nil, objectVersion: 0, archiveVersion: 0, classes: [:], objects: [])
            let pbxProject = project.makeProject()
            let remoteProjectFileReference = project.makeFileReference()
            let containerItemProxy = project.makeContainerItemProxy(fileReference: remoteProjectFileReference)
            let productReferenceProxy = project.makeReferenceProxy(containerItemProxy: containerItemProxy)
            let productsGroup = project.makeProductsGroup(children: [productReferenceProxy])
            let (target, buildFile) = project.makeTarget(productReferenceProxy: productReferenceProxy)

            pbxProject.projectReferences.append(["ProductGroup": productsGroup.reference,
                                                 "ProjectRef": remoteProjectFileReference.reference])
            pbxProject.targets.append(target)

            let referenceGenerator = ReferenceGenerator(outputSettings: PBXOutputSettings())
            try referenceGenerator.generateReferences(proj: project)

            return [remoteProjectFileReference, containerItemProxy, productReferenceProxy, productsGroup, buildFile]
                .map { $0.reference.value }
        }

        let firstUUIDs = try generateProject()
        let secondUUIDs = try generateProject()

        XCTAssertEqual(Set(firstUUIDs), Set(secondUUIDs))
    }

    func test_twoProjectsReferencingTwoDifferentRemoteXcodeprojBundles_generatesDifferentProductGroupIdentifiers() throws {
        func generateProject(remoteProjectPath: String) throws -> String {
            let project = PBXProj(rootObject: nil, objectVersion: 0, archiveVersion: 0, classes: [:], objects: [])
            let pbxProject = project.makeProject()
            let remoteProjectFileReference = project.makeFileReference(with: Path(remoteProjectPath))
            let containerItemProxy = project.makeContainerItemProxy(fileReference: remoteProjectFileReference)
            let productReferenceProxy = project.makeReferenceProxy(containerItemProxy: containerItemProxy)
            let productsGroup = project.makeProductsGroup(children: [productReferenceProxy])
            let (target, _) = project.makeTarget(productReferenceProxy: productReferenceProxy)

            pbxProject.projectReferences.append(["ProductGroup": productsGroup.reference,
                                                 "ProjectRef": remoteProjectFileReference.reference])
            pbxProject.targets.append(target)

            let referenceGenerator = ReferenceGenerator(outputSettings: PBXOutputSettings())
            try referenceGenerator.generateReferences(proj: project)

            return productsGroup.reference.value
        }

        let firstProductsGroupUUID = try generateProject(remoteProjectPath: "../Remote1.xcodeproj")
        let secondProductsGroupUUID = try generateProject(remoteProjectPath: "../Remote2.xcodeproj")

        XCTAssertNotEqual(firstProductsGroupUUID, secondProductsGroupUUID)
    }
}

private extension PBXProj {
    func makeProject() -> PBXProject {
        let mainGroup = PBXGroup(children: [],
                                 sourceTree: .group,
                                 name: "Main")

        let project = PBXProject(name: "test",
                                 buildConfigurationList: XCConfigurationList.fixture(),
                                 compatibilityVersion: Xcode.Default.compatibilityVersion,
                                 mainGroup: mainGroup)

        add(object: mainGroup)
        add(object: project)
        rootObject = project

        return project
    }

    func makeFileReference() -> PBXFileReference {
        makeFileReference(with: Path("../Remote.xcodeproj"))
    }

    func makeFileReference(with path: Path) -> PBXFileReference {
        try! rootObject!.mainGroup.addFile(at: path, sourceRoot: Path("/"), validatePresence: false)
    }

    func makeContainerItemProxy(fileReference: PBXFileReference) -> PBXContainerItemProxy {
        let containerItemProxy = PBXContainerItemProxy(containerPortal: .fileReference(fileReference),
                                                       remoteGlobalID: .string("remoteTargetGlobalIDString"),
                                                       proxyType: .reference,
                                                       remoteInfo: "RemoteTarget")

        add(object: containerItemProxy)

        return containerItemProxy
    }

    func makeReferenceProxy(containerItemProxy: PBXContainerItemProxy) -> PBXReferenceProxy {
        let productReferenceProxy = PBXReferenceProxy(fileType: "wrapper.pb-project",
                                                      path: "Remote.framework",
                                                      remote: containerItemProxy,
                                                      sourceTree: .buildProductsDir)
        add(object: productReferenceProxy)
        return productReferenceProxy
    }

    func makeProductsGroup(children: [PBXFileElement]) -> PBXGroup {
        let productsGroup = PBXGroup(children: children,
                                     sourceTree: .group,
                                     name: "Products")
        add(object: productsGroup)
        return productsGroup
    }

    func makeTarget(productReferenceProxy: PBXReferenceProxy) -> (target: PBXTarget, buildFile: PBXBuildFile) {
        let buildFile = PBXBuildFile(file: productReferenceProxy)
        add(object: buildFile)

        let buildPhase = PBXCopyFilesBuildPhase(dstPath: "",
                                                dstSubfolderSpec: .frameworks,
                                                name: "Embed Frameworks",
                                                files: [buildFile])
        add(object: buildPhase)

        let target = PBXNativeTarget(name: "MyApp",
                                     buildPhases: [buildPhase],
                                     productName: "MyApp.app",
                                     productType: .application)
        add(object: target)

        return (target, buildFile)
    }
}
