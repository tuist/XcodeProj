import Foundation
import XCTest
import xcproj

final class PBXCopyFilesBuildPhaseSpec: XCTestCase {

    var subject: PBXCopyFilesBuildPhase!

    override func setUp() {
        super.setUp()
        self.subject = PBXCopyFilesBuildPhase(dstPath: "dest",
                                              dstSubfolderSpec: .absolutePath,
                                              name: "name",
                                              buildActionMask: 4,
                                              files: ["33"],
                                              runOnlyForDeploymentPostprocessing: 0)
    }

    func test_subFolder_absolutePath_hasTheCorrectValue() {
        XCTAssertEqual(PBXCopyFilesBuildPhase.SubFolder.absolutePath.rawValue, 0)
    }

    func test_subFolder_producsDirectory_hasTheCorrectValue() {
        XCTAssertEqual(PBXCopyFilesBuildPhase.SubFolder.productsDirectory.rawValue, 16)
    }

    func test_subFolder_wrapper_hasTheCorrectValue() {
        XCTAssertEqual(PBXCopyFilesBuildPhase.SubFolder.wrapper.rawValue, 1)
    }

    func test_subFolder_executables_hasTheCorrectValue() {
        XCTAssertEqual(PBXCopyFilesBuildPhase.SubFolder.executables.rawValue, 6)
    }
    func test_subFolder_resources_hasTheCorrectValue() {
        XCTAssertEqual(PBXCopyFilesBuildPhase.SubFolder.resources.rawValue, 7)
    }

    func test_subFolder_javaResources_hasTheCorrectValue() {
        XCTAssertEqual(PBXCopyFilesBuildPhase.SubFolder.javaResources.rawValue, 15)
    }

    func test_subFolder_frameworks_hasTheCorrectValue() {
        XCTAssertEqual(PBXCopyFilesBuildPhase.SubFolder.frameworks.rawValue, 10)
    }

    func test_subFolder_sharedFrameworks_hasTheCorrectValue() {
        XCTAssertEqual(PBXCopyFilesBuildPhase.SubFolder.sharedFrameworks.rawValue, 11)
    }

    func test_subFolder_sharedSupport_hasTheCorrectValue() {
        XCTAssertEqual(PBXCopyFilesBuildPhase.SubFolder.sharedSupport.rawValue, 12)
    }

    func test_subFolder_plugins_hasTheCorrectValue() {
        XCTAssertEqual(PBXCopyFilesBuildPhase.SubFolder.plugins.rawValue, 13)
    }

    func test_init_initializesTheBuildPhaseWiththeRightAttributes() {
        XCTAssertEqual(subject.dstPath, "dest")
        XCTAssertEqual(subject.dstSubfolderSpec, .absolutePath)
        XCTAssertEqual(subject.buildActionMask, 4)
        XCTAssertEqual(subject.files, ["33"])
        XCTAssertEqual(subject.runOnlyForDeploymentPostprocessing, 0)
    }

    func test_init_fails_whenDstPathIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "dstPath")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXCopyFilesBuildPhase.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_init_fails_whenBuildActionMaskIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildActionMask")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXCopyFilesBuildPhase.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_init_fails_whenDstSubfolderSpecIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "dstSubfolderSpec")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXCopyFilesBuildPhase.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_init_fails_whenFilesIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "files")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXCopyFilesBuildPhase.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_init_fails_whenRunOnlyForDeploymentPostprocessingIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "runOnlyForDeploymentPostprocessing")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXCopyFilesBuildPhase.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_isa_returnsTheRightValue() {
        XCTAssertEqual(PBXCopyFilesBuildPhase.isa, "PBXCopyFilesBuildPhase")
    }

    func test_equals_returnsTheRightValue() {
        let another = PBXCopyFilesBuildPhase(dstPath: "dest",
                                             dstSubfolderSpec: .absolutePath,
                                             name: "name",
                                             buildActionMask: 4,
                                             files: ["33"],
                                             runOnlyForDeploymentPostprocessing: 0)
        XCTAssertEqual(subject, another)
    }

    func testDictionary() -> [String: Any] {
        return [
            "dstPath": "dstPath",
            "buildActionMask": 0,
            "dstSubfolderSpec": 12,
            "files": ["a", "b"],
            "runOnlyForDeploymentPostprocessing": 0,
            "reference": "reference"
        ]
    }
}
