import Foundation
import XCTest

@testable import XcodeProj

final class XCRemoteSwiftPackageReferenceTests: XCTestCase {
    func test_init() throws {
        // Given
        let decoder = XcodeprojPropertyListDecoder()
        let plist: [String: Any] = ["reference": "ref",
                                    "repositoryURL": "url",
                                    "requirement": [
                                        "kind": "revision",
                                        "revision": "abc",
                                    ]]
        let data = try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: 0)

        // When
        let got = try decoder.decode(XCRemoteSwiftPackageReference.self, from: data)

        // Then
        XCTAssertEqual(got.reference.value, "ref")
        XCTAssertEqual(got.repositoryURL, "url")
        XCTAssertEqual(got.versionRequirement, XCRemoteSwiftPackageReference.VersionRequirement.revision("abc"))
    }

    func test_versionRequirement_returnsTheRightPlistValues_when_revision() throws {
        // When
        let subject = XCRemoteSwiftPackageReference.VersionRequirement.revision("sha")

        // Given
        let got = subject.plistValues()

        // Then
        XCTAssertEqual(got, [
            "kind": "revision",
            "revision": .string(.init("sha")),
        ])
    }

    func test_versionRequirement_returnsTheRightPlistValues_when_branch() throws {
        // When
        let subject = XCRemoteSwiftPackageReference.VersionRequirement.branch("main")

        // Given
        let got = subject.plistValues()

        // Then
        XCTAssertEqual(got, [
            "kind": "branch",
            "branch": .string(.init("main")),
        ])
    }

    func test_versionRequirement_returnsTheRightPlistValues_when_exact() throws {
        // When
        let subject = XCRemoteSwiftPackageReference.VersionRequirement.exact("3.2.1")

        // Given
        let got = subject.plistValues()

        // Then
        XCTAssertEqual(got, [
            "kind": "exactVersion",
            "version": .string(.init("3.2.1")),
        ])
    }

    func test_versionRequirement_returnsTheRightPlistValues_when_upToNextMajorVersion() throws {
        // When
        let subject = XCRemoteSwiftPackageReference.VersionRequirement.upToNextMajorVersion("3.2.1")

        // Given
        let got = subject.plistValues()

        // Then
        XCTAssertEqual(got, [
            "kind": "upToNextMajorVersion",
            "minimumVersion": .string(.init("3.2.1")),
        ])
    }

    func test_versionRequirement_returnsTheRightPlistValues_when_range() throws {
        // When
        let subject = XCRemoteSwiftPackageReference.VersionRequirement.range(from: "3.2.1", to: "4.0.0")

        // Given
        let got = subject.plistValues()

        // Then
        XCTAssertEqual(got, [
            "kind": "versionRange",
            "minimumVersion": .string(.init("3.2.1")),
            "maximumVersion": .string(.init("4.0.0")),
        ])
    }

    func test_versionRequirement_returnsTheRightPlistValues_when_upToNextMinorVersion() throws {
        // When
        let subject = XCRemoteSwiftPackageReference.VersionRequirement.upToNextMinorVersion("3.2.1")

        // Given
        let got = subject.plistValues()

        // Then
        XCTAssertEqual(got, [
            "kind": "upToNextMinorVersion",
            "minimumVersion": .string(.init("3.2.1")),
        ])
    }

    func test_plistValues() throws {
        // When
        let proj = PBXProj()
        let subject = XCRemoteSwiftPackageReference(repositoryURL: "repository",
                                                    versionRequirement: .exact("1.2.3"))

        // Given
        let got = try subject.plistKeyAndValue(proj: proj, reference: "ref")

        // Then
        XCTAssertEqual(got.value, .dictionary([
            "isa": "XCRemoteSwiftPackageReference",
            "repositoryURL": "repository",
            "requirement": .dictionary([
                "kind": "exactVersion",
                "version": "1.2.3",
            ]),
        ]))
    }

    func test_equal() {
        // When
        let first = XCRemoteSwiftPackageReference(repositoryURL: "repository",
                                                  versionRequirement: .exact("1.2.3"))
        let second = XCRemoteSwiftPackageReference(repositoryURL: "repository",
                                                   versionRequirement: .exact("1.2.3"))

        // Then
        XCTAssertEqual(first, second)
    }

    func test_name() {
        // When
        let subject = XCRemoteSwiftPackageReference(repositoryURL: "https://github.com/tuist/xcodeproj", versionRequirement: nil)

        // Then
        XCTAssertEqual(subject.name, "xcodeproj")
    }
}
