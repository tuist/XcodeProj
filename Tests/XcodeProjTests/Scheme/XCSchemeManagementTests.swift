import Foundation
import XCTest
import AEXML
import PathKit
@testable import XcodeProj

final class XCSchemeManagementTests: XCTestCase {
    func test_init_from_path() throws {
        // Given
        let path = xcschememanagementPath
        
        // When
        let got = try XCSchemeManagement.init(path: path)
        
        // Then
        XCTAssertEqual(got.suppressBuildableAutocreation, [
            "E525238B16245A900012E2BA": .init(primary: true),
        ])

        XCTAssertEqual(got.schemeUserState, [
            .init(name: "App.xcscheme", shared: false, orderHint: 0, isShown: false),
            .init(name: "Test 0.xcscheme", shared: false, orderHint: 3, isShown: nil),
            .init(name: "Test 1.xcscheme", shared: false, orderHint: 4, isShown: false),
            .init(name: "Tuist.xcscheme", shared: true, orderHint: 1, isShown: true),
            .init(name: "XcodeProj.xcscheme", shared: false, orderHint: 2, isShown: nil),
        ])
    }

    func test_read_write_produces_no_diff() throws {
        try testReadWriteProducesNoDiff(from: xcschememanagementPath, initModel: XCSchemeManagement.init(path:))
    }

    func test_read_is_stable() throws {
        // Given
        let path = xcschememanagementPath

        // When
        let reads = try (0..<10).map { _ in
            try XCSchemeManagement(path: path)
        }

        // Then
        let unstableReads = reads.dropFirst().filter { $0 != reads.first }
        XCTAssertTrue(unstableReads.isEmpty)
    }

    func test_write_produces_no_diff() throws {
        let tmpDir = try Path.uniqueTemporary()
        defer {
            try? tmpDir.delete()
        }

        try tmpDir.chdir {
            // Write
            let plistPath = tmpDir + "xcschememanagement.plist"
            let subject = XCSchemeManagement(
                schemeUserState: [
                    .init(name: "Test 0.xcscheme", shared: true, orderHint: 0, isShown: true),
                    .init(name: "Test 1.xcscheme", shared: true, orderHint: 1, isShown: true),
                    .init(name: "Test 2.xcscheme", shared: true, orderHint: 2, isShown: false),
                    .init(name: "Test 3.xcscheme", shared: true, orderHint: 3, isShown: true),
                ],
                suppressBuildableAutocreation: [
                    "E525238B16245A900012E2BA": .init(primary: true),
                ]
            )
            try subject.write(path: plistPath, override: true)
            
            // Create a commit
            try checkedOutput("git", ["init"])
            try checkedOutput("git", ["add", "."])
            try checkedOutput("git", ["commit", "-m", "test"])
            
            // Write again
            try subject.write(path: plistPath, override: true)

            let got = try checkedOutput("git", ["status"])
            XCTAssertTrue(got?.contains("nothing to commit") ?? false)
        }
    }

    private var xcschememanagementPath: Path {
        fixturesPath() + "Schemes/xcschememanagement.plist"
    }
}
