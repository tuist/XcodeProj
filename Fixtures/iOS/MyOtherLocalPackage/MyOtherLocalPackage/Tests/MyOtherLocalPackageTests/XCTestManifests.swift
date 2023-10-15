import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(MyLocalPackageTests.allTests),
        ]
    }
#endif
