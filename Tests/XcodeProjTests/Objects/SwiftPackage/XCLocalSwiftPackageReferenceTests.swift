import Foundation
import XCTest

@testable import XcodeProj

final class XCLocalSwiftPackageReferenceTests: XCTestCase {
    func test_init() throws {
        // Given
        let decoder = XcodeprojPropertyListDecoder()
        let plist: [String: [String: Any]] = ["ref": ["relativePath": "path"]]

        let data = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)

        // When
        let decoded = try decoder.decode([String: XCLocalSwiftPackageReference].self, from: data)
        let got = try XCTUnwrap(decoded["ref"])

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
            "relativePath": "repository",
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

    // MARK: - Add/Delete Tests

    func test_add_addsObjectToPBXProj() {
        // Given
        let proj = PBXProj.fixture(rootObject: nil, objects: [])
        let localPackage = XCLocalSwiftPackageReference(relativePath: "../MyPackage")

        // When
        proj.add(object: localPackage)

        // Then
        XCTAssertEqual(proj.objects.localSwiftPackageReferences.count, 1)
        XCTAssertEqual(proj.objects.localSwiftPackageReferences.values.first?.relativePath, "../MyPackage")
    }

    func test_delete_removesObjectFromPBXProj() {
        // Given
        let proj = PBXProj.fixture(rootObject: nil, objects: [])
        let localPackage = XCLocalSwiftPackageReference(relativePath: "../MyPackage")
        proj.add(object: localPackage)

        // Verify it was added
        XCTAssertEqual(proj.objects.localSwiftPackageReferences.count, 1)

        // When
        proj.delete(object: localPackage)

        // Then
        XCTAssertEqual(proj.objects.localSwiftPackageReferences.count, 0)
    }

    func test_delete_removesCorrectObject_whenMultipleExist() {
        // Given
        let proj = PBXProj.fixture(rootObject: nil, objects: [])
        let localPackage1 = XCLocalSwiftPackageReference(relativePath: "../Package1")
        let localPackage2 = XCLocalSwiftPackageReference(relativePath: "../Package2")
        let localPackage3 = XCLocalSwiftPackageReference(relativePath: "../Package3")
        proj.add(object: localPackage1)
        proj.add(object: localPackage2)
        proj.add(object: localPackage3)

        // Verify all were added
        XCTAssertEqual(proj.objects.localSwiftPackageReferences.count, 3)

        // When - delete the middle one
        proj.delete(object: localPackage2)

        // Then
        XCTAssertEqual(proj.objects.localSwiftPackageReferences.count, 2)
        let remainingPaths = proj.objects.localSwiftPackageReferences.values.map(\.relativePath)
        XCTAssertTrue(remainingPaths.contains("../Package1"))
        XCTAssertTrue(remainingPaths.contains("../Package3"))
        XCTAssertFalse(remainingPaths.contains("../Package2"))
    }

    func test_delete_doesNothing_whenObjectNotInProj() {
        // Given
        let proj = PBXProj.fixture(rootObject: nil, objects: [])
        let addedPackage = XCLocalSwiftPackageReference(relativePath: "../AddedPackage")
        let notAddedPackage = XCLocalSwiftPackageReference(relativePath: "../NotAddedPackage")
        proj.add(object: addedPackage)

        // When - try to delete an object that was never added
        proj.delete(object: notAddedPackage)

        // Then - the added package should still be there
        XCTAssertEqual(proj.objects.localSwiftPackageReferences.count, 1)
        XCTAssertEqual(proj.objects.localSwiftPackageReferences.values.first?.relativePath, "../AddedPackage")
    }
}
