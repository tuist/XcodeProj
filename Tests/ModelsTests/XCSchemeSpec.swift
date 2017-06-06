import Foundation
import XCTest
import PathKit

@testable import Models

final class XCSchemeSpec: XCTestCase {
    
    var subject: XCScheme?
    
    override func setUp() {
        subject = integrationModel()
    }
    
    func test_integration_shouldHaveTheRightVersion() {
        XCTAssertEqual(subject?.version, "1.3")
    }
    
    func test_integration_shouldHaveTheRightLastUpgradeVersion() {
        XCTAssertEqual(subject?.lastUpgradeVersion, "0830")
    }
    
    func test_integration_shouldHaveTheCorrectBuildAction() {
        XCTAssertTrue(subject?.buildAction?.parallelizeBuild == true)
        XCTAssertTrue(subject?.buildAction?.buildImplicitDependencies == true)
        XCTAssertTrue(subject?.buildAction?.buildActionEntries.first?.buildFor.contains(.testing) == true)
        XCTAssertTrue(subject?.buildAction?.buildActionEntries.first?.buildFor.contains(.running) == true)
        XCTAssertTrue(subject?.buildAction?.buildActionEntries.first?.buildFor.contains(.profiling) == true)
        XCTAssertTrue(subject?.buildAction?.buildActionEntries.first?.buildFor.contains(.archiving) == true)
        XCTAssertTrue(subject?.buildAction?.buildActionEntries.first?.buildFor.contains(.analyzing) == true)
        XCTAssertEqual(subject?.buildAction?.buildActionEntries.first?.buildableReference.buildableIdentifier, "primary")
        XCTAssertEqual(subject?.buildAction?.buildActionEntries.first?.buildableReference.blueprintIdentifier, "23766C111EAA3484007A9026")
        XCTAssertEqual(subject?.buildAction?.buildActionEntries.first?.buildableReference.buildableName, "iOS.app")
        XCTAssertEqual(subject?.buildAction?.buildActionEntries.first?.buildableReference.blueprintName, "iOS")
        XCTAssertEqual(subject?.buildAction?.buildActionEntries.first?.buildableReference.referencedContainer, "container:Project.xcodeproj")
    }

    func test_integration_shouldHaveTheCorrectTestAction() {
        XCTAssertEqual(subject?.testAction?.buildConfiguration, "Debug")
        XCTAssertEqual(subject?.testAction?.selectedDebuggerIdentifier, "Xcode.DebuggerFoundation.Debugger.LLDB")
        XCTAssertEqual(subject?.testAction?.selectedDebuggerIdentifier, "Xcode.DebuggerFoundation.Debugger.LLDB")
        XCTAssertEqual(subject?.testAction?.shouldUseLaunchSchemeArgsEnv, true)
        XCTAssertEqual(subject?.testAction?.testables.first?.skipped, false)
        XCTAssertEqual(subject?.testAction?.testables.first?.buildableReference.buildableIdentifier, "primary")
        XCTAssertEqual(subject?.testAction?.testables.first?.buildableReference.blueprintIdentifier, "23766C251EAA3484007A9026")
        XCTAssertEqual(subject?.testAction?.testables.first?.buildableReference.buildableName, "iOSTests.xctest")
        XCTAssertEqual(subject?.testAction?.testables.first?.buildableReference.blueprintName, "iOSTests")
        XCTAssertEqual(subject?.testAction?.testables.first?.buildableReference.referencedContainer, "container:Project.xcodeproj")
        XCTAssertEqual(subject?.testAction?.testables.first?.buildableReference.referencedContainer, "container:Project.xcodeproj")
        XCTAssertEqual(subject?.testAction?.macroExpansion.blueprintIdentifier, "23766C111EAA3484007A9026")
        XCTAssertEqual(subject?.testAction?.macroExpansion.buildableName, "iOS.app")
        XCTAssertEqual(subject?.testAction?.macroExpansion.blueprintName, "iOS")
        XCTAssertEqual(subject?.testAction?.macroExpansion.referencedContainer, "container:Project.xcodeproj")
        XCTAssertEqual(subject?.testAction?.macroExpansion.referencedContainer, "container:Project.xcodeproj")
    }
    
    func test_integration_shouldHaveTheCorrectLaunchAction() {
        XCTAssertEqual(subject?.launchAction?.buildConfiguration, "Debug")
        XCTAssertEqual(subject?.launchAction?.selectedDebuggerIdentifier, "Xcode.DebuggerFoundation.Debugger.LLDB")
        XCTAssertEqual(subject?.launchAction?.selectedLauncherIdentifier, "Xcode.DebuggerFoundation.Launcher.LLDB")
        XCTAssertEqual(subject?.launchAction?.launchStyle, .auto)
        XCTAssertEqual(subject?.launchAction?.useCustomWorkingDirectory, false)
        XCTAssertEqual(subject?.launchAction?.ignoresPersistentStateOnLaunch, false)
        XCTAssertEqual(subject?.launchAction?.debugDocumentVersioning, true)
        XCTAssertEqual(subject?.launchAction?.debugServiceExtension, "internal")
        XCTAssertEqual(subject?.launchAction?.allowLocationSimulation, true)
        XCTAssertEqual(subject?.launchAction?.buildableProductRunnable.runnableDebuggingMode, "0")
        XCTAssertEqual(subject?.launchAction?.buildableProductRunnable.buildableReference.buildableIdentifier, "primary")
        XCTAssertEqual(subject?.launchAction?.buildableProductRunnable.buildableReference.blueprintIdentifier, "23766C111EAA3484007A9026")
        XCTAssertEqual(subject?.launchAction?.buildableProductRunnable.buildableReference.buildableName, "iOS.app")
        XCTAssertEqual(subject?.launchAction?.buildableProductRunnable.buildableReference.blueprintName, "iOS")
        XCTAssertEqual(subject?.launchAction?.buildableProductRunnable.buildableReference.referencedContainer, "container:Project.xcodeproj")
    }
    
    func test_integration_shouldHaveTheCorrectAnalyzeAction() {
        XCTAssertEqual(subject?.analyzeAction?.buildConfiguration, "Debug")
    }
    
    func test_integration_shouldHaveTheCorrectArchiveAction() {
        XCTAssertEqual(subject?.archiveAction?.buildConfiguration, "Release")
        XCTAssertEqual(subject?.archiveAction?.revealArchiveInOrganizer, true)
        XCTAssertEqual(subject?.archiveAction?.customArchiveName, "TestName")
    }
    
    private func integrationModel() -> XCScheme? {
        let fixtures = Path(#file).parent().parent().parent() + Path("Fixtures")
        let path = fixtures + Path("iOS/Project.xcodeproj/xcshareddata/xcschemes/iOS.xcscheme")
        return try? XCScheme(path: path)
    }
    
}
