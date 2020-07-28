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

    func test_equatable_when_unequal_data_elements() {
        // Given
        let location: XCWorkspaceDataElementLocationType = .absolute("/path/to/file.swift")
        let file = XCWorkspaceDataFileRef(location: location)
        let element = XCWorkspaceDataElement.file(file)

        // When
        let firstWorkspace = XCWorkspace(data: .init(children: [element]))
        let secondWorkspace = XCWorkspace(data: .init(children: []))

        // Then
        XCTAssertNotEqual(firstWorkspace, secondWorkspace)
    }

    func test_equatable_when_equal_data_elements() {
        // Given
        let groupLocation: XCWorkspaceDataElementLocationType = .absolute("/path/to/group")
        let group = XCWorkspaceDataGroup(location: groupLocation,
                                         name: "group",
                                         children: [])
        let elementOne = XCWorkspaceDataElement.group(group)

        let fileLocation: XCWorkspaceDataElementLocationType = .absolute("/path/to/file.swift")
        let file = XCWorkspaceDataFileRef(location: fileLocation)
        let elementTwo = XCWorkspaceDataElement.file(file)

        // When
        let firstWorkspace = XCWorkspace(data: .init(children: [elementOne, elementTwo]))
        let secondWorkspace = XCWorkspace(data: .init(children: [elementOne, elementTwo]))

        // Then
        XCTAssertEqual(firstWorkspace, secondWorkspace)
    }
}
