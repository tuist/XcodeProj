import Foundation
import XCTest

@testable import XcodeProj

final class XCLocalSwiftPackageReferenceTests: XCTestCase {
    func test_init() throws {
        // Given
        let decoder = XcodeprojPropertyListDecoder()
        let plist: [String: Any] = ["reference": "ref",
                                    "relativePath": "path"]
        let data = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)

        // When
        let got = try decoder.decode(XCLocalSwiftPackageReference.self, from: data)

        // Then
        XCTAssertEqual(got.reference.value, "ref")
        XCTAssertEqual(got.relativePath, "path")
    }

    func test_plistValues() throws {
        // When
        let proj = PBXProj()
        let subject = XCLocalSwiftPackageReference(relativePath: "repository")

        // Given
        let got = try subject.plistKeyAndValue(proj: proj, reference: "ref")

        // Then
        XCTAssertEqual(got.value, .dictionary([
            "isa": "XCLocalSwiftPackageReference",
            "relativePath": "repository"
        ]))
    }

    func test_equal() {
        // When
        let first = XCLocalSwiftPackageReference(relativePath: "repository")
        let second = XCLocalSwiftPackageReference(relativePath: "repository")

        // Then
        XCTAssertEqual(first, second)
    }

    func test_name() {
        // When
        let subject = XCLocalSwiftPackageReference(relativePath: "tuist/xcodeproj")

        // Then
        XCTAssertEqual(subject.name, "tuist/xcodeproj")
    }
}
