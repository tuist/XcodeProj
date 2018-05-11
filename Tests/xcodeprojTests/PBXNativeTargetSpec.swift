import Foundation
@testable import xcodeproj
import XCTest

final class PBXNativeTargetSpec: XCTestCase {
    var subject: PBXNativeTarget!

    override func setUp() {
        super.setUp()
        subject = PBXNativeTarget(name: "name",
                                  buildConfigurationList: PBXObjectReference("list"),
                                  buildPhases: [PBXObjectReference("phase")],
                                  buildRules: [PBXObjectReference("rule")],
                                  dependencies: [PBXObjectReference("dependency")],
                                  productInstallPath: "/usr/local/bin",
                                  productName: "productname",
                                  productReference: PBXObjectReference("productreference"),
                                  productType: .application)
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXNativeTarget.isa, "PBXNativeTarget")
    }

    func test_init_failsWhenNameIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "name")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = XcodeprojJSONDecoder()
        do {
            _ = try decoder.decode(PBXNativeTarget.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    private func testDictionary() -> [String: Any] {
        return [
            "buildConfigurationList": "test",
            "buildPhases": ["phase"],
            "buildRules": ["rule"],
            "dependencies": ["dependency"],
            "name": "name",
            "productInstallPath": "/usr/local/bin",
        ]
    }
}
