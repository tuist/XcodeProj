import Foundation
import XCTest

@testable import xcodeproj

final class PBXProjectSpec: XCTestCase {
    
    var subject: PBXProject!
    
    override func setUp() {
        super.setUp()
        subject = PBXProject(reference: "uuid",
                             buildConfigurationList: "config",
                             compatibilityVersion: "version",
                             mainGroup: "main",
                             developmentRegion: "region",
                             hasScannedForEncodings: 1,
                             knownRegions: ["region"],
                             productRefGroup: "group",
                             projectDirPath: "path",
                             projectReferences: ["ref"],
                             projectRoot: "root",
                             targets: ["target"])
    }
    
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXProject.isa, "PBXProject")
    }
    
    func test_init_initializesTheProjectWithTheRightAttributes() {
        XCTAssertEqual(subject.reference, "uuid")
        XCTAssertEqual(subject.buildConfigurationList, "config")
        XCTAssertEqual(subject.compatibilityVersion, "version")
        XCTAssertEqual(subject.mainGroup, "main")
        XCTAssertEqual(subject.developmentRegion, "region")
        XCTAssertEqual(subject.hasScannedForEncodings, 1)
        XCTAssertEqual(subject.knownRegions, ["region"])
        XCTAssertEqual(subject.productRefGroup, "group")
        XCTAssertEqual(subject.projectDirPath, "path")
        XCTAssertEqual(subject.projectReferences as! [String], ["ref"])
        XCTAssertEqual(subject.projectRoot, "root")
        XCTAssertEqual(subject.targets, ["target"])
    }
    
    func test_init_failsIfBuildConfigurationListIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "buildConfigurationList")
        do {
            _ = try PBXProject(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsIfCompatibilityVersionIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "compatibilityVersion")
        do {
            _ = try PBXProject(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_failsIfMainGroupIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "mainGroup")
        do {
            _ = try PBXProject(reference: "ref", dictionary: dictionary)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_equal_returnsTheCorrectValue() {
        let another = PBXProject(reference: "uuid",
                                 buildConfigurationList: "config",
                                 compatibilityVersion: "version",
                                 mainGroup: "main",
                                 developmentRegion: "region",
                                 hasScannedForEncodings: 1,
                                 knownRegions: ["region"],
                                 productRefGroup: "group",
                                 projectDirPath: "path",
                                 projectReferences: ["ref"],
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
            "mainGroup": "mainGroup"
        ]
    }
}
