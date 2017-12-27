import Foundation
import XCTest
import PathKit
import xcproj

final class XCWorkspaceDataSpec: XCTestCase {

    var subject: XCWorkspaceData!
    var fileRef: XCWorkspaceDataFileRef!

    override func setUp() {
        super.setUp()
        fileRef = XCWorkspaceDataFileRef(
            location: .self("path")
        )
        subject = XCWorkspaceData(children: [])
    }


    func test_equal_returnsTheCorrectValue() {
        let another = XCWorkspaceData(children: [])
        XCTAssertEqual(subject, another)
    }

}

final class XCWorkspaceDataIntegrationSpec: XCTestCase {

    func test_init_returnsTheModelWithTheRightProperties() throws {
        let path = fixturePath()
        let got = try XCWorkspaceData(path: path)
        if case let XCWorkspaceDataElement.file(location: fileRef) = got.children.first! {
            XCTAssertEqual(fileRef.location, .self(""))
        } else {
            XCTAssertTrue(false, "Expected file reference")
        }
    }

    func test_init_throwsIfThePathIsWrong() {
        do {
            _ = try XCWorkspace(path: Path("test"))
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_write() {
        testWrite(
            from: fixturePath(),
            initModel: { try? XCWorkspaceData(path: $0) },
            modify: {
                $0.children.append(
                    .group(.init(location: .self("shakira"),
                                 name: "shakira",
                                 children: [])
                    )
                )
                return $0
        },
            assertion: { (before, after) in
                XCTAssertEqual(before, after)
                XCTAssertEqual(after.children.count, 2)

                switch after.children.last {
                case let .group(group)?:
                    XCTAssertEqual(group.name, "shakira")
                    XCTAssertEqual(group.children.count, 0)
                default:
                    XCTAssertTrue(false, "Expected group")
                }
        })
    }

    func test_init_returnsAllChildren() throws {
        let workspace = try fixtureWorkspace()
        XCTAssertEqual(workspace.data.children.count, 4)
    }

    func test_init_returnsNestedElements() throws {
        let workspace = try fixtureWorkspace()
        if case let XCWorkspaceDataElement.group(group) = workspace.data.children.first! {
            XCTAssertEqual(group.children.count, 2)
        } else {
            XCTAssertTrue(false, "Expected group")
        }
    }

    func test_init_returnsAllLocationTypes() throws {
        let workspace = try fixtureWorkspace()

        if case let XCWorkspaceDataElement.group(group) = workspace.data.children[0] {
            if case let XCWorkspaceDataElement.file(fileRef) = group.children[0] {
                XCTAssertEqual(fileRef.location, .group("../WithoutWorkspace/WithoutWorkspace.xcodeproj"))
            } else {
                XCTAssertTrue(false, "Expected fileRef")
            }
            if case let XCWorkspaceDataElement.file(fileRef) = group.children[1] {
                XCTAssertEqual(fileRef.location, .container("iOS/BuildSettings.xcodeproj"))
            } else {
                XCTAssertTrue(false, "Expected fileRef")
            }
        } else {
            XCTAssertTrue(false, "Expected group")
        }
        if case let XCWorkspaceDataElement.file(fileRef) = workspace.data.children[2] {
            XCTAssertEqual(fileRef.location, .absolute("/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"))
        } else {
            XCTAssertTrue(false, "Expected fileRef")
        }
        if case let XCWorkspaceDataElement.file(fileRef) = workspace.data.children[3] {
            XCTAssertEqual(fileRef.location, .developer("Applications/Simulator.app"))
        } else {
            XCTAssertTrue(false, "Expected fileRef")
        }
    }

    // MARK: - Private

    private func fixturePath() -> Path {
        return fixturesPath() + Path("iOS/Project.xcodeproj/project.xcworkspace/contents.xcworkspacedata")
    }

    private func fixtureWorkspace() throws -> XCWorkspace {
        let path = fixturesPath() + Path("Workspace.xcworkspace")
        return try XCWorkspace(path: path)
    }

}
