import Foundation
@testable import xcodeproj
import XCTest

final class XCBuildConfigurationTests: XCTestCase {
    func test_initFails_ifNameIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "name")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = XcodeprojJSONDecoder()
        do {
            _ = try decoder.decode(XCBuildConfiguration.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_isa_hasTheCorrectValue() {
        XCTAssertEqual(XCBuildConfiguration.isa, "XCBuildConfiguration")
    }

    private func testDictionary() -> [String: Any] {
        return [
            "baseConfigurationReference": "baseConfigurationReference",
            "buildSettings": [:],
            "name": "name",
            "reference": "reference",
        ]
    }
}
