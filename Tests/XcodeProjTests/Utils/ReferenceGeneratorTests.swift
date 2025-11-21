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
        let pluginDependency = project.makePluginDependency()
        let (target, _) = project.makeTarget(productReferenceProxy: productReferenceProxy)
        target.dependencies.append(pluginDependency)

        pbxProject.projectReferences.append(["ProductGroup": productsGroup.reference,
                                             "ProjectRef": remoteProjectFileReference.reference])
        pbxProject.targets.append(target)

        let referenceGenerator = ReferenceGenerator(outputSettings: PBXOutputSettings())
        try referenceGenerator.generateReferences(proj: project)

        XCTAssert(!productsGroup.reference.temporary)
        XCTAssert(!containerItemProxy.reference.temporary)
        XCTAssert(!productReferenceProxy.reference.temporary)
        XCTAssert(!remoteProjectFileReference.reference.temporary)
        XCTAssert(!pluginDependency.productReference!.temporary)
    }

    func test_projectReferencingRemoteXcodeprojBundle_generatesDeterministicIdentifiers() throws {
        func generateProject() throws -> [String] {
            let project = PBXProj(rootObject: nil, objectVersion: 0, archiveVersion: 0, classes: [:], objects: [])
            let pbxProject = project.makeProject()
            let remoteProjectFileReference = project.makeFileReference()
            let containerItemProxy = project.makeContainerItemProxy(fileReference: remoteProjectFileReference)
            let productReferenceProxy = project.makeReferenceProxy(containerItemProxy: containerItemProxy)
            let productsGroup = project.makeProductsGroup(children: [productReferenceProxy])
            let pluginDependency = project.makePluginDependency()
            let (target, buildFile) = project.makeTarget(productReferenceProxy: productReferenceProxy)
            target.dependencies.append(pluginDependency)

            pbxProject.projectReferences.append(["ProductGroup": productsGroup.reference,
                                                 "ProjectRef": remoteProjectFileReference.reference])
            pbxProject.targets.append(target)

            let referenceGenerator = ReferenceGenerator(outputSettings: PBXOutputSettings())
            try referenceGenerator.generateReferences(proj: project)

            return [remoteProjectFileReference, containerItemProxy, productReferenceProxy, productsGroup, buildFile, pluginDependency.productReference!.getObject()!]
                .map(\.reference.value)
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

    func test_projectWithFilesystemSynchronizedRootGroup_convertsReferencesToPermanent() throws {
        let project = PBXProj(rootObject: nil, objectVersion: 0, archiveVersion: 0, classes: [:], objects: [])
        let pbxProject = project.makeProject()

        let syncedGroup = project.makeSynchronizedRootGroup()
        let target = project.makeTarget()
        target.fileSystemSynchronizedGroups = [syncedGroup]
        pbxProject.targets.append(target)

        let referenceGenerator = ReferenceGenerator(outputSettings: PBXOutputSettings())
        try referenceGenerator.generateReferences(proj: project)

        XCTAssert(!syncedGroup.reference.temporary)
    }
    
    func test_projectWithFilesystemSynchronizedRootGroupWithExceptions_convertsReferencesToPermanent() throws {
        let project = PBXProj(rootObject: nil, objectVersion: 0, archiveVersion: 0, classes: [:], objects: [])
        let pbxProject = project.makeProject()

        let target = project.makeTarget()
        pbxProject.targets.append(target)
        
        let buildFileException = PBXFileSystemSynchronizedBuildFileExceptionSet(
            target: target,
            membershipExceptions: ["Info.plist"],
            publicHeaders: nil,
            privateHeaders: nil,
            additionalCompilerFlagsByRelativePath: nil,
            attributesByRelativePath: nil
        )
        project.add(object: buildFileException)
        
        let syncedGroup = project.makeSynchronizedRootGroup(exceptions: [buildFileException])
        target.fileSystemSynchronizedGroups = [syncedGroup]

        let referenceGenerator = ReferenceGenerator(outputSettings: PBXOutputSettings())
        try referenceGenerator.generateReferences(proj: project)

        XCTAssert(!syncedGroup.reference.temporary, "Synced group reference should not be temporary")
        XCTAssert(!buildFileException.reference.temporary, "Build file exception reference should not be temporary")
        XCTAssertFalse(buildFileException.reference.value.hasPrefix("TEMP_"), "Build file exception reference should not have TEMP_ prefix")
    }
    
    func test_projectWithFilesystemSynchronizedRootGroupWithBuildPhaseException_convertsReferencesToPermanent() throws {
        let project = PBXProj(rootObject: nil, objectVersion: 0, archiveVersion: 0, classes: [:], objects: [])
        let pbxProject = project.makeProject()

        let target = project.makeTarget()
        pbxProject.targets.append(target)
        
        let buildPhase = PBXSourcesBuildPhase()
        project.add(object: buildPhase)
        target.buildPhases.append(buildPhase)
        
        let buildPhaseException = PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet(
            buildPhase: buildPhase,
            membershipExceptions: ["ExcludedFile.swift"],
            attributesByRelativePath: nil
        )
        project.add(object: buildPhaseException)
        
        let syncedGroup = project.makeSynchronizedRootGroup(exceptions: [buildPhaseException])
        target.fileSystemSynchronizedGroups = [syncedGroup]

        let referenceGenerator = ReferenceGenerator(outputSettings: PBXOutputSettings())
        try referenceGenerator.generateReferences(proj: project)

        XCTAssert(!syncedGroup.reference.temporary, "Synced group reference should not be temporary")
        XCTAssert(!buildPhaseException.reference.temporary, "Build phase exception reference should not be temporary")
        XCTAssertFalse(buildPhaseException.reference.value.hasPrefix("TEMP_"), "Build phase exception reference should not have TEMP_ prefix")
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
                                 preferredProjectObjectVersion: nil,
                                 minimizedProjectReferenceProxies: nil,
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

    func makePluginDependency() -> PBXTargetDependency {
        let packageReference = XCRemoteSwiftPackageReference(repositoryURL: "repository")
        let packageDependency = XCSwiftPackageProductDependency(productName: "product", package: packageReference, isPlugin: true)
        let targetDependency = PBXTargetDependency(product: packageDependency)
        add(object: targetDependency.productReference!.getObject()!)

        return targetDependency
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

    func makeTarget() -> PBXTarget {
        let target = PBXNativeTarget(name: "MyApp",
                                     productName: "MyApp.app",
                                     productType: .application)
        add(object: target)
        return target
    }

    func makeSynchronizedRootGroup(exceptions: [PBXFileSystemSynchronizedExceptionSet] = []) -> PBXFileSystemSynchronizedRootGroup {
        let syncedGroup = PBXFileSystemSynchronizedRootGroup(
            sourceTree: .group,
            path: "SyncedPath",
            name: "SyncedGroup",
            exceptions: exceptions
        )
        add(object: syncedGroup)
        rootObject!.mainGroup.children.append(syncedGroup)
        return syncedGroup
    }
}
