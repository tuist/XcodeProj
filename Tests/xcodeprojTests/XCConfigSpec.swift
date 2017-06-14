import Foundation
import XCTest
import xcodeproj
import PathKit

final class XCConfigSpec: XCTestCase {
    
    var subject: XCConfig?
    
    func test_init_initializesTheConfigWithTheRightAttributes() {
        let configA = XCConfig(path: Path("testA"), includes: [], buildSettings: BuildSettings(dictionary: [:]))
        let configB = XCConfig(path: Path("testB"), includes: [], buildSettings: BuildSettings(dictionary: [:]))
        let config = XCConfig(path: Path("test"),
                              includes: [(Path("testA"), configA),
                                         (Path("testB"), configB)],
                              buildSettings: BuildSettings(dictionary: ["a": "b"]))
        XCTAssertEqual(config.path, Path("test"))
        XCTAssertEqual(config.buildSettings.dictionary, ["a": "b"])
        XCTAssertEqual(config.includes[0].config, configA)
        XCTAssertEqual(config.includes[1].config, configB)
    }
    
    func test_integration_initsTheXCConfigWithTheRightProperties() {
        subject = try? XCConfig(path: childrenPath())
        XCTAssertNotNil(subject)
        if let subject = subject {
            assert(config: subject)
        }
    }
    
    func test_write_writesTheContentProperly() {
        testWrite(from: childrenPath(),
                  initModel: { try? XCConfig(path: $0) },
                  modify: { $0 }) { (config) in
                    assert(config: config)
        }
    }
    
    // MARK: - Private
    
    private func assert(config: XCConfig) {
        XCTAssertEqual(config.buildSettings["CONFIGURATION_BUILD_DIR"], "Test/")
        XCTAssertEqual(config.flattenedBuildSettings()["CONFIGURATION_BUILD_DIR"], "Test/")
        XCTAssertEqual(config.buildSettings["GCC_PREPROCESSOR_DEFINITIONS"], "$(inherited)")
        XCTAssertEqual(config.flattenedBuildSettings()["GCC_PREPROCESSOR_DEFINITIONS"], "$(inherited)")
        XCTAssertEqual(config.buildSettings["WARNING_CFLAGS"], "-Wall -Wno-direct-ivar-access -Wno-objc-missing-property-synthesis -Wno-readonly-iboutlet-property -Wno-switch-enum -Wno-padded")
        XCTAssertEqual(config.flattenedBuildSettings()["WARNING_CFLAGS"], "-Wall -Wno-direct-ivar-access -Wno-objc-missing-property-synthesis -Wno-readonly-iboutlet-property -Wno-switch-enum -Wno-padded")
        XCTAssertEqual(config.includes.count, 1)
        XCTAssertEqual(config.flattenedBuildSettings()["OTHER_SWIFT_FLAGS_XCODE_0821"], "$(inherited)")
        XCTAssertEqual(config.flattenedBuildSettings()["OTHER_SWIFT_FLAGS_XCODE_0830"], "$(inherited) -enable-bridging-pch")
    }
    
    private func childrenPath() -> Path {
        return fixturesPath() + Path("XCConfigs/Children.xcconfig")
    }
    
    private func parentPath() -> Path {
        return fixturesPath() + Path("XCConfigs/Parent.xcconfig")
    }
}
