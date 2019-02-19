import XCTest

extension OSSProjectsTests {
    static let __allTests = [
        ("test_projects", test_projects),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(OSSProjectsTests.__allTests),
    ]
}
#endif
