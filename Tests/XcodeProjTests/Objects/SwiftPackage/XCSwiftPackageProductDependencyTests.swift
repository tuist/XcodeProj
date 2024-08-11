import Foundation
import XCTest

@testable import XcodeProj

final class XCSwiftPackageProductDependencyTests: XCTestCase {
    func test_init() throws {
        // Given
        let decoder = XcodeprojPropertyListDecoder()
        let encoder = PropertyListEncoder()
        let plist = ["reference": [
                     "productName": "xcodeproj",
                     "package": "packageReference"]
        ]
        let data = try encoder.encode(plist)

        // When
        let decoded = try decoder.decode([String: XCSwiftPackageProductDependency].self, from: data)
        let got = try XCTUnwrap(decoded["reference"])

        // Then
        XCTAssertEqual(got.productName, "xcodeproj")
        XCTAssertEqual(got.packageReference?.value, "packageReference")
        XCTAssertEqual(got.isPlugin, false)
    }

    func test_initAsPlugin() throws {
        // Given
        let decoder = XcodeprojPropertyListDecoder()
        let encoder = PropertyListEncoder()
        let plist = ["reference": [
                     "productName": "plugin:xcodeproj",
                     "package": "packageReference"]]
        let data = try encoder.encode(plist)

        // When
        let decoded = try decoder.decode([String: XCSwiftPackageProductDependency].self, from: data)
        let got = try XCTUnwrap(decoded["reference"])

        // Then
        XCTAssertEqual(got.productName, "xcodeproj")
        XCTAssertEqual(got.packageReference?.value, "packageReference")
        XCTAssertEqual(got.isPlugin, true)
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

    func test_plistValuesAsPlugin() throws {
        // Given
        let proj = PBXProj()
        let package = XCRemoteSwiftPackageReference(repositoryURL: "repository")
        let subject = XCSwiftPackageProductDependency(productName: "product",
                                                      package: package,
                                                      isPlugin: true)

        // When
        let got = try subject.plistKeyAndValue(proj: proj, reference: "reference")

        // Then
        XCTAssertEqual(got.value, .dictionary([
            "isa": "XCSwiftPackageProductDependency",
            "productName": "plugin:product",
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

    func test_isPlugin() {
        // Given
        let plugin = XCSwiftPackageProductDependency(productName: "product", isPlugin: true)

        // Then
        XCTAssertTrue(plugin.isPlugin)
    }

    func test_isNotPlugin() {
        // Given
        let plugin = XCSwiftPackageProductDependency(productName: "product")

        // Then
        XCTAssertFalse(plugin.isPlugin)
    }
}
