import Foundation
import PathKit
import XCTest

@testable import XcodeProj

final class WorkspaceSettingsTests: XCTestCase {
    func test_init_when_original_build_system() throws {
        let path = fixturesPath() + "WorkspaceSettings/OriginalBuildSystem.xcsettings"
        let got = try WorkspaceSettings.at(path: path)
        XCTAssertEqual(got.buildSystem, .original)
    }

    func test_init_when_new_build_system() throws {
        let path = fixturesPath() + "WorkspaceSettings/Default.xcsettings"
        let got = try WorkspaceSettings.at(path: path)
        XCTAssertEqual(got.buildSystem, .new)
    }

    func test_init_when_autoCreateSchemes_is_true() throws {
        let path = fixturesPath() + "WorkspaceSettings/Default.xcsettings"
        let got = try WorkspaceSettings.at(path: path)
        XCTAssertTrue(got.autoCreateSchemes == true)
    }

    func test_init_when_relative_derivedData_is_enabled() throws {
        let path = fixturesPath() + "WorkspaceSettings/OriginalRelativeDerivedData.xcsettings"
        let got = try WorkspaceSettings.at(path: path)
        XCTAssertTrue(got.derivedDataCustomLocation == "CustomizedDerivedData")
        XCTAssertTrue(got.derivedDataLocationStyle == .workspaceRelativePath)
    }
    
    func test_init_when_absolute_derivedData_is_enabled() throws {
        let path = fixturesPath() + "WorkspaceSettings/OriginalAbsoluteDerivedData.xcsettings"
        let got = try WorkspaceSettings.at(path: path)
        XCTAssertTrue(got.derivedDataCustomLocation == "/User/xcodeproj/DerivedData")
        XCTAssertTrue(got.derivedDataLocationStyle == .absolutePath)
    }

    func test_equals() {
        let lhs = WorkspaceSettings(buildSystem: .new)
        let rhs = WorkspaceSettings(buildSystem: .original)
        XCTAssertNotEqual(lhs, rhs)
    }

    func test_write() throws {
        try withTemporaryDirectory { tmp in
            let path = fixturesPath() + "WorkspaceSettings/Default.xcsettings"
            let copyPath = tmp + "Default.xcsettings"

            var settings = try WorkspaceSettings.at(path: path)
            settings.buildSystem = .original
            settings.derivedDataLocationStyle = .workspaceRelativePath
            settings.derivedDataCustomLocation = "DerivedData"
            try settings.write(path: copyPath, override: true)

            settings = try WorkspaceSettings.at(path: copyPath)
            XCTAssertEqual(settings.buildSystem, .original)
            XCTAssertEqual(settings.derivedDataLocationStyle, .workspaceRelativePath)
            XCTAssertEqual(settings.derivedDataCustomLocation, "DerivedData")
        }
    }
}
