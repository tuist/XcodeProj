import AEXML
import Foundation

extension XCScheme {
    public final class TestableReference: Equatable {
        // MARK: - Attributes

        public var skipped: Bool
        public var parallelizable: Bool
        public var randomExecutionOrdering: Bool
        public var useTestSelectionWhitelist: Bool
        public var buildableReference: BuildableReference
        public var skippedTests: [SkippedTest]

        // MARK: - Init

        public init(skipped: Bool,
                    parallelizable: Bool = false,
                    randomExecutionOrdering: Bool = false,
                    buildableReference: BuildableReference,
                    skippedTests: [SkippedTest] = [],
                    useTestSelectionWhitelist: Bool = false) {
            self.skipped = skipped
            self.parallelizable = parallelizable
            self.randomExecutionOrdering = randomExecutionOrdering
            self.buildableReference = buildableReference
            self.skippedTests = skippedTests
            self.useTestSelectionWhitelist = useTestSelectionWhitelist
        }

        init(element: AEXMLElement) throws {
            skipped = element.attributes["skipped"] == "YES"
            parallelizable = element.attributes["parallelizable"] == "YES"
            useTestSelectionWhitelist = element.attributes["useTestSelectionWhitelist"] == "YES"
            randomExecutionOrdering = element.attributes["testExecutionOrdering"] == "random"
            buildableReference = try BuildableReference(element: element["BuildableReference"])
            if let skippedTests = element["SkippedTests"]["Test"].all, !skippedTests.isEmpty {
                self.skippedTests = try skippedTests.map(SkippedTest.init)
            } else {
                skippedTests = []
            }
        }

        // MARK: - XML

        func xmlElement() -> AEXMLElement {
            var attributes: [String: String] = ["skipped": skipped.xmlString]
            attributes["parallelizable"] = parallelizable ? parallelizable.xmlString : nil
            attributes["useTestSelectionWhitelist"] = useTestSelectionWhitelist ? useTestSelectionWhitelist.xmlString : nil
            attributes["testExecutionOrdering"] = randomExecutionOrdering ? "random" : nil
            let element = AEXMLElement(name: "TestableReference",
                                       value: nil,
                                       attributes: attributes)
            element.addChild(buildableReference.xmlElement())
            if !skippedTests.isEmpty {
                let skippedTestsElement = element.addChild(name: "SkippedTests")
                skippedTests.forEach { skippedTest in
                    skippedTestsElement.addChild(skippedTest.xmlElement())
                }
            }
            return element
        }

        // MARK: - Equatable

        public static func == (lhs: TestableReference, rhs: TestableReference) -> Bool {
            return lhs.skipped == rhs.skipped &&
                lhs.parallelizable == rhs.parallelizable &&
                lhs.randomExecutionOrdering == rhs.randomExecutionOrdering &&
                lhs.buildableReference == rhs.buildableReference &&
                lhs.useTestSelectionWhitelist == rhs.useTestSelectionWhitelist &&
                lhs.skippedTests == rhs.skippedTests
        }
    }
}
