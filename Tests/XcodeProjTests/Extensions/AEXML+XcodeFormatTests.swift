
import AEXML
import XCTest
@testable import XcodeProj

extension String {
    var cleaned: String {
        replacingOccurrences(of: "   ", with: "").components(separatedBy: "\n").filter { !$0.isEmpty }.joined(separator: " ")
    }
}

class AEXML_XcodeFormatTests: XCTestCase {
    private let expecteBuildActionXml =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <BuildAction
           parallelizeBuildables = "YES"
           buildImplicitDependencies = "NO"
           runPostActionsOnFailure = "YES">
        </BuildAction>
        """

    private let expectedLaunchActionXml =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <LaunchAction
           buildConfiguration = "Debug"
           selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
           customLLDBInitFile = "$(BAZEL_LLDB_INIT)"
           launchStyle = "0"
           allowLocationSimulation = "YES">
        </LaunchAction>
        """

    func test_BuildAction_attributes_sorted_when_original_sorted() {
        validateAttributes(
            expectedXML: expecteBuildActionXml.cleaned,
            childName: "BuildAction",
            attributes: [
                "parallelizeBuildables": "YES",
                "runPostActionsOnFailure": "YES",
                "buildImplicitDependencies": "NO",
            ]
        )
    }

    func test_BuildAction_attributes_sorted_when_original_unsorted() {
        validateAttributes(
            expectedXML: expecteBuildActionXml.cleaned,
            childName: "BuildAction",
            attributes: [
                "buildImplicitDependencies": "NO",
                "parallelizeBuildables": "YES",
                "runPostActionsOnFailure": "YES",
            ]
        )
    }

    func test_LaunchAction_attributes_sorted_when_original_sorted() {
        validateAttributes(
            expectedXML: expectedLaunchActionXml.cleaned,
            childName: "LaunchAction",
            attributes: [
                "buildConfiguration": "Debug",
                "selectedLauncherIdentifier": "Xcode.DebuggerFoundation.Launcher.LLDB",
                "customLLDBInitFile": "$(BAZEL_LLDB_INIT)",
                "launchStyle": "0",
                "allowLocationSimulation": "YES"
            ]
        )
    }

    func test_LaunchAction_attributes_sorted_when_original_unsorted() {
        validateAttributes(
            expectedXML: expectedLaunchActionXml.cleaned,
            childName: "LaunchAction",
            attributes: [
                "customLLDBInitFile": "$(BAZEL_LLDB_INIT)",
                "allowLocationSimulation": "YES",
                "buildConfiguration": "Debug",
                "selectedLauncherIdentifier": "Xcode.DebuggerFoundation.Launcher.LLDB",
                "launchStyle": "0",
            ]
        )
    }

    func validateAttributes(
        expectedXML: String,
        childName: String,
        attributes: [String: String],
        line: UInt = #line
    ) {
        let document = AEXMLDocument()
        let child = document.addChild(name: childName)
        child.attributes = attributes
        let result = document.xmlXcodeFormat
        XCTAssertEqual(expectedXML, result.cleaned, line: line)
    }
}
