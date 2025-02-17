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
        let expected: BuildSettings = [
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
        ]

        // Then
        XCTAssertEqual(results, expected)
    }

    func test_targetSettings_iosFramework() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .release,
                                                          platform: .iOS,
                                                          product: .framework,
                                                          swift: true)
        let expected: BuildSettings = [
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
        ]

        // Then
        XCTAssertEqual(results, expected)
    }

    func test_targetSettings_iosExtension() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .release,
                                                          platform: .iOS,
                                                          product: .appExtension,
                                                          swift: true)
        let expected: BuildSettings = [
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
        ]
        // Then
        XCTAssertEqual(results, expected)
    }

    func test_targetSettings_macOSAplication() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .release,
                                                          platform: .macOS,
                                                          product: .application,
                                                          swift: true)

        let expected: BuildSettings = [
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
        ]
        // Then
        XCTAssertEqual(results, expected)
    }

    func test_targetSettings_tvOSAplication() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .release,
                                                          platform: .tvOS,
                                                          product: .application,
                                                          swift: true)

        let expected: BuildSettings = [
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
        ]

        // Then
        XCTAssertEqual(results, expected)
    }

    func test_targetSettings_watchOSAplication() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .release,
                                                          platform: .watchOS,
                                                          product: .application,
                                                          swift: true)

        let expected: BuildSettings = [
            "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
            "ENABLE_PREVIEWS": "YES",
            "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/Frameworks"],
            "SDKROOT": "watchos",
            "SKIP_INSTALL": "YES",
            "SWIFT_COMPILATION_MODE": "wholemodule",
            "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule",
            "TARGETED_DEVICE_FAMILY": "4",
        ]

        XCTAssertEqual(results, expected)
    }

    func test_targetSettings_watchOSFramework() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .release,
                                                          platform: .watchOS,
                                                          product: .framework,
                                                          swift: true)

        // Then
        let expected: BuildSettings = [
            "APPLICATION_EXTENSION_API_ONLY": "YES",
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
            "SDKROOT": "watchos",
            "SKIP_INSTALL": "YES",
            "SWIFT_COMPILATION_MODE": "wholemodule",
            "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule",
            "TARGETED_DEVICE_FAMILY": "4",
            "VERSIONING_SYSTEM": "apple-generic",
            "VERSION_INFO_PREFIX": "",
        ]

        XCTAssertEqual(results, expected)
    }

    func test_targetSettings_watchOSExtension() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .release,
                                                          platform: .watchOS,
                                                          product: .appExtension,
                                                          swift: true)

        // Then
        let expected: BuildSettings = [
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/Frameworks",
                "@executable_path/../../Frameworks",
                "@executable_path/../../../../Frameworks",
            ],
            "SDKROOT": "watchos",
            "SWIFT_COMPILATION_MODE": "wholemodule",
            "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule",
            "TARGETED_DEVICE_FAMILY": "4",
        ]

        XCTAssertEqual(results, expected)
    }

    func test_targetSettings_visionOSAplication() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .release,
                                                          platform: .visionOS,
                                                          product: .application,
                                                          swift: true)

        // Then
        let expected: BuildSettings = [
            "CODE_SIGN_IDENTITY": "iPhone Developer",
            "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
            "ENABLE_PREVIEWS": "YES",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/Frameworks",
            ],
            "SDKROOT": "xros",
            "SWIFT_COMPILATION_MODE": "wholemodule",
            "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule",
            "TARGETED_DEVICE_FAMILY": "1,2,7",
        ]

        XCTAssertEqual(results, expected)
    }

    func test_targetSettings_visionOSFramework() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .release,
                                                          platform: .visionOS,
                                                          product: .framework,
                                                          swift: true)

        // Then
        let expected: BuildSettings = [
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
            "SDKROOT": "xros",
            "SKIP_INSTALL": "YES",
            "SWIFT_COMPILATION_MODE": "wholemodule",
            "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule",
            "TARGETED_DEVICE_FAMILY": "1,2,7",
            "VERSIONING_SYSTEM": "apple-generic",
            "VERSION_INFO_PREFIX": "",
        ]

        XCTAssertEqual(results, expected)
    }

    func test_targetSettings_visionOSExtension() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .release,
                                                          platform: .visionOS,
                                                          product: .appExtension,
                                                          swift: true)

        // Then
        let expected: BuildSettings = [
            "CODE_SIGN_IDENTITY": "iPhone Developer",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/Frameworks",
                "@executable_path/../../Frameworks",
            ],
            "SDKROOT": "xros",
            "SWIFT_COMPILATION_MODE": "wholemodule",
            "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule",
            "TARGETED_DEVICE_FAMILY": "1,2,7",
        ]

        XCTAssertEqual(results, expected)
    }

    func test_targetSettings_iOSUnitTests() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .debug,
                                                          platform: .iOS,
                                                          product: .unitTests,
                                                          swift: true)

        let expected: BuildSettings = [
            "CODE_SIGN_IDENTITY": "iPhone Developer",
            "SDKROOT": "iphoneos",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/Frameworks",
                "@loader_path/Frameworks",
            ],
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": ["$(inherited)", "DEBUG"],
            "SWIFT_COMPILATION_MODE": "singlefile",
            "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
            "TARGETED_DEVICE_FAMILY": "1,2",
        ]

        // Then
        XCTAssertEqual(results, expected)
    }

    func test_targetSettings_iOSUITests() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .debug,
                                                          platform: .iOS,
                                                          product: .uiTests,
                                                          swift: true)
        let expected: BuildSettings = [
            "CODE_SIGN_IDENTITY": "iPhone Developer",
            "SDKROOT": "iphoneos",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/Frameworks",
                "@loader_path/Frameworks",
            ],
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": ["$(inherited)", "DEBUG"],
            "SWIFT_COMPILATION_MODE": "singlefile",
            "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
            "TARGETED_DEVICE_FAMILY": "1,2",
        ]

        // Then
        XCTAssertEqual(results, expected)
    }

    func test_targetSettings_macOSUnitTests() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .debug,
                                                          platform: .macOS,
                                                          product: .unitTests,
                                                          swift: true)

        let expected: BuildSettings = [
            "CODE_SIGN_IDENTITY": "-",
            "SDKROOT": "macosx",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/../Frameworks",
                "@loader_path/../Frameworks",
            ],
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": ["$(inherited)", "DEBUG"],
            "SWIFT_COMPILATION_MODE": "singlefile",
            "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
        ]

        // Then
        XCTAssertEqual(results, expected)
    }

    func test_targetSettings_tvOSUnitTests() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .debug,
                                                          platform: .tvOS,
                                                          product: .unitTests,
                                                          swift: true)
        let expected: BuildSettings = [
            "SDKROOT": "appletvos",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/Frameworks",
                "@loader_path/Frameworks",
            ],
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": ["$(inherited)", "DEBUG"],
            "SWIFT_COMPILATION_MODE": "singlefile",
            "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
            "TARGETED_DEVICE_FAMILY": "3",
        ]

        // Then
        XCTAssertEqual(results, expected)
    }

    func test_targetSettings_visionOSUnitTests() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .debug,
                                                          platform: .visionOS,
                                                          product: .unitTests,
                                                          swift: true)

        // Then
        let expected: BuildSettings = [
            "CODE_SIGN_IDENTITY": "iPhone Developer",
            "SDKROOT": "xros",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/Frameworks",
                "@loader_path/Frameworks",
            ],
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": ["$(inherited)", "DEBUG"],
            "SWIFT_COMPILATION_MODE": "singlefile",
            "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
            "TARGETED_DEVICE_FAMILY": "1,2,7",
        ]

        XCTAssertEqual(results, expected)
    }

    func test_targetSettings_visionOSUITests() {
        // Given / When
        let results = BuildSettingsProvider.targetDefault(variant: .debug,
                                                          platform: .visionOS,
                                                          product: .uiTests,
                                                          swift: true)

        // Then
        let expected: BuildSettings = [
            "CODE_SIGN_IDENTITY": "iPhone Developer",
            "SDKROOT": "xros",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/Frameworks",
                "@loader_path/Frameworks",
            ],
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": ["$(inherited)", "DEBUG"],
            "SWIFT_COMPILATION_MODE": "singlefile",
            "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
            "TARGETED_DEVICE_FAMILY": "1,2,7",
        ]

        XCTAssertEqual(results, expected)
    }

    // MARK: - Helpers

//    func XCTAssertEqual(_ lhs: BuildSettings, _ rhs: BuildSettings, file: StaticString = #file, line: UInt = #line) {
//        XCTAssertEqual(lhs as NSDictionary,
//                       rhs as NSDictionary,
//                       file: file,
//                       line: line)
//    }
}
