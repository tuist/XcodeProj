import Foundation
import XCTest
@testable import XcodeProj

final class XCConfigurationListTests: XCTestCase {
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(XCConfigurationList.isa, "XCConfigurationList")
    }

    func test_addDefaultConfigurations() throws {
        let objects = PBXObjects()
        let configurationList = XCConfigurationList(buildConfigurations: [])
        objects.add(object: configurationList)
        let configurations = try configurationList.addDefaultConfigurations()
        let names = configurations.map { $0.name }

        XCTAssertEqual(configurations.count, 2)
        XCTAssertTrue(names.contains("Debug"))
        XCTAssertTrue(names.contains("Release"))
    }

    func test_configuration_with_name() throws {
        let objects = PBXObjects()
        let configurationList = XCConfigurationList(buildConfigurations: [])
        objects.add(object: configurationList)
        let configurations = try configurationList.addDefaultConfigurations()

        XCTAssertEqual(
            configurationList.configuration(name: "Debug"),
            configurations.first(where: { $0.name == "Debug" })
        )
    }
}
