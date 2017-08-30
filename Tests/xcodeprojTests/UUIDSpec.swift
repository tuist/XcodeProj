import Foundation
import XCTest
@testable import xcodeproj


class UUIDSpec: XCTestCase {

    func test_generateUUID_withString() {
        XCTAssertEqual(generateUUID(reference: "test string"), "6F8DB599DE986FAB7A21625B7916589C")
    }
}

