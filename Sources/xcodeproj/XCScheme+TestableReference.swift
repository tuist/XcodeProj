import AEXML
import Foundation

extension XCScheme {
    public final class TestableReference: Equatable {

        // MARK: - Attributes

        public var skipped: Bool
        public var buildableReference: BuildableReference
        public var skippedTests: [SkippedTest]

        // MARK: - Init

        public init(skipped: Bool,
                    buildableReference: BuildableReference,
                    skippedTests: [SkippedTest] = []) {
            self.skipped = skipped
            self.buildableReference = buildableReference
            self.skippedTests = skippedTests
        }

        init(element: AEXMLElement) throws {
            skipped = element.attributes["skipped"] == "YES"
            buildableReference = try BuildableReference(element: element["BuildableReference"])
            if let skippedTests = element["SkippedTests"]["Test"].all, !skippedTests.isEmpty {
                self.skippedTests = try skippedTests.map(SkippedTest.init)
            } else {
                skippedTests = []
            }
        }

        // MARK: - XML

        fileprivate func xmlElement() -> AEXMLElement {
            let element = AEXMLElement(name: "TestableReference",
                                       value: nil,
                                       attributes: ["skipped": skipped.xmlString])
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
                lhs.buildableReference == rhs.buildableReference &&
                lhs.skippedTests == rhs.skippedTests
        }
    }
}
