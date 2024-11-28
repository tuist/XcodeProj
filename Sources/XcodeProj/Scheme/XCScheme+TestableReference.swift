import AEXML
import Foundation

public extension XCScheme {
    final class TestableReference: Equatable {
        // MARK: - Attributes

        public var skipped: Bool
        @available(*, deprecated, message: "Please use TestParallelization property instead")
        public var parallelizable: Bool
        public var testParallelization: TestParallelization
        public var randomExecutionOrdering: Bool
        public var useTestSelectionWhitelist: Bool?
        public var buildableReference: BuildableReference
        public var locationScenarioReference: LocationScenarioReference?
        public var skippedTests: [TestItem]
        public var selectedTests: [TestItem]

        // MARK: - Init

        public init(skipped: Bool,
                    testParallelization: TestParallelization = .none,
                    randomExecutionOrdering: Bool = false,
                    buildableReference: BuildableReference,
                    locationScenarioReference: LocationScenarioReference? = nil,
                    skippedTests: [TestItem] = [],
                    selectedTests: [TestItem] = [],
                    useTestSelectionWhitelist: Bool? = nil) {
            self.skipped = skipped
            self.parallelizable = testParallelization == .all ? true : false
            self.testParallelization = testParallelization
            self.randomExecutionOrdering = randomExecutionOrdering
            self.buildableReference = buildableReference
            self.locationScenarioReference = locationScenarioReference
            self.useTestSelectionWhitelist = useTestSelectionWhitelist
            self.selectedTests = selectedTests
            self.skippedTests = skippedTests
        }

        @available(*, deprecated, message: "Use init with parallelizable: TestParallelization argument instead")
        public init(skipped: Bool,
                    parallelizable: Bool = false,
                    randomExecutionOrdering: Bool = false,
                    buildableReference: BuildableReference,
                    locationScenarioReference: LocationScenarioReference? = nil,
                    skippedTests: [TestItem] = [],
                    selectedTests: [TestItem] = [],
                    useTestSelectionWhitelist: Bool? = nil) {
            self.skipped = skipped
            self.parallelizable = parallelizable
            self.testParallelization = parallelizable ? .all : .none
            self.randomExecutionOrdering = randomExecutionOrdering
            self.buildableReference = buildableReference
            self.locationScenarioReference = locationScenarioReference
            self.useTestSelectionWhitelist = useTestSelectionWhitelist
            self.selectedTests = selectedTests
            self.skippedTests = skippedTests
        }

        init(element: AEXMLElement) throws {
            skipped = element.attributes["skipped"] == "YES"
            
            if let parallelizableValue = element.attributes["parallelizable"] {
                testParallelization = parallelizableValue == "YES" ? .all : .none
                parallelizable = parallelizableValue == "YES"
            } else {
                testParallelization = .swiftTestingOnly
                parallelizable = false
            }

            useTestSelectionWhitelist = element.attributes["useTestSelectionWhitelist"] == "YES"
            randomExecutionOrdering = element.attributes["testExecutionOrdering"] == "random"
            buildableReference = try BuildableReference(element: element["BuildableReference"])

            if element["LocationScenarioReference"].all?.first != nil {
                locationScenarioReference = try LocationScenarioReference(element: element["LocationScenarioReference"])
            } else {
                locationScenarioReference = nil
            }

            if let selectedTests = element["SelectedTests"]["Test"].all {
                self.selectedTests = try selectedTests.map(TestItem.init)
            } else {
                selectedTests = []
            }
            if let skippedTests = element["SkippedTests"]["Test"].all {
                self.skippedTests = try skippedTests.map(TestItem.init)
            } else {
                skippedTests = []
            }
        }

        // MARK: - XML

        func xmlElement() -> AEXMLElement {
            var attributes: [String: String] = ["skipped": skipped.xmlString]
            attributes["parallelizable"] = parallelizable ? parallelizable.xmlString : nil
          
            switch testParallelization {
            case .all:
                attributes["parallelizable"] = "YES"
            case .none:
                attributes["parallelizable"] = "NO"
            case .swiftTestingOnly:
                break // SwiftTesting is inferred by the lack of a value
            }

            if let useTestSelectionWhitelist {
                attributes["useTestSelectionWhitelist"] = useTestSelectionWhitelist.xmlString
            }
            attributes["testExecutionOrdering"] = randomExecutionOrdering ? "random" : nil
            let element = AEXMLElement(name: "TestableReference",
                                       value: nil,
                                       attributes: attributes)
            element.addChild(buildableReference.xmlElement())

            if let locationScenarioReference {
                element.addChild(locationScenarioReference.xmlElement())
            }

            if useTestSelectionWhitelist == true {
                if !selectedTests.isEmpty {
                    let selectedTestsElement = element.addChild(name: "SelectedTests")
                    for selectedTest in selectedTests {
                        selectedTestsElement.addChild(selectedTest.xmlElement())
                    }
                }
            } else {
                if !skippedTests.isEmpty {
                    let skippedTestsElement = element.addChild(name: "SkippedTests")
                    for skippedTest in skippedTests {
                        skippedTestsElement.addChild(skippedTest.xmlElement())
                    }
                }
            }
            return element
        }

        // MARK: - Equatable

        public static func == (lhs: TestableReference, rhs: TestableReference) -> Bool {
            lhs.skipped == rhs.skipped &&
                lhs.parallelizable == rhs.parallelizable &&
                lhs.randomExecutionOrdering == rhs.randomExecutionOrdering &&
                lhs.buildableReference == rhs.buildableReference &&
                lhs.locationScenarioReference == rhs.locationScenarioReference &&
                lhs.useTestSelectionWhitelist == rhs.useTestSelectionWhitelist &&
                lhs.skippedTests == rhs.skippedTests &&
                lhs.selectedTests == rhs.selectedTests
        }
    }
}
