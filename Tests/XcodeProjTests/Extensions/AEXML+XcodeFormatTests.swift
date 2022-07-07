
import AEXML
import XCTest
@testable import XcodeProj

extension String {
    var cleaned: String {
        replacingOccurrences(of: "   ", with: "").components(separatedBy: "\n").filter { !$0.isEmpty }.joined(separator: " ")
    }
}

class AEXML_XcodeFormatTests: XCTestCase {
    private let expectedBuildActionXml =
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

    private let expectedTestActionXml =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <TestAction
           buildConfiguration = "Debug"
           selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
           customLLDBInitFile = "$(BAZEL_LLDB_INIT)"
           shouldUseLaunchSchemeArgsEnv = "YES">
        </TestAction>
        """

    private let expectedRemoteRunnableXml =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <RemoteRunnable
           runnableDebuggingMode = "2"
           BundleIdentifier = "BundleID"
           RemotePath = "REMOTE_PATH">
        </RemoteRunnable>
        """

    func test_BuildAction_attributes_sorted_when_original_sorted() {
        validateAttributes(
            expectedXML: expectedBuildActionXml.cleaned,
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
            expectedXML: expectedBuildActionXml.cleaned,
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

    func test_TestAction_attributes_sorted_when_original_sorted() {
        validateAttributes(
            expectedXML: expectedTestActionXml.cleaned,
            childName: "TestAction",
            attributes: [
                "buildConfiguration": "Debug",
                "customLLDBInitFile": "$(BAZEL_LLDB_INIT)",
                "selectedLauncherIdentifier": "Xcode.DebuggerFoundation.Launcher.LLDB",
                "shouldUseLaunchSchemeArgsEnv": "YES"
            ]
        )
    }

    func test_TestAction_attributes_sorted_when_original_unsorted() {
        validateAttributes(
            expectedXML: expectedTestActionXml.cleaned,
            childName: "TestAction",
            attributes: [
                "shouldUseLaunchSchemeArgsEnv": "YES",
                "buildConfiguration": "Debug",
                "customLLDBInitFile": "$(BAZEL_LLDB_INIT)",
                "selectedLauncherIdentifier": "Xcode.DebuggerFoundation.Launcher.LLDB"
            ]
        )
    }

    func test_RemoteRunnable() {
        validateAttributes(
            expectedXML: expectedRemoteRunnableXml.cleaned,
            childName: "RemoteRunnable",
            attributes: [
                "BundleIdentifier": "BundleID",
                "RemotePath": "REMOTE_PATH",
                "runnableDebuggingMode": "2"
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
        XCTAssertEqual(result.cleaned, expectedXML, line: line)
    }
}
