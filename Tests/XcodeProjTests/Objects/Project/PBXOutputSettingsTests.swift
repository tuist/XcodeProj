
import XCTest
@testable import XcodeProj

class PBXOutputSettingsTests: XCTestCase {
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

    override func setUp() {
        let dic = iosProjectDictionary()
        do {
            proj = try PBXProj(jsonDictionary: dic.1)
        } catch {
            XCTFail("Failed to load project from file: \(error)")
        }

//        proj.buildFiles.forEach { print("\(type(of: $0.file!)) \($0.file!.fileName()!)") }
        buildFileAssets = proj.buildFiles.first { $0.file?.fileName() == "Assets.xcassets" }!
        buildFileMain = proj.buildFiles.first { $0.file?.fileName() == "Main.storyboard" }!

        objectBuildFileAssets = (buildFileAssets.reference, buildFileAssets)
        objectBuildFileMain = (buildFileMain.reference, buildFileMain)

        objectBuildPhaseFileAssets = proj.objects.buildPhaseFile.first { $0.value.buildFile.file?.fileName() == "Assets.xcassets" }!
        objectBuildPhaseFileMain = proj.objects.buildPhaseFile.first { $0.value.buildFile.file?.fileName() == "Main.storyboard" }!

        fileReferenceAssets = proj.fileReferences.first { $0.fileName() == "Assets.xcassets" }!
        fileReferenceCoreData = proj.fileReferences.first { $0.fileName() == "CoreData.framework" }!

        objectFileReferenceAssets = (buildFileAssets.reference, fileReferenceAssets)
        objectFileReferenceCoreData = (buildFileMain.reference, fileReferenceCoreData)

        groupFrameworks = proj.groups.first { $0.fileName() == "Frameworks" }!
        groupProducts = proj.groups.first { $0.fileName() == "Products" }!

        objectGroupFrameworks = (groupFrameworks.reference, groupFrameworks)
        objectGroupProducts = (groupProducts.reference, groupProducts)

        navigatorFileGroup = proj.groups.first { $0.fileName() == "iOS" }!
    }

    // MARK: - PBXFileOrder - PBXBuldFile

    func test_PBXFileOrder_PBXBuildFile_by_uuid() {
        XCTAssertFalse(PBXFileOrder.byUUID.sort(lhs: objectBuildFileAssets, rhs: objectBuildFileMain))
        XCTAssertTrue(PBXFileOrder.byUUID.sort(lhs: objectBuildFileMain, rhs: objectBuildFileAssets))
    }

    func test_PBXFileOrder_PBXBuildFile_by_filename() {
        XCTAssertTrue(PBXFileOrder.byFilename.sort(lhs: objectBuildFileAssets, rhs: objectBuildFileMain))
        XCTAssertFalse(PBXFileOrder.byFilename.sort(lhs: objectBuildFileMain, rhs: objectBuildFileAssets))
    }

    func test_PBXFileOrder_PBXBuildFile_by_filename_when_nil_name_and_path() {
        buildFileAssets.file?.name = nil
        buildFileMain.file?.name = nil
        buildFileAssets.file?.path = nil
        buildFileMain.file?.path = nil
        XCTAssertFalse(PBXFileOrder.byFilename.sort(lhs: objectBuildFileAssets, rhs: objectBuildFileMain))
        XCTAssertTrue(PBXFileOrder.byFilename.sort(lhs: objectBuildFileMain, rhs: objectBuildFileAssets))
    }

    func test_PBXFileOrder_PBXBuildFile_by_filename_when_no_file() {
        let ref1 = buildFileAssets.reference
        let ref2 = buildFileMain.reference
        buildFileAssets.file = nil
        buildFileMain.file = nil
        XCTAssertFalse(PBXFileOrder.byFilename.sort(lhs: (ref1, buildFileAssets), rhs: (ref2, buildFileMain)))
        XCTAssertTrue(PBXFileOrder.byFilename.sort(lhs: (ref2, buildFileMain), rhs: (ref1, buildFileAssets)))
    }

    // MARK: - PBXFileOrder - PBXBuildPhaseFile

    func test_PBXFileOrder_PBXBuildPhaseFile_by_uuid() {
        XCTAssertFalse(PBXFileOrder.byUUID.sort(lhs: objectBuildPhaseFileAssets, rhs: objectBuildPhaseFileMain))
        XCTAssertTrue(PBXFileOrder.byUUID.sort(lhs: objectBuildPhaseFileMain, rhs: objectBuildPhaseFileAssets))
    }

    func test_PBXFileOrder_PBXBuildPhaseFile_by_filename() {
        XCTAssertTrue(PBXFileOrder.byFilename.sort(lhs: objectBuildPhaseFileAssets, rhs: objectBuildPhaseFileMain))
        XCTAssertFalse(PBXFileOrder.byFilename.sort(lhs: objectBuildPhaseFileMain, rhs: objectBuildPhaseFileAssets))
    }

    // MARK: - PBXFileOrder - PBXFileReference

    func test_PBXFileOrder_PBXFileReference_by_uuid() {
        XCTAssertFalse(PBXFileOrder.byUUID.sort(lhs: objectFileReferenceAssets, rhs: objectFileReferenceCoreData))
        XCTAssertTrue(PBXFileOrder.byUUID.sort(lhs: objectFileReferenceCoreData, rhs: objectFileReferenceAssets))
    }

    func test_PBXFileOrder_PBXFileReference_by_filename() {
        XCTAssertTrue(PBXFileOrder.byFilename.sort(lhs: objectFileReferenceAssets, rhs: objectFileReferenceCoreData))
        XCTAssertFalse(PBXFileOrder.byFilename.sort(lhs: objectFileReferenceCoreData, rhs: objectFileReferenceAssets))
    }

    func test_PBXFileOrder_PBXFileReference_by_filename_when_nil_name_and_path() {
        fileReferenceAssets.name = nil
        fileReferenceCoreData.name = nil
        fileReferenceAssets.path = nil
        fileReferenceCoreData.path = nil
        XCTAssertFalse(PBXFileOrder.byFilename.sort(lhs: objectFileReferenceAssets, rhs: objectFileReferenceCoreData))
        XCTAssertTrue(PBXFileOrder.byFilename.sort(lhs: objectFileReferenceCoreData, rhs: objectFileReferenceAssets))
    }

    // MARK: - PBXFileOrder - Other

    func test_PBXFileOrder_Other_by_uuid() {
        XCTAssertTrue(PBXFileOrder.byUUID.sort(lhs: objectGroupFrameworks, rhs: objectGroupProducts))
        XCTAssertFalse(PBXFileOrder.byUUID.sort(lhs: objectGroupProducts, rhs: objectGroupFrameworks))
    }

    func test_PBXFileOrder_Other_by_filename() {
        XCTAssertTrue(PBXFileOrder.byFilename.sort(lhs: objectGroupFrameworks, rhs: objectGroupProducts))
        XCTAssertFalse(PBXFileOrder.byFilename.sort(lhs: objectGroupProducts, rhs: objectGroupFrameworks))
    }

    // MARK: - PBXNavigatorFileOrder

    func test_PBXNavigatorFileOrder_unsorted() {
        XCTAssertNil(PBXNavigatorFileOrder.unsorted.sort)
    }

    func test_PBXNavigatorFileOrder_by_filename() {
        let sort: (PBXFileElement, PBXFileElement) -> Bool = PBXNavigatorFileOrder.byFilename.sort!
        let sorted = navigatorFileGroup.children.sorted(by: sort).map { $0.fileName()! }
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

    func test_PBXNavigatorFileOrder_by_filename_groups_first() {
        let sort: (PBXFileElement, PBXFileElement) -> Bool = PBXNavigatorFileOrder.byFilenameGroupsFirst.sort!
        let sorted = navigatorFileGroup.children.sorted(by: sort).map { $0.fileName()! }
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

    func test_PBXBuildPhaseFileOrder_by_filename() {
        XCTAssertTrue(PBXBuildPhaseFileOrder.byFilename.sort!(buildFileAssets, buildFileMain))
        XCTAssertFalse(PBXBuildPhaseFileOrder.byFilename.sort!(buildFileMain, buildFileAssets))
    }
}
