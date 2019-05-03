import Foundation
import PathKit
import XcodeProj
import XCTest

final class XCWorkspaceDataElementTests: XCTestCase {
    func test_location_when_group() {
        let location: XCWorkspaceDataElementLocationType = .absolute("/path/to/group")
        let group = XCWorkspaceDataGroup(location: location,
                                         name: "group",
                                         children: [])
        let element = XCWorkspaceDataElement.group(group)

        XCTAssertEqual(element.location, location)
    }

    func test_location_when_file() {
        let location: XCWorkspaceDataElementLocationType = .absolute("/path/to/file.swift")
        let file = XCWorkspaceDataFileRef(location: location)
        let element = XCWorkspaceDataElement.file(file)

        XCTAssertEqual(element.location, location)
    }
}
