import Foundation
import XCTest

@testable import XcodeProj

final class XCLocalSwiftPackageReferenceTests: XCTestCase {
    func test_init() throws {
        // Given
        let decoder = XcodeprojPropertyListDecoder()
        let plist: [String: Any] = ["reference": "ref",
                                    "repositoryPath": "path"]
        let data = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)

        // When
        let got = try decoder.decode(XCLocalSwiftPackageReference.self, from: data)

        // Then
        XCTAssertEqual(got.reference.value, "ref")
        XCTAssertEqual(got.repositoryPath, "path")
    }

    func test_plistValues() throws {
        // When
        let proj = PBXProj()
        let subject = XCLocalSwiftPackageReference(repositoryPath: "repository")

        // Given
        let got = try subject.plistKeyAndValue(proj: proj, reference: "ref")

        // Then
        XCTAssertEqual(got.value, .dictionary([
            "isa": "XCLocalSwiftPackageReference",
            "repositoryPath": "repository"
        ]))
    }

    func test_equal() {
        // When
        let first = XCLocalSwiftPackageReference(repositoryPath: "repository")
        let second = XCLocalSwiftPackageReference(repositoryPath: "repository")

        // Then
        XCTAssertEqual(first, second)
    }

    func test_name() {
        // When
        let subject = XCLocalSwiftPackageReference(repositoryPath: "tuist/xcodeproj")

        // Then
        XCTAssertEqual(subject.name, "xcodeproj")
    }
}
