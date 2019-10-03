import Foundation
import XCTest

@testable import XcodeProj

final class XCSwiftPackageProductDependencyTests: XCTestCase {
    func test_init() throws {
        // Given
        let decoder = XcodeprojPropertyListDecoder()
        let encoder = PropertyListEncoder()
        let plist = ["reference": "reference",
                     "productName": "xcodeproj",
                     "package": "packageReference"]
        let data = try encoder.encode(plist)

        // When
        let got = try decoder.decode(XCSwiftPackageProductDependency.self, from: data)

        // Then
        XCTAssertEqual(got.productName, "xcodeproj")
        XCTAssertEqual(got.packageReference?.value, "packageReference")
    }

    func test_plistValues() throws {
        // Given
        let proj = PBXProj()
        let package = XCRemoteSwiftPackageReference(repositoryURL: "repository")
        let subject = XCSwiftPackageProductDependency(productName: "product",
                                                      package: package)

        // When
        let got = try subject.plistKeyAndValue(proj: proj, reference: "reference")

        // Then
        XCTAssertEqual(got.value, .dictionary([
            "isa": "XCSwiftPackageProductDependency",
            "productName": "product",
            "package": .string(.init(package.reference.value, comment: "XCRemoteSwiftPackageReference \"\(package.name ?? "")\"")),
        ]))
    }

    func test_equal() {
        // Given
        let package = XCRemoteSwiftPackageReference(repositoryURL: "repository")
        let first = XCSwiftPackageProductDependency(productName: "product",
                                                    package: package)
        let second = XCSwiftPackageProductDependency(productName: "product",
                                                     package: package)

        // Then
        XCTAssertEqual(first, second)
    }
}
