import Foundation
import XCTest

@testable import xcodeproj

final class PBXProjectSpec: XCTestCase {
    
    var subject: PBXProject!
    
    override func setUp() {
        super.setUp()
        subject = PBXProject(reference: "uuid",
                             buildConfigurationList: "uuid",
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
        XCTAssertEqual(subject.isa, "PBXProject")
    }
    
    func test_continue() {
        XCTAssertTrue(false, "write tests for this class")
    }
    
    func test_equal_returnsTheCorrectValue() {
        let another = PBXProject(reference: "uuid",
                                 buildConfigurationList: "uuid",
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
}
