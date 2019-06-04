import Foundation
import XCTest

@testable import XcodeProj

final class XCRemoteSwiftPackageReferenceTests: XCTestCase {
    func test_versionRules_returnsTheRightPlistValues_when_revision() throws {
        // When
        let subject = XCRemoteSwiftPackageReference.VersionRules.revision("sha")

        // Given
        let got = try subject.plistValues()

        // Then
        XCTAssertEqual(got, [
            "kind": "revision",
            "revision": .string(.init("sha")),
        ])
    }

    func test_versionRules_returnsTheRightPlistValues_when_branch() throws {
        // When
        let subject = XCRemoteSwiftPackageReference.VersionRules.branch("master")

        // Given
        let got = try subject.plistValues()

        // Then
        XCTAssertEqual(got, [
            "kind": "branch",
            "branch": .string(.init("master")),
        ])
    }

    func test_versionRules_returnsTheRightPlistValues_when_exact() throws {
        // When
        let subject = XCRemoteSwiftPackageReference.VersionRules.exact("3.2.1")

        // Given
        let got = try subject.plistValues()

        // Then
        XCTAssertEqual(got, [
            "kind": "exactVersion",
            "minimumVersion": .string(.init("3.2.1")),
        ])
    }

    func test_versionRules_returnsTheRightPlistValues_when_upToNextMajorVersion() throws {
        // When
        let subject = XCRemoteSwiftPackageReference.VersionRules.upToNextMajorVersion("3.2.1")

        // Given
        let got = try subject.plistValues()

        // Then
        XCTAssertEqual(got, [
            "kind": "upToNextMajorVersion",
            "minimumVersion": .string(.init("3.2.1")),
        ])
    }

    func test_versionRules_returnsTheRightPlistValues_when_range() throws {
        // When
        let subject = XCRemoteSwiftPackageReference.VersionRules.range(from: "3.2.1", to: "4.0.0")

        // Given
        let got = try subject.plistValues()

        // Then
        XCTAssertEqual(got, [
            "kind": "versionRange",
            "minimumVersion": .string(.init("3.2.1")),
            "maximumVersion": .string(.init("4.0.0")),
        ])
    }

    func test_versionRules_returnsTheRightPlistValues_when_upToNextMinorVersion() throws {
        // When
        let subject = XCRemoteSwiftPackageReference.VersionRules.upToNextMinorVersion("3.2.1")

        // Given
        let got = try subject.plistValues()

        // Then
        XCTAssertEqual(got, [
            "kind": "upToNextMinorVersion",
            "minimumVersion": .string(.init("3.2.1")),
        ])
    }
}
