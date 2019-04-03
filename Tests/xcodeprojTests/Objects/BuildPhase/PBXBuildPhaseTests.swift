import Foundation
import XCTest
@testable import XcodeProj

final class PBXBuildPhaseTests: XCTestCase {
    var subject: PBXBuildPhase!
    var proj: PBXProj!

    override func setUp() {
        super.setUp()
        subject = PBXSourcesBuildPhase()
        proj = PBXProj.fixture()
        proj.add(object: subject)
    }

    func test_add_files() throws {
        let file = PBXFileElement(sourceTree: .absolute,
                                  path: "path",
                                  name: "name",
                                  includeInIndex: false,
                                  wrapsLines: true)

        let buildFile = subject.add(file: file)
        XCTAssertEqual(subject.files?.contains(buildFile), true)
    }

    func test_add_files_only_once() throws {
        let file = PBXFileElement(sourceTree: .absolute,
                                  path: "path",
                                  name: "name",
                                  includeInIndex: false,
                                  wrapsLines: true)

        let buildFile = subject.add(file: file)
        let sameBuildFile = subject.add(file: file)
        XCTAssertEqual(buildFile, sameBuildFile, "Expected adding a file only once but it didn't")

        let fileOccurrencesCount = subject.files?.filter { $0 == buildFile }.count
        XCTAssertTrue(fileOccurrencesCount == 1, "Expected adding a file only once but it didn't")
    }
}
