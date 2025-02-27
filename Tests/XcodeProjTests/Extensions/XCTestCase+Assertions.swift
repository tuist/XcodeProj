import Foundation
import XCTest

extension XCTestCase {
    typealias EquatableError = Equatable & Error

    func XCTAssertNotNilAndUnwrap<T>(_ obj: T?, message: String = "") -> T {
        guard let unwrappedObj = obj else {
            XCTAssertNotNil(obj, message)
            fatalError() // Unreachable since the above assertion will fail
        }
        return unwrappedObj
    }

    func XCTAssertThrowsSpecificError<E: EquatableError>(_ expression: @autoclosure () throws -> some Any, _ error: E, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertThrowsError(try expression(), message(), file: file, line: line) { actualError in
            let message = "Expected \(error) got \(actualError)"

            guard let actualCastedError = actualError as? E else {
                XCTFail(message, file: file, line: line)
                return
            }
            XCTAssertEqual(actualCastedError, error, message, file: file, line: line)
        }
    }
}
