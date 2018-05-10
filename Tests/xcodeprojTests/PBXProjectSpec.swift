import Foundation
@testable import xcodeproj
import XCTest

final class PBXProjectSpec: XCTestCase {
    var subject: PBXProject!

    override func setUp() {
        super.setUp()
        subject = PBXProject(name: "App",
                             buildConfigurationList: "config",
                             compatibilityVersion: "version",
                             mainGroup: "main",
                             developmentRegion: "region",
                             hasScannedForEncodings: 1,
                             knownRegions: ["region"],
                             productRefGroup: "group",
                             projectDirPath: "path",
                             projectReferences: [["ref": "ref"]],
                             projectRoots: ["root"],
                             targets: [PBXObjectReference("target")])
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXProject.isa, "PBXProject")
    }

    func test_init_failsIfBuildConfigurationListIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildConfigurationList")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = XcodeprojJSONDecoder()
        do {
            _ = try decoder.decode(PBXProject.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_init_failsIfCompatibilityVersionIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "compatibilityVersion")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = XcodeprojJSONDecoder()
        do {
            _ = try decoder.decode(PBXProject.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_init_failsIfMainGroupIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "mainGroup")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = XcodeprojJSONDecoder()
        do {
            _ = try decoder.decode(PBXProject.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    private func testDictionary() -> [String: Any] {
        return [
            "buildConfigurationList": "buildConfigurationList",
            "compatibilityVersion": "compatibilityVersion",
            "mainGroup": "mainGroup",
            "reference": "reference",
        ]
    }
}
