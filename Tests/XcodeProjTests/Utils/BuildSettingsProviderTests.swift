import Foundation
import Testing
@testable import XcodeProj

@Suite("Build setting provider tests")
struct BuildSettingProviderTests {
    @Test(
        "Target settings",
        arguments: [
            TestParameters(
                title: "iOS App",
                results: BuildSettingsProvider.targetDefault(variant: .release, platform: .iOS, product: .application, swift: true),
                expectedOutput: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                    "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
                    "ENABLE_PREVIEWS": "YES",
                    "CODE_SIGN_IDENTITY": "iPhone Developer",
                    "LD_RUNPATH_SEARCH_PATHS": [
                        "$(inherited)",
                        "@executable_path/Frameworks",
                    ],
                    "SDKROOT": "iphoneos",
                    "SWIFT_COMPILATION_MODE": "wholemodule",
                    "SWIFT_OPTIMIZATION_LEVEL": "-O",
                    "TARGETED_DEVICE_FAMILY": "1,2",
                ]
            ),
            TestParameters(
                title: "iOS Framework",
                results: BuildSettingsProvider.targetDefault(variant: .release, platform: .iOS, product: .framework, swift: true),
                expectedOutput: [
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
                    "SWIFT_OPTIMIZATION_LEVEL": "-O",
                    "TARGETED_DEVICE_FAMILY": "1,2",
                    "VERSIONING_SYSTEM": "apple-generic",
                    "VERSION_INFO_PREFIX": "",
                ]
            ),
            TestParameters(
                title: "iOS App extension",
                results: BuildSettingsProvider.targetDefault(variant: .release, platform: .iOS, product: .appExtension, swift: true),
                expectedOutput: [
                    "CODE_SIGN_IDENTITY": "iPhone Developer",
                    "LD_RUNPATH_SEARCH_PATHS": [
                        "$(inherited)",
                        "@executable_path/Frameworks",
                        "@executable_path/../../Frameworks",
                    ],
                    "SDKROOT": "iphoneos",
                    "SWIFT_COMPILATION_MODE": "wholemodule",
                    "SWIFT_OPTIMIZATION_LEVEL": "-O",
                    "TARGETED_DEVICE_FAMILY": "1,2",
                ]
            ),
            TestParameters(
                title: "macOS App",
                results: BuildSettingsProvider.targetDefault(variant: .release, platform: .macOS, product: .application, swift: true),
                expectedOutput: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                    "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
                    "ENABLE_PREVIEWS": "YES",
                    "CODE_SIGN_IDENTITY": "-",
                    "COMBINE_HIDPI_IMAGES": "YES",
                    "LD_RUNPATH_SEARCH_PATHS": [
                        "$(inherited)",
                        "@executable_path/../Frameworks",
                    ],
                    "SDKROOT": "macosx",
                    "SWIFT_COMPILATION_MODE": "wholemodule",
                    "SWIFT_OPTIMIZATION_LEVEL": "-O",
                ]
            ),
            TestParameters(
                title: "tvOS App",
                results: BuildSettingsProvider.targetDefault(variant: .release, platform: .tvOS, product: .application, swift: true),
                expectedOutput: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "App Icon & Top Shelf Image",
                    "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
                    "ENABLE_PREVIEWS": "YES",
                    "ASSETCATALOG_COMPILER_LAUNCHIMAGE_NAME": "LaunchImage",
                    "LD_RUNPATH_SEARCH_PATHS": [
                        "$(inherited)",
                        "@executable_path/Frameworks",
                    ],
                    "SDKROOT": "appletvos",
                    "SWIFT_COMPILATION_MODE": "wholemodule",
                    "SWIFT_OPTIMIZATION_LEVEL": "-O",
                    "TARGETED_DEVICE_FAMILY": "3",
                ]
            ),
            TestParameters(
                title: "watchOS App",
                results: BuildSettingsProvider.targetDefault(variant: .release, platform: .watchOS, product: .application, swift: true),
                expectedOutput: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                    "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
                    "ENABLE_PREVIEWS": "YES",
                    "LD_RUNPATH_SEARCH_PATHS": [
                        "$(inherited)",
                        "@executable_path/Frameworks",
                    ],
                    "SDKROOT": "watchos",
                    "SKIP_INSTALL": "YES",
                    "SWIFT_COMPILATION_MODE": "wholemodule",
                    "SWIFT_OPTIMIZATION_LEVEL": "-O",
                    "TARGETED_DEVICE_FAMILY": "4",
                ]
            ),
            TestParameters(
                title: "watchOS Framework",
                results: BuildSettingsProvider.targetDefault(variant: .release, platform: .watchOS, product: .framework, swift: true),
                expectedOutput: [
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
                    "SWIFT_OPTIMIZATION_LEVEL": "-O",
                    "TARGETED_DEVICE_FAMILY": "4",
                    "VERSIONING_SYSTEM": "apple-generic",
                    "VERSION_INFO_PREFIX": "",
                ]
            ),
            TestParameters(
                title: "watchOS App extension",
                results: BuildSettingsProvider.targetDefault(variant: .release, platform: .watchOS, product: .appExtension, swift: true),
                expectedOutput: [
                    "LD_RUNPATH_SEARCH_PATHS": [
                        "$(inherited)",
                        "@executable_path/Frameworks",
                        "@executable_path/../../Frameworks",
                        "@executable_path/../../../../Frameworks",
                    ],
                    "SDKROOT": "watchos",
                    "SWIFT_COMPILATION_MODE": "wholemodule",
                    "SWIFT_OPTIMIZATION_LEVEL": "-O",
                    "TARGETED_DEVICE_FAMILY": "4",
                ]
            ),
            TestParameters(
                title: "visionOS App",
                results: BuildSettingsProvider.targetDefault(variant: .release, platform: .visionOS, product: .application, swift: true),
                expectedOutput: [
                    "CODE_SIGN_IDENTITY": "iPhone Developer",
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                    "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
                    "ENABLE_PREVIEWS": "YES",
                    "LD_RUNPATH_SEARCH_PATHS": [
                        "$(inherited)",
                        "@executable_path/Frameworks",
                    ],
                    "SDKROOT": "xros",
                    "SWIFT_COMPILATION_MODE": "wholemodule",
                    "SWIFT_OPTIMIZATION_LEVEL": "-O",
                    "TARGETED_DEVICE_FAMILY": "1,2,7",
                ]
            ),
            TestParameters(
                title: "visionOS Framework",
                results: BuildSettingsProvider.targetDefault(variant: .release, platform: .visionOS, product: .framework, swift: true),
                expectedOutput: [
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
                    "SWIFT_OPTIMIZATION_LEVEL": "-O",
                    "TARGETED_DEVICE_FAMILY": "1,2,7",
                    "VERSIONING_SYSTEM": "apple-generic",
                    "VERSION_INFO_PREFIX": "",
                ]
            ),
            TestParameters(
                title: "visionOS App extension",
                results: BuildSettingsProvider.targetDefault(variant: .release, platform: .visionOS, product: .appExtension, swift: true),
                expectedOutput: [
                    "CODE_SIGN_IDENTITY": "iPhone Developer",
                    "LD_RUNPATH_SEARCH_PATHS": [
                        "$(inherited)",
                        "@executable_path/Frameworks",
                        "@executable_path/../../Frameworks",
                    ],
                    "SDKROOT": "xros",
                    "SWIFT_COMPILATION_MODE": "wholemodule",
                    "SWIFT_OPTIMIZATION_LEVEL": "-O",
                    "TARGETED_DEVICE_FAMILY": "1,2,7",
                ]
            ),
            TestParameters(
                title: "iOS Unit tests",
                results: BuildSettingsProvider.targetDefault(variant: .debug, platform: .iOS, product: .unitTests, swift: true),
                expectedOutput: [
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
            ),
            TestParameters(
                title: "iOS UI tests",
                results: BuildSettingsProvider.targetDefault(variant: .debug, platform: .iOS, product: .uiTests, swift: true),
                expectedOutput: [
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
            ),
            TestParameters(
                title: "macOS Unit tests",
                results: BuildSettingsProvider.targetDefault(variant: .debug, platform: .macOS, product: .unitTests, swift: true),
                expectedOutput: [
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
            ),
            TestParameters(
                title: "tvOS Unit tests",
                results: BuildSettingsProvider.targetDefault(variant: .debug, platform: .tvOS, product: .unitTests, swift: true),
                expectedOutput: [
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
            ),
            TestParameters(
                title: "visionOS Unit tests",
                results: BuildSettingsProvider.targetDefault(variant: .debug, platform: .visionOS, product: .unitTests, swift: true),
                expectedOutput: [
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
            ),
            TestParameters(
                title: "visionOS UI tests",
                results: BuildSettingsProvider.targetDefault(variant: .debug, platform: .visionOS, product: .uiTests, swift: true),
                expectedOutput: [
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
            ),
        ]
    )
    func targetSettings(parameters: TestParameters) {
        // Given / When / Then
        #expect(parameters.results == parameters.expectedOutput)
    }

    struct TestParameters: CustomTestStringConvertible {
        let title: String
        let results: BuildSettings
        let expectedOutput: BuildSettings

        var testDescription: String {
            title
        }
    }
}
