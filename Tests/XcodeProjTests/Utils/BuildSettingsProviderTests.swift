import Foundation
import XCTest
@testable import XcodeProj

class BuildSettingProviderTests: XCTestCase {
    func test_targetSettings_iosAplication() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .release,
                                                          platform: .iOS,
                                                          product: .application,
                                                          swift: true)

        // Then
        assertEqualSettings(results, [
            "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
            "ENABLE_PREVIEWS": "YES",
            "CODE_SIGN_IDENTITY": "iPhone Developer",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/Frameworks",
            ],
            "SDKROOT": "iphoneos",
            "SWIFT_COMPILATION_MODE": "wholemodule",
            "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule",
            "TARGETED_DEVICE_FAMILY": "1,2",
        ])
    }

    func test_targetSettings_iosFramework() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .release,
                                                          platform: .iOS,
                                                          product: .framework,
                                                          swift: true)

        // Then
        assertEqualSettings(results, [
            "CODE_SIGN_IDENTITY": "",
            "CURRENT_PROJECT_VERSION": "1",
            "DEFINES_MODULE": "YES",
            "DYLIB_COMPATIBILITY_VERSION": "1",
            "DYLIB_CURRENT_VERSION": "1",
            "DYLIB_INSTALL_NAME_BASE": "@rpath",
            "INSTALL_PATH": "$(LOCAL_LIBRARY_DIR)/Frameworks",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/Frameworks",
                "@loader_path/Frameworks",
            ],
            "PRODUCT_NAME": "$(TARGET_NAME:c99extidentifier)",
            "SDKROOT": "iphoneos",
            "SKIP_INSTALL": "YES",
            "SWIFT_COMPILATION_MODE": "wholemodule",
            "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule",
            "TARGETED_DEVICE_FAMILY": "1,2",
            "VERSIONING_SYSTEM": "apple-generic",
            "VERSION_INFO_PREFIX": "",
        ])
    }

    func test_targetSettings_iosExtension() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .release,
                                                          platform: .iOS,
                                                          product: .appExtension,
                                                          swift: true)

        // Then
        assertEqualSettings(results, [
            "CODE_SIGN_IDENTITY": "iPhone Developer",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/Frameworks",
                "@executable_path/../../Frameworks",
            ],
            "SDKROOT": "iphoneos",
            "SWIFT_COMPILATION_MODE": "wholemodule",
            "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule",
            "TARGETED_DEVICE_FAMILY": "1,2",
        ])
    }

    func test_targetSettings_macOSAplication() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .release,
                                                          platform: .macOS,
                                                          product: .application,
                                                          swift: true)

        // Then
        assertEqualSettings(results, [
            "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
            "ENABLE_PREVIEWS": "YES",
            "CODE_SIGN_IDENTITY": "-",
            "COMBINE_HIDPI_IMAGES": "YES",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/../Frameworks",
            ],
            "SDKROOT": "macosx",
            "SWIFT_COMPILATION_MODE": "wholemodule",
            "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule",
        ])
    }

    func test_targetSettings_tvOSAplication() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .release,
                                                          platform: .tvOS,
                                                          product: .application,
                                                          swift: true)

        // Then
        assertEqualSettings(results, [
            "ASSETCATALOG_COMPILER_APPICON_NAME": "App Icon & Top Shelf Image",
            "ENABLE_PREVIEWS": "YES",
            "ASSETCATALOG_COMPILER_LAUNCHIMAGE_NAME": "LaunchImage",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/Frameworks",
            ],
            "SDKROOT": "appletvos",
            "SWIFT_COMPILATION_MODE": "wholemodule",
            "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule",
            "TARGETED_DEVICE_FAMILY": "3",
        ])
    }

    func test_targetSettings_watchOSAplication() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .release,
                                                          platform: .watchOS,
                                                          product: .application,
                                                          swift: true)

        // Then
        assertEqualSettings(results, [
            "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES": "YES",
            "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
            "ENABLE_PREVIEWS": "YES",
            "SDKROOT": "watchos",
            "SKIP_INSTALL": "YES",
            "SWIFT_COMPILATION_MODE": "wholemodule",
            "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule",
            "TARGETED_DEVICE_FAMILY": "4",
        ])
    }

    func test_targetSettings_iOSUnitTests() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .debug,
                                                          platform: .iOS,
                                                          product: .unitTests,
                                                          swift: true)

        // Then
        assertEqualSettings(results, [
            "CODE_SIGN_IDENTITY": "iPhone Developer",
            "SDKROOT": "iphoneos",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/Frameworks",
                "@loader_path/Frameworks",
            ],
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
            "SWIFT_COMPILATION_MODE": "singlefile",
            "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
            "TARGETED_DEVICE_FAMILY": "1,2",
        ])
    }

    func test_targetSettings_iOSUITests() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .debug,
                                                          platform: .iOS,
                                                          product: .uiTests,
                                                          swift: true)

        // Then
        assertEqualSettings(results, [
            "CODE_SIGN_IDENTITY": "iPhone Developer",
            "SDKROOT": "iphoneos",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/Frameworks",
                "@loader_path/Frameworks",
            ],
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
            "SWIFT_COMPILATION_MODE": "singlefile",
            "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
            "TARGETED_DEVICE_FAMILY": "1,2",
        ])
    }

    func test_targetSettings_macOSUnitTests() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .debug,
                                                          platform: .macOS,
                                                          product: .unitTests,
                                                          swift: true)

        // Then
        assertEqualSettings(results, [
            "CODE_SIGN_IDENTITY": "-",
            "SDKROOT": "macosx",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/../Frameworks",
                "@loader_path/../Frameworks",
            ],
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
            "SWIFT_COMPILATION_MODE": "singlefile",
            "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
        ])
    }

    func test_targetSettings_tvOSUnitTests() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .debug,
                                                          platform: .tvOS,
                                                          product: .unitTests,
                                                          swift: true)

        // Then
        assertEqualSettings(results, [
            "SDKROOT": "appletvos",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/Frameworks",
                "@loader_path/Frameworks",
            ],
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
            "SWIFT_COMPILATION_MODE": "singlefile",
            "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
            "TARGETED_DEVICE_FAMILY": "3",
        ])
    }

    // MARK: - Helpers

    func assertEqualSettings(_ lhs: BuildSettings, _ rhs: BuildSettings, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(lhs as NSDictionary,
                       rhs as NSDictionary,
                       file: file,
                       line: line)
    }
}
