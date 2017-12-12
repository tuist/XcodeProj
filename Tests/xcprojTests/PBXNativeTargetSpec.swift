import Foundation
import XCTest
import xcproj

final class PBXNativeTargetSpec: XCTestCase {

    var subject: PBXNativeTarget!

    override func setUp() {
        super.setUp()
        subject = PBXNativeTarget(name: "name",
                                  buildConfigurationList: "list",
                                  buildPhases: ["phase"],
                                  buildRules: ["rule"],
                                  dependencies: ["dependency"],
                                  productName: "productname",
                                  productReference: "productreference",
                                  productType: .application)
    }

    func test_isa_returnsTheCorrectValue() {
        XCTAssertEqual(PBXNativeTarget.isa, "PBXNativeTarget")
    }

    func test_init_initializesTheElementWithTheRightAttributes() {
        XCTAssertEqual(subject.buildConfigurationList, "list")
        XCTAssertEqual(subject.buildPhases, ["phase"])
        XCTAssertEqual(subject.buildRules, ["rule"])
        XCTAssertEqual(subject.dependencies, ["dependency"])
        XCTAssertEqual(subject.name, "name")
        XCTAssertEqual(subject.productName, "productname")
        XCTAssertEqual(subject.productReference, "productreference")
        XCTAssertEqual(subject.productType, .application)
    }

    func test_init_failsWhenNameIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "name")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXNativeTarget.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_equal_returnsTheCorrectValue() {
        let another = PBXNativeTarget(name: "name",
                                      buildConfigurationList: "list",
                                      buildPhases: ["phase"],
                                      buildRules: ["rule"],
                                      dependencies: ["dependency"],
                                      productName: "productname",
                                      productReference: "productreference",
                                      productType: .application)
        XCTAssertEqual(subject, another)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "buildConfigurationList": "test",
            "buildPhases": ["phase"],
            "buildRules": ["rule"],
            "dependencies": ["dependency"],
            "name": "name"
        ]
    }

}
