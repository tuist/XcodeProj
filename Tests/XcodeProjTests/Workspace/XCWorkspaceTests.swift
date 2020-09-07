import Foundation
import PathKit
import XcodeProj
import XCTest

final class XCWorkspaceIntegrationTests: XCTestCase {
    func test_initTheWorkspaceWithTheRightPropeties() {
        let path = fixturesPath() + "iOS/Project.xcodeproj/project.xcworkspace"
        let got = try? XCWorkspace(path: path)
        XCTAssertNotNil(got)
    }

    func test_initFailsIfThePathIsWrong() {
        do {
            _ = try XCWorkspace(path: Path("/test"))
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_init_returnsAWorkspaceWithTheCorrectReference() {
        XCTAssertEqual(XCWorkspace().data.children.count, 1)
        XCTAssertEqual(XCWorkspace().data.children.first, .file(.init(location: .self(""))))
    }

    func test_equatable_emptyWorkspacesAreEqual() {
        // When
        let firstWorkspace = XCWorkspace(data: .init(children: []))
        let secondWorkspace = XCWorkspace(data: .init(children: []))

        // Then
        XCTAssertEqual(firstWorkspace, secondWorkspace)
    }

    func test_equatable_unEqualWorkspacesAreNotEqual() {
        // Given
        let pathOne = fixturesPath() + "iOS/Project.xcodeproj/project.xcworkspace"
        let pathTwo = fixturesPath() + "iOS/Workspace.xcworkspace"

        // When
        let firstWorkspace = try? XCWorkspace(path: pathOne)
        let secondWorkspace = try? XCWorkspace(path: pathTwo)

        // Then
        XCTAssertNotEqual(firstWorkspace, secondWorkspace)
    }

    func test_equatable_equalWorkspacesAreEqual() {
        // Given
        let pathOne = fixturesPath() + "iOS/Workspace.xcworkspace"
        let pathTwo = fixturesPath() + "iOS/Workspace.xcworkspace"

        // When
        let firstWorkspace = try? XCWorkspace(path: pathOne)
        let secondWorkspace = try? XCWorkspace(path: pathTwo)

        // Then
        XCTAssertEqual(firstWorkspace, secondWorkspace)
    }
}
