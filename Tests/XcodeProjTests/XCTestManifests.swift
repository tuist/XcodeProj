import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            // Extensions
            testCase(AEXML_XcodeFormatTests.allTests),
            testCase(DictionaryExtrasTests.allTests),
            testCase(PathExtrasTests.allTests),

            // Workspace
            testCase(XCWorkspaceDataElementTests.allTests),
            testCase(XCWorkspaceDataTests.allTests),
            testCase(XCWorkspaceDataIntegrationTests.allTests),
            testCase(XCWorkspaceIntegrationTests.allTests),
        ]
    }
#endif
