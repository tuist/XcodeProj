
import XCTest
@testable import XcodeProj

class PBXOutputSettingsTests: XCTestCase {
    // MARK: - PBXFileOrder - PBXBuldFile

    func test_PBXFileOrder_PBXBuildFile_by_uuid_when_iosProject() throws {
        let iosProject = try iosProject()

        XCTAssertFalse(PBXFileOrder.byUUID.sort(lhs: iosProject.objectBuildFileAssets, rhs: iosProject.objectBuildFileMain))
        XCTAssertTrue(PBXFileOrder.byUUID.sort(lhs: iosProject.objectBuildFileMain, rhs: iosProject.objectBuildFileAssets))
    }

    func test_PBXFileOrder_PBXBuildFile_by_filename_when_iosProject() throws {
        let iosProject = try iosProject()

        XCTAssertTrue(PBXFileOrder.byFilename.sort(lhs: iosProject.objectBuildFileAssets, rhs: iosProject.objectBuildFileMain))
        XCTAssertFalse(PBXFileOrder.byFilename.sort(lhs: iosProject.objectBuildFileMain, rhs: iosProject.objectBuildFileAssets))
    }

    func test_PBXFileOrder_PBXBuildFile_by_filename_when_fileSharedAcrossTargetsProject() throws {
        let fileSharedAcrossTargetsProject = try fileSharedAcrossTargetsProject()

        let sameNameByFilename = fileSharedAcrossTargetsProject.objectBuildFileSameName.sorted(by: PBXFileOrder.byFilename.sort)
        XCTAssertLessThan(sameNameByFilename.first!.1.uuid, sameNameByFilename.last!.1.uuid)
    }

    func test_PBXFileOrder_PBXBuildFile_by_filename_when_nil_name_and_path_when_iosProject() throws {
        let iosProject = try iosProject()

        iosProject.buildFileAssets.file?.name = nil
        iosProject.buildFileMain.file?.name = nil
        iosProject.buildFileAssets.file?.path = nil
        iosProject.buildFileMain.file?.path = nil
        XCTAssertFalse(PBXFileOrder.byFilename.sort(lhs: iosProject.objectBuildFileAssets, rhs: iosProject.objectBuildFileMain))
        XCTAssertTrue(PBXFileOrder.byFilename.sort(lhs: iosProject.objectBuildFileMain, rhs: iosProject.objectBuildFileAssets))
    }

    func test_PBXFileOrder_PBXBuildFile_by_filename_when_no_file_when_iosProject() throws {
        let iosProject = try iosProject()

        let ref1 = iosProject.buildFileAssets.reference
        let ref2 = iosProject.buildFileMain.reference
        iosProject.buildFileAssets.file = nil
        iosProject.buildFileMain.file = nil
        XCTAssertFalse(PBXFileOrder.byFilename.sort(lhs: (ref1, iosProject.buildFileAssets), rhs: (ref2, iosProject.buildFileMain)))
        XCTAssertTrue(PBXFileOrder.byFilename.sort(lhs: (ref2, iosProject.buildFileMain), rhs: (ref1, iosProject.buildFileAssets)))
    }

    // MARK: - PBXFileOrder - PBXBuildPhaseFile

    func test_PBXFileOrder_PBXBuildPhaseFile_by_uuid_when_iosProject() throws {
        let iosProject = try iosProject()

        XCTAssertFalse(PBXFileOrder.byUUID.sort(lhs: iosProject.objectBuildPhaseFileAssets, rhs: iosProject.objectBuildPhaseFileMain))
        XCTAssertTrue(PBXFileOrder.byUUID.sort(lhs: iosProject.objectBuildPhaseFileMain, rhs: iosProject.objectBuildPhaseFileAssets))
    }

    func test_PBXFileOrder_PBXBuildPhaseFile_by_filename_when_iosProject() throws {
        let iosProject = try iosProject()

        XCTAssertTrue(PBXFileOrder.byFilename.sort(lhs: iosProject.objectBuildPhaseFileAssets, rhs: iosProject.objectBuildPhaseFileMain))
        XCTAssertFalse(PBXFileOrder.byFilename.sort(lhs: iosProject.objectBuildPhaseFileMain, rhs: iosProject.objectBuildPhaseFileAssets))
    }

    // MARK: - PBXFileOrder - PBXFileReference

    func test_PBXFileOrder_PBXFileReference_by_uuid_when_iosProject() throws {
        let iosProject = try iosProject()

        XCTAssertFalse(PBXFileOrder.byUUID.sort(lhs: iosProject.objectFileReferenceAssets, rhs: iosProject.objectFileReferenceCoreData))
        XCTAssertTrue(PBXFileOrder.byUUID.sort(lhs: iosProject.objectFileReferenceCoreData, rhs: iosProject.objectFileReferenceAssets))
    }

    func test_PBXFileOrder_PBXFileReference_by_filename_when_iosProject() throws {
        let iosProject = try iosProject()

        XCTAssertTrue(PBXFileOrder.byFilename.sort(lhs: iosProject.objectFileReferenceAssets, rhs: iosProject.objectFileReferenceCoreData))
        XCTAssertFalse(PBXFileOrder.byFilename.sort(lhs: iosProject.objectFileReferenceCoreData, rhs: iosProject.objectFileReferenceAssets))
    }

    func test_PBXFileOrder_PBXFileReference_by_filename_when_fileSharedAcrossTargetsProject() throws {
        let fileSharedAcrossTargetsProject = try fileSharedAcrossTargetsProject()

        let sameNameByFilename = fileSharedAcrossTargetsProject.objectFileReferenceSameName.sorted(by: PBXFileOrder.byFilename.sort)
        XCTAssertLessThan(sameNameByFilename.first!.1.uuid, sameNameByFilename.last!.1.uuid)
    }

    func test_PBXFileOrder_PBXFileReference_by_filename_when_nil_name_and_path_when_iosProject() throws {
        let iosProject = try iosProject()

        iosProject.fileReferenceAssets.name = nil
        iosProject.fileReferenceCoreData.name = nil
        iosProject.fileReferenceAssets.path = nil
        iosProject.fileReferenceCoreData.path = nil
        XCTAssertFalse(PBXFileOrder.byFilename.sort(lhs: iosProject.objectFileReferenceAssets, rhs: iosProject.objectFileReferenceCoreData))
        XCTAssertTrue(PBXFileOrder.byFilename.sort(lhs: iosProject.objectFileReferenceCoreData, rhs: iosProject.objectFileReferenceAssets))
    }

    // MARK: - PBXFileOrder - Other

    func test_PBXFileOrder_Other_by_uuid_when_iosProject() throws {
        let iosProject = try iosProject()

        XCTAssertTrue(PBXFileOrder.byUUID.sort(lhs: iosProject.objectGroupFrameworks, rhs: iosProject.objectGroupProducts))
        XCTAssertFalse(PBXFileOrder.byUUID.sort(lhs: iosProject.objectGroupProducts, rhs: iosProject.objectGroupFrameworks))
    }

    func test_PBXFileOrder_Other_by_filename_when_iosProject() throws {
        let iosProject = try iosProject()

        XCTAssertTrue(PBXFileOrder.byFilename.sort(lhs: iosProject.objectGroupFrameworks, rhs: iosProject.objectGroupProducts))
        XCTAssertFalse(PBXFileOrder.byFilename.sort(lhs: iosProject.objectGroupProducts, rhs: iosProject.objectGroupFrameworks))
    }

    // MARK: - PBXNavigatorFileOrder

    func test_PBXNavigatorFileOrder_unsorted_when_iosProject() {
        XCTAssertNil(PBXNavigatorFileOrder.unsorted.sort)
    }

    func test_PBXNavigatorFileOrder_by_filename_when_iosProject() throws {
        let iosProject = try iosProject()

        let sort: (PBXFileElement, PBXFileElement) -> Bool = PBXNavigatorFileOrder.byFilename.sort!
        let sorted = iosProject.navigatorFileGroup.children.sorted(by: sort).map { $0.fileName()! }
        XCTAssertEqual([
            "AppDelegate.swift",
            "Assets.xcassets",
            "GroupWithoutFolder",
            "Info.plist",
            "LaunchScreen.storyboard",
            "Main.storyboard",
            "Model.xcdatamodeld",
            "Private.h",
            "Protected.h",
            "Public.h",
            "ViewController.swift",
        ], sorted)
    }

    func test_PBXNavigatorFileOrder_by_filename_groups_first_when_iosProject() throws {
        let iosProject = try iosProject()

        let sort: (PBXFileElement, PBXFileElement) -> Bool = PBXNavigatorFileOrder.byFilenameGroupsFirst.sort!
        let sorted = iosProject.navigatorFileGroup.children.sorted(by: sort).map { $0.fileName()! }
        XCTAssertEqual([
            "GroupWithoutFolder",
            "AppDelegate.swift",
            "Assets.xcassets",
            "Info.plist",
            "LaunchScreen.storyboard",
            "Main.storyboard",
            "Model.xcdatamodeld",
            "Private.h",
            "Protected.h",
            "Public.h",
            "ViewController.swift",
        ], sorted)
    }

    // MARK: - PBXBuildPhaseFileOrder

    func test_PBXBuildPhaseFileOrder_unsorted() {
        XCTAssertNil(PBXBuildPhaseFileOrder.unsorted.sort)
    }

    func test_PBXBuildPhaseFileOrder_by_filename_when_iosProject() throws {
        let iosProject = try iosProject()

        XCTAssertTrue(PBXBuildPhaseFileOrder.byFilename.sort!(iosProject.buildFileAssets, iosProject.buildFileMain))
        XCTAssertFalse(PBXBuildPhaseFileOrder.byFilename.sort!(iosProject.buildFileMain, iosProject.buildFileAssets))
    }

    // MARK: - Private

    struct iOSProject {
        var proj: PBXProj!
        var buildFileAssets: PBXBuildFile!
        var buildFileMain: PBXBuildFile!

        var objectBuildFileAssets: (PBXObjectReference, PBXBuildFile)!
        var objectBuildFileMain: (PBXObjectReference, PBXBuildFile)!

        var objectBuildPhaseFileAssets: (PBXObjectReference, PBXBuildPhaseFile)!
        var objectBuildPhaseFileMain: (PBXObjectReference, PBXBuildPhaseFile)!

        var fileReferenceAssets: PBXFileReference!
        var fileReferenceCoreData: PBXFileReference!

        var objectFileReferenceAssets: (PBXObjectReference, PBXFileReference)!
        var objectFileReferenceCoreData: (PBXObjectReference, PBXFileReference)!

        var groupFrameworks: PBXGroup!
        var groupProducts: PBXGroup!

        var objectGroupFrameworks: (PBXObjectReference, PBXGroup)!
        var objectGroupProducts: (PBXObjectReference, PBXGroup)!

        var navigatorFileGroup: PBXGroup!
    }

    private func iosProject() throws -> iOSProject {
        let data = try XCTUnwrap(iosProjectData())
        let proj = try XCTUnwrap(PBXProj(data: data))

        let buildFileAssets = proj.buildFiles.first { $0.file?.fileName() == "Assets.xcassets" }!
        let buildFileMain = proj.buildFiles.first { $0.file?.fileName() == "Main.storyboard" }!

        let objectBuildFileAssets = (buildFileAssets.reference, buildFileAssets)
        let objectBuildFileMain = (buildFileMain.reference, buildFileMain)

        let objectBuildPhaseFileAssets = proj.objects.buildPhaseFile.first { $0.value.buildFile.file?.fileName() == "Assets.xcassets" }!
        let objectBuildPhaseFileMain = proj.objects.buildPhaseFile.first { $0.value.buildFile.file?.fileName() == "Main.storyboard" }!

        let fileReferenceAssets = proj.fileReferences.first { $0.fileName() == "Assets.xcassets" }!
        let fileReferenceCoreData = proj.fileReferences.first { $0.fileName() == "CoreData.framework" }!

        let objectFileReferenceAssets = (buildFileAssets.reference, fileReferenceAssets)
        let objectFileReferenceCoreData = (buildFileMain.reference, fileReferenceCoreData)

        let groupFrameworks = proj.groups.first { $0.fileName() == "Frameworks" }!
        let groupProducts = proj.groups.first { $0.fileName() == "Products" }!

        let objectGroupFrameworks = (groupFrameworks.reference, groupFrameworks)
        let objectGroupProducts = (groupProducts.reference, groupProducts)

        let navigatorFileGroup = proj.groups.first { $0.fileName() == "iOS" }!

        return iOSProject(
            proj: proj,
            buildFileAssets: buildFileAssets,
            buildFileMain: buildFileMain,
            objectBuildFileAssets: objectBuildFileAssets,
            objectBuildFileMain: objectBuildFileMain,
            objectBuildPhaseFileAssets: objectBuildPhaseFileAssets,
            objectBuildPhaseFileMain: objectBuildPhaseFileMain,
            fileReferenceAssets: fileReferenceAssets,
            fileReferenceCoreData: fileReferenceCoreData,
            objectFileReferenceAssets: objectFileReferenceAssets,
            objectFileReferenceCoreData: objectFileReferenceCoreData,
            groupFrameworks: groupFrameworks,
            groupProducts: groupProducts,
            objectGroupFrameworks: objectGroupFrameworks,
            objectGroupProducts: objectGroupProducts,
            navigatorFileGroup: navigatorFileGroup
        )
    }

    struct FileSharedAcrossTargetsProject {
        var proj: PBXProj!
        var buildFileSameName: [PBXBuildFile]!
        var objectBuildFileSameName: [(PBXObjectReference, PBXBuildFile)]!
        var fileReferenceSameName: [PBXFileReference]!
        var objectFileReferenceSameName: [(PBXObjectReference, PBXFileReference)]!
    }

    func fileSharedAcrossTargetsProject() throws -> FileSharedAcrossTargetsProject {
        let dic = try XCTUnwrap(fileSharedAcrossTargetsData())
        let proj = try XCTUnwrap(PBXProj(data: dic))

        let buildFileSameName = proj.buildFiles.filter { $0.file?.fileName() == "SameName.h" }
        let objectBuildFileSameName = proj.buildFiles.map { ($0.reference, $0) }
        let fileReferenceSameName = proj.fileReferences.filter { $0.fileName() == "FileSharedAcrossTargetsTests.swift" }
        let objectFileReferenceSameName = fileReferenceSameName.map { ($0.reference, $0) }

        return FileSharedAcrossTargetsProject(
            proj: proj,
            buildFileSameName: buildFileSameName,
            objectBuildFileSameName: objectBuildFileSameName,
            fileReferenceSameName: fileReferenceSameName,
            objectFileReferenceSameName: objectFileReferenceSameName
        )
    }
}
