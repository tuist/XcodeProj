import XCTest
@testable import MyOtherLocalPackage

final class MyLocalPackageTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MyOtherLocalPackage().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
