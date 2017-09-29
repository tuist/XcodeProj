import Foundation
import XCTest
import xcproj
import PathKit

final class XCConfigSpec: XCTestCase {

    var subject: XCConfig?

    func test_init_initializesTheConfigWithTheRightAttributes() {
        let configA = XCConfig(includes: [])
        let configB = XCConfig(includes: [])
        let config = XCConfig(includes: [(Path("testA"), configA),
                                         (Path("testB"), configB)],
                              buildSettings: ["a": "b"])
        XCTAssertEqual(config.buildSettings as! [String: String], ["a": "b"])
        XCTAssertEqual(config.includes[0].config, configA)
        XCTAssertEqual(config.includes[1].config, configB)
    }

    func test_flattened_flattensTheConfigCorrectly() {
        let configA = XCConfig(includes: [], buildSettings: ["a": "1"])
        let configB = XCConfig(includes: [], buildSettings: ["a": "2"])
        let config = XCConfig(includes: [(Path("testA"), configA),
                                         (Path("testB"), configB)],
                              buildSettings: ["b": "3"])
        let buildSettings = config.flattenedBuildSettings()
        XCTAssertEqual(buildSettings["a"] as? String, "2")
        XCTAssertEqual(buildSettings["b"] as? String, "3")
    }

    func test_errorDescription_returnsTheCorrectDescription_whenNotFound() {
        let error = XCConfigError.notFound(path: Path("test"))
        XCTAssertEqual(error.description, ".xcconfig file not found at test")
    }

}

final class XCConfigIntegrationSpec: XCTestCase {

    func test_init_initializesXCConfigWithTheRightProperties() {
        let subject = try? XCConfig(path: childrenPath())
        XCTAssertNotNil(subject)
        if let subject = subject {
            assert(config: subject)
        }
    }

    func test_write_writesTheContentProperly() {
        testWrite(from: childrenPath(),
                  initModel: { try? XCConfig(path: $0) },
                  modify: { $0 })
    }

    private func childrenPath() -> Path {
        return fixturesPath() + Path("XCConfigs/Children.xcconfig")
    }

    private func parentPath() -> Path {
        return fixturesPath() + Path("XCConfigs/Parent.xcconfig")
    }

    private func assert(config: XCConfig) {
        XCTAssertEqual(config.buildSettings["CONFIGURATION_BUILD_DIR"] as? String, "Test/")
        XCTAssertEqual(config.flattenedBuildSettings()["CONFIGURATION_BUILD_DIR"] as? String, "Test/")
        XCTAssertEqual(config.buildSettings["GCC_PREPROCESSOR_DEFINITIONS"] as? String, "$(inherited)")
        XCTAssertEqual(config.flattenedBuildSettings()["GCC_PREPROCESSOR_DEFINITIONS"] as? String, "$(inherited)")
        XCTAssertEqual(config.buildSettings["WARNING_CFLAGS"] as? String, "-Wall -Wno-direct-ivar-access -Wno-objc-missing-property-synthesis -Wno-readonly-iboutlet-property -Wno-switch-enum -Wno-padded")
        XCTAssertEqual(config.flattenedBuildSettings()["WARNING_CFLAGS"] as? String, "-Wall -Wno-direct-ivar-access -Wno-objc-missing-property-synthesis -Wno-readonly-iboutlet-property -Wno-switch-enum -Wno-padded")
        XCTAssertEqual(config.includes.count, 1)
        XCTAssertEqual(config.flattenedBuildSettings()["OTHER_SWIFT_FLAGS_XCODE_0821"] as? String, "$(inherited)")
        XCTAssertEqual(config.flattenedBuildSettings()["OTHER_SWIFT_FLAGS_XCODE_0830"] as? String, "$(inherited) -enable-bridging-pch")
    }

}

