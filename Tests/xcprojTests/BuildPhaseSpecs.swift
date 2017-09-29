import Foundation
import XCTest
import xcproj

class BuildPhaseSpecs: XCTestCase {

    func test_sources_hasTheCorrectRawValue() {
        XCTAssertEqual(BuildPhase.sources.rawValue, "Sources")
    }

    func test_frameworks_hasTheCorrectRawValue() {
        XCTAssertEqual(BuildPhase.frameworks.rawValue, "Frameworks")
    }

    func test_resources_hasTheCorrectRawValue() {
        XCTAssertEqual(BuildPhase.resources.rawValue, "Resources")
    }

    func test_copyFiles_hasTheCorrectRawValue() {
        XCTAssertEqual(BuildPhase.copyFiles.rawValue, "Copy Files")
    }

    func test_runStript_hasTheCorrectRawValue() {
        XCTAssertEqual(BuildPhase.runScript.rawValue, "Run Script")
    }

    func test_headers_hasTheCorrectRawValue() {
        XCTAssertEqual(BuildPhase.headers.rawValue, "Headers")
    }

}
