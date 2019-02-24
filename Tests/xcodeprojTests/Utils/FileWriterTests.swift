import Foundation
import PathKit
import XCTest

@testable import xcodeproj

final class FileWriterTests: XCTestCase {
    var subject: FileWriting!
    var path: Path!

    override func setUp() {
        subject = FileWriter()
        path = try! Path.uniqueTemporary() + "data"
    }

    override func tearDown() {
        try? path.delete()
        super.tearDown()
    }

    func test_write_string_when_fileHasntChanged() throws {
        // Given
        let data = "test".data(using: .utf8)!
        try path.write(data)

        // When
        let written = try subject.write(string: "test", to: path)

        // Then
        XCTAssertFalse(written)
    }

    func test_write_string_when_fileDoesntExist() throws {
        // Given
        XCTAssertFalse(path.exists)

        // When
        let written = try subject.write(string: "test", to: path)

        // Then
        XCTAssertTrue(written)
        XCTAssertTrue(path.exists)
    }

    func test_write_string_when_fileHasChanged() throws {
        // Given
        try path.write("test")

        // When
        let written = try subject.write(string: "changed", to: path)

        // Then
        let content: String = try path.read()
        XCTAssertTrue(written)
        XCTAssertTrue(path.exists)
        XCTAssertEqual(content, "changed")
    }

    func test_write_data_when_fileHasntChanged() throws {
        // Given
        let data = "test".data(using: .utf8)!
        try path.write(data)

        // When
        let written = try subject.write(data: data, to: path)

        // Then
        XCTAssertFalse(written)
    }

    func test_write_data_when_fileDoesntExist() throws {
        // Given
        let data = "test".data(using: .utf8)!
        XCTAssertFalse(path.exists)

        // When
        let written = try subject.write(data: data, to: path)

        // Then
        XCTAssertTrue(written)
        XCTAssertTrue(path.exists)
    }

    func test_write_data_when_fileHasChanged() throws {
        // Given
        let data = "test".data(using: .utf8)!
        try path.write(data)

        // When
        let newData = "changed".data(using: .utf8)!
        let written = try subject.write(data: newData, to: path)

        // Then
        let content: String = try path.read()
        XCTAssertTrue(written)
        XCTAssertTrue(path.exists)
        XCTAssertEqual(content, "changed")
    }
}
