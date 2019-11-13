import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AEXML_XcodeFormatTests.allTests),
        testCase(DictionaryExtrasTests.allTests),
        testCase(PathExtrasTests.allTests)
    ]
}
#endif
