import Foundation

/// Class that provides default build settings to be used in Xcode projects.
// swiftlint:disable:next type_body_length
public class BuildSettingsProvider {
    /// Build settings variant.
    ///
    /// - all: all (debug & release).
    /// - debug: debug.
    /// - release: release.
    public enum Variant {
        case all, debug, release
    }

    /// Target platform.
    ///
    /// - iOS: iOS.
    /// - macOS: macOS.
    /// - tvOS: tvOS.
    /// - watchOS: watchOS.
    public enum Platform {
        case iOS, macOS, tvOS, watchOS, visionOS
    }

    /// Target product type.
    ///
    /// - framework: framework.
    /// - staticLibrary: static library.
    /// - dynamicLibrary: dynamic library.
    /// - application: application.
    /// - bundle: bundle.
    /// - appExtension: application extension.
    /// - watchExtension: watch extension.
    /// - unitTests: unit tests.
    /// - uiTests: ui tests.
    public enum Product {
        case framework, staticLibrary, dynamicLibrary, application, bundle, appExtension, watchExtension, unitTests, uiTests
    }

    /// Returns the default target build settings.
    ///
    /// - Parameters:
    ///   - variant: build settings variant.
    ///   - platform: target platform.
    ///   - product: target product.
    ///   - swift: true if the target contains Swift code.
    /// - Returns: build settings.
    public static func targetDefault(variant: Variant? = nil, platform: Platform?, product: Product?, swift: Bool? = nil) -> BuildSettings {
        var buildSettings: BuildSettings = [:]

        if let platform {
            buildSettings.merge(targetSettings(platform: platform), uniquingKeysWith: { $1 })
        }

        if let product {
            buildSettings.merge(targetSettings(product: product), uniquingKeysWith: { $1 })
        }

        if let platform, let product {
            buildSettings.merge(targetSettings(platform: platform, product: product), uniquingKeysWith: { $1 })
        }

        if let platform, let variant {
            buildSettings.merge(targetSettings(variant: variant, platform: platform), uniquingKeysWith: { $1 })
        }

        if let variant, let swift, swift == true {
            buildSettings.merge(targetSwiftSettings(variant: variant), uniquingKeysWith: { $1 })
        }

        if let product, let swift, swift == true {
            buildSettings.merge(targetSwiftSettings(product: product), uniquingKeysWith: { $1 })
        }

        return buildSettings
    }

    /// Returns default build settings that Xcode sets in new projects.
    ///
    /// - Parameters variant: build settings variant.
    /// - Returns: build settings.
    public static func projectDefault(variant: Variant) -> BuildSettings {
        switch variant {
        case .all:
            projectAll()
        case .debug:
            projectDebug()
        case .release:
            projectRelease()
        }
    }

    // MARK: - Private

    // swiftlint:disable:next function_body_length
    private static func projectAll() -> BuildSettings {
        [
            "ALWAYS_SEARCH_USER_PATHS": "NO",
            "CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED": "YES",
            "CLANG_ANALYZER_NONNULL": "YES",
            "CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION": "YES_AGGRESSIVE",
            "CLANG_CXX_LANGUAGE_STANDARD": "gnu++14",
            "CLANG_CXX_LIBRARY": "libc++",
            "CLANG_ENABLE_MODULES": "YES",
            "CLANG_ENABLE_OBJC_ARC": "YES",
            "CLANG_ENABLE_OBJC_WEAK": "YES",
            "CLANG_WARN__DUPLICATE_METHOD_MATCH": "YES",
            "CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING": "YES",
            "CLANG_WARN_BOOL_CONVERSION": "YES",
            "CLANG_WARN_COMMA": "YES",
            "CLANG_WARN_CONSTANT_CONVERSION": "YES",
            "CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS": "YES",
            "CLANG_WARN_DIRECT_OBJC_ISA_USAGE": "YES_ERROR",
            "CLANG_WARN_DOCUMENTATION_COMMENTS": "YES",
            "CLANG_WARN_EMPTY_BODY": "YES",
            "CLANG_WARN_ENUM_CONVERSION": "YES",
            "CLANG_WARN_INFINITE_RECURSION": "YES",
            "CLANG_WARN_INT_CONVERSION": "YES",
            "CLANG_WARN_NON_LITERAL_NULL_CONVERSION": "YES",
            "CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF": "YES",
            "CLANG_WARN_OBJC_LITERAL_CONVERSION": "YES",
            "CLANG_WARN_OBJC_ROOT_CLASS": "YES_ERROR",
            "CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER": "YES",
            "CLANG_WARN_RANGE_LOOP_ANALYSIS": "YES",
            "CLANG_WARN_STRICT_PROTOTYPES": "YES",
            "CLANG_WARN_SUSPICIOUS_MOVE": "YES",
            "CLANG_WARN_UNGUARDED_AVAILABILITY": "YES_AGGRESSIVE",
            "CLANG_WARN_UNREACHABLE_CODE": "YES",
            "COPY_PHASE_STRIP": "NO",
            "DEAD_CODE_STRIPPING": "YES",
            "ENABLE_STRICT_OBJC_MSGSEND": "YES",
            "GCC_C_LANGUAGE_STANDARD": "gnu11",
            "GCC_NO_COMMON_BLOCKS": "YES",
            "GCC_WARN_64_TO_32_BIT_CONVERSION": "YES",
            "GCC_WARN_ABOUT_RETURN_TYPE": "YES_ERROR",
            "GCC_WARN_UNDECLARED_SELECTOR": "YES",
            "GCC_WARN_UNINITIALIZED_AUTOS": "YES_AGGRESSIVE",
            "GCC_WARN_UNUSED_FUNCTION": "YES",
            "GCC_WARN_UNUSED_VARIABLE": "YES",
            "PRODUCT_NAME": "$(TARGET_NAME)",
        ]
    }

    private static func projectDebug() -> BuildSettings {
        [
            "DEBUG_INFORMATION_FORMAT": "dwarf",
            "ENABLE_TESTABILITY": "YES",
            "GCC_DYNAMIC_NO_PIC": "NO",
            "GCC_OPTIMIZATION_LEVEL": "0",
            "GCC_PREPROCESSOR_DEFINITIONS": ["DEBUG=1", "$(inherited)"],
            "MTL_ENABLE_DEBUG_INFO": "YES",
            "ONLY_ACTIVE_ARCH": "YES",
        ]
    }

    private static func projectRelease() -> BuildSettings {
        [
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            "ENABLE_NS_ASSERTIONS": "NO",
            "MTL_ENABLE_DEBUG_INFO": "NO",
            "VALIDATE_PRODUCT": "YES",
        ]
    }

    private static func targetSettings(platform: Platform) -> BuildSettings {
        switch platform {
        case .iOS:
            [
                "SDKROOT": "iphoneos",
                "CODE_SIGN_IDENTITY": "iPhone Developer",
                "TARGETED_DEVICE_FAMILY": "1,2",
            ]
        case .macOS:
            [
                "SDKROOT": "macosx",
                "CODE_SIGN_IDENTITY": "-",
            ]
        case .tvOS:
            [
                "SDKROOT": "appletvos",
                "TARGETED_DEVICE_FAMILY": "3",
            ]
        case .watchOS:
            [
                "SDKROOT": "watchos",
                "TARGETED_DEVICE_FAMILY": "4",
            ]
        case .visionOS:
            [
                "SDKROOT": "xros",
                "CODE_SIGN_IDENTITY": "iPhone Developer",
                "TARGETED_DEVICE_FAMILY": "1,2,7",
            ]
        }
    }

    private static func targetSettings(product: Product) -> BuildSettings {
        switch product {
        case .application:
            [
                "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
                "ENABLE_PREVIEWS": "YES",
            ]
        case .framework:
            [
                "CODE_SIGN_IDENTITY": "",
                "CURRENT_PROJECT_VERSION": "1",
                "DEFINES_MODULE": "YES",
                "DYLIB_COMPATIBILITY_VERSION": "1",
                "DYLIB_CURRENT_VERSION": "1",
                "DYLIB_INSTALL_NAME_BASE": "@rpath",
                "INSTALL_PATH": "$(LOCAL_LIBRARY_DIR)/Frameworks",
                "PRODUCT_NAME": "$(TARGET_NAME:c99extidentifier)",
                "SKIP_INSTALL": "YES",
                "VERSION_INFO_PREFIX": "",
                "VERSIONING_SYSTEM": "apple-generic",
            ]
        case .bundle:
            [
                "WRAPPER_EXTENSION": "bundle",
                "SKIP_INSTALL": "YES",
            ]
        default:
            [:]
        }
    }

    // swiftlint:disable:next function_body_length
    private static func targetSettings(platform: Platform, product: Product) -> BuildSettings {
        switch (platform, product) {
        case (.iOS, .application):
            [
                "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/Frameworks"],
            ]
        case (.macOS, .application):
            [
                "COMBINE_HIDPI_IMAGES": "YES",
                "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/../Frameworks"],
            ]
        case (.tvOS, .application):
            [
                "ASSETCATALOG_COMPILER_APPICON_NAME": "App Icon & Top Shelf Image",
                "ASSETCATALOG_COMPILER_LAUNCHIMAGE_NAME": "LaunchImage",
                "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/Frameworks"],
            ]
        case (.watchOS, .application):
            [
                "SKIP_INSTALL": "YES",
                "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/Frameworks"],
            ]
        case (.visionOS, .application):
            [
                "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/Frameworks"],
            ]
        case (.iOS, .framework):
            [
                "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/Frameworks", "@loader_path/Frameworks"],
            ]
        case (.macOS, .framework):
            [
                "COMBINE_HIDPI_IMAGES": "YES",
                "FRAMEWORK_VERSION": "A",
                "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/../Frameworks", "@loader_path/../Frameworks"],
            ]
        case (.tvOS, .framework):
            [
                "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/Frameworks", "@loader_path/Frameworks"],
            ]
        case (.watchOS, .framework):
            [
                "APPLICATION_EXTENSION_API_ONLY": "YES",
                "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/Frameworks", "@loader_path/Frameworks"],
            ]
        case (.visionOS, .framework):
            [
                "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/Frameworks", "@loader_path/Frameworks"],
            ]
        case ([.iOS, .tvOS, .watchOS, .visionOS], .staticLibrary):
            [
                "OTHER_LDFLAGS": "-ObjC",
                "SKIP_INSTALL": "YES",
            ]
        case (.macOS, .staticLibrary):
            [
                "EXECUTABLE_PREFIX": "lib",
                "SKIP_INSTALL": "YES",
            ]
        case (.macOS, .dynamicLibrary):
            [
                "DYLIB_COMPATIBILITY_VERSION": "1",
                "DYLIB_CURRENT_VERSION": "1",
                "EXECUTABLE_PREFIX": "lib",
                "SKIP_INSTALL": "YES",
            ]
        case (.macOS, .bundle):
            [
                "COMBINE_HIDPI_IMAGES": "YES",
                "INSTALL_PATH": "$(LOCAL_LIBRARY_DIR)/Bundles",
            ]
        case ([.iOS, .tvOS, .visionOS], .appExtension):
            [
                "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/Frameworks", "@executable_path/../../Frameworks"],
            ]
        case (.macOS, .appExtension):
            [
                "LD_RUNPATH_SEARCH_PATHS": [
                    "$(inherited)",
                    "@executable_path/../Frameworks",
                    "@executable_path/../../../../Frameworks",
                ],
            ]
        case (.watchOS, .watchExtension):
            [
                "LD_RUNPATH_SEARCH_PATHS": [
                    "$(inherited)",
                    "@executable_path/Frameworks",
                    "@executable_path/../../Frameworks",
                ],
            ]
        case (.watchOS, .appExtension):
            [
                "LD_RUNPATH_SEARCH_PATHS": [
                    "$(inherited)",
                    "@executable_path/Frameworks",
                    "@executable_path/../../Frameworks",
                    "@executable_path/../../../../Frameworks",
                ],
            ]
        case ([.iOS, .tvOS, .visionOS], [.unitTests, .uiTests]):
            [
                "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/Frameworks", "@loader_path/Frameworks"],
            ]
        case (.macOS, [.unitTests, .uiTests]):
            [
                "LD_RUNPATH_SEARCH_PATHS": ["$(inherited)", "@executable_path/../Frameworks", "@loader_path/../Frameworks"],
            ]
        default:
            [:]
        }
    }

    private static func targetSettings(variant: Variant,
                                       platform: Platform) -> BuildSettings {
        switch (variant, platform) {
        default:
            [:]
        }
    }

    private static func targetSwiftSettings(variant: Variant) -> BuildSettings {
        switch variant {
        case .debug:
            [
                "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
                "SWIFT_ACTIVE_COMPILATION_CONDITIONS": ["$(inherited)", "DEBUG"],
                "SWIFT_COMPILATION_MODE": "singlefile",
            ]
        case .release:
            [
                "SWIFT_OPTIMIZATION_LEVEL": "-O",
                "SWIFT_COMPILATION_MODE": "wholemodule",
            ]
        default:
            [:]
        }
    }

    private static func targetSwiftSettings(product: Product) -> BuildSettings {
        switch product {
        case .framework:
            [
                "DEFINES_MODULE": "YES",
            ]
        default:
            [:]
        }
    }
}

// Overloading `~=` enables customizing switch statement pattern matching
//
// - reference: https://docs.swift.org/swift-book/ReferenceManual/Patterns.html#ID426

private func ~= (lhs: [BuildSettingsProvider.Product],
                 rhs: BuildSettingsProvider.Product) -> Bool {
    lhs.contains(rhs)
}

private func ~= (lhs: [BuildSettingsProvider.Platform],
                 rhs: BuildSettingsProvider.Platform) -> Bool {
    lhs.contains(rhs)
}
