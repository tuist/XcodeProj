import Foundation
import XCTest
@testable import xcproj

final class PBXProjectSpec: XCTestCase {

    var subject: PBXProject!

    override func setUp() {
        super.setUp()
        subject = PBXProject(name: "App",
                             reference: "uuid",
                             buildConfigurationList: "config",
                             compatibilityVersion: "version",
                             mainGroup: "main",
                             developmentRegion: "region",
                             hasScannedForEncodings: 1,
                             knownRegions: ["region"],
                             productRefGroup: "group",
                             projectDirPath: "path",
                             projectReferences: [["ref" : "ref"]],
                             projectRoot: "root",
                             targets: ["target"])
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXProject.isa, "PBXProject")
    }

    func test_init_initializesTheProjectWithTheRightAttributes() {
        XCTAssertEqual(subject.name, "App")
        XCTAssertEqual(subject.reference, "uuid")
        XCTAssertEqual(subject.buildConfigurationList, "config")
        XCTAssertEqual(subject.compatibilityVersion, "version")
        XCTAssertEqual(subject.mainGroup, "main")
        XCTAssertEqual(subject.developmentRegion, "region")
        XCTAssertEqual(subject.hasScannedForEncodings, 1)
        XCTAssertEqual(subject.knownRegions, ["region"])
        XCTAssertEqual(subject.productRefGroup, "group")
        XCTAssertEqual(subject.projectDirPath, "path")
        XCTAssertTrue(subject.projectReferences.elementsEqual([["ref" : "ref"]], by: ==))
        XCTAssertEqual(subject.projectRoot, "root")
        XCTAssertEqual(subject.targets, ["target"])
    }

    func test_plistKeyAndValue() {
        let proj = PBXProj(objectVersion: 1, rootObject: "", archiveVersion: 1)
        let (_, plistValue) = subject.plistKeyAndValue(proj: proj)
        guard let v = plistValue.dictionary?["buildConfigurationList"]?.string else {
            XCTFail()
            return
        }
        XCTAssertEqual(v, CommentedString("config", comment: "Build configuration list for PBXProject \"App\""))
    }

    func test_init_failsIfBuildConfigurationListIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildConfigurationList")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXProject.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_init_failsIfCompatibilityVersionIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "compatibilityVersion")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXProject.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_init_failsIfMainGroupIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "mainGroup")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXProject.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_equal_returnsTheCorrectValue() {
        let another = PBXProject(name: "App",
                                 reference: "uuid",
                                 buildConfigurationList: "config",
                                 compatibilityVersion: "version",
                                 mainGroup: "main",
                                 developmentRegion: "region",
                                 hasScannedForEncodings: 1,
                                 knownRegions: ["region"],
                                 productRefGroup: "group",
                                 projectDirPath: "path",
                                 projectReferences: [["ref" : "ref"]],
                                 projectRoot: "root",
                                 targets: ["target"])
        XCTAssertEqual(subject, another)
    }

    func test_hashValue_returnsTheReferenceHashValue() {
        XCTAssertEqual(subject.hashValue, subject.reference.hashValue)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "buildConfigurationList": "buildConfigurationList",
            "compatibilityVersion": "compatibilityVersion",
            "mainGroup": "mainGroup",
            "reference": "reference"
        ]
    }
}
