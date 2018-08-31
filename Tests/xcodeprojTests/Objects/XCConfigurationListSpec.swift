import Foundation
@testable import xcodeproj
import XCTest

final class XCConfigurationListSpec: XCTestCase {
    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(XCConfigurationList.isa, "XCConfigurationList")
    }

    func test_add_configuration() throws {
        let objects = PBXObjects()
        let configurationList = XCConfigurationList(buildConfigurations: [])
        objects.addObject(configurationList)
        let configuration = try configurationList.add(configuration: "Debug")

        XCTAssertEqual(configuration.name, "Debug")
        XCTAssertTrue(configurationList.buildConfigurationReferences.contains(configuration.reference))
    }

    func test_addDefaultConfigurations() throws {
        let objects = PBXObjects()
        let configurationList = XCConfigurationList(buildConfigurations: [])
        objects.addObject(configurationList)
        let configurations = try configurationList.addDefaultConfigurations()
        let names = configurations.map({ $0.name })

        XCTAssertEqual(configurations.count, 2)
        XCTAssertTrue(names.contains("Debug"))
        XCTAssertTrue(names.contains("Release"))
    }

    func test_configuration_with_name() throws {
        let objects = PBXObjects()
        let configurationList = XCConfigurationList(buildConfigurations: [])
        objects.addObject(configurationList)
        let configuration = try configurationList.add(configuration: "Debug")

        XCTAssertEqual(try configurationList.configuration(name: "Debug"), configuration)
    }
}
