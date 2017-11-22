import Foundation
import XCTest
import PathKit
import xcproj

final class XCSchemeIntegrationSpec: XCTestCase {

    var subject: XCScheme?

    override func setUp() {
        subject = try? XCScheme(path: fixturePath())
    }

    func test_init_initializesTheSchemeCorrectly() {
        XCTAssertNotNil(subject)
        if let subject = subject {
            assert(scheme: subject)
        }
    }

    func test_write() {
        testWrite(from: fixturePath(),
                  initModel: { try? XCScheme(path: $0) },
                  modify: { $0 },
                  assertion: { assert(scheme: $1) })
    }

    // MARK: - Private

    private func assert(scheme: XCScheme) {
        XCTAssertEqual(scheme.version, "1.7")
        XCTAssertEqual(scheme.lastUpgradeVersion, "0830")
        // Build action
        XCTAssertTrue(scheme.buildAction?.parallelizeBuild == true)
        XCTAssertTrue(scheme.buildAction?.buildImplicitDependencies == true)
        XCTAssertTrue(scheme.buildAction?.buildActionEntries.first?.buildFor.contains(.testing) == true)
        XCTAssertTrue(scheme.buildAction?.buildActionEntries.first?.buildFor.contains(.running) == true)
        XCTAssertTrue(scheme.buildAction?.buildActionEntries.first?.buildFor.contains(.profiling) == true)
        XCTAssertTrue(scheme.buildAction?.buildActionEntries.first?.buildFor.contains(.archiving) == true)
        XCTAssertTrue(scheme.buildAction?.buildActionEntries.first?.buildFor.contains(.analyzing) == true)
        XCTAssertEqual(scheme.buildAction?.buildActionEntries.first?.buildableReference.buildableIdentifier, "primary")
        XCTAssertEqual(scheme.buildAction?.buildActionEntries.first?.buildableReference.blueprintIdentifier, "23766C111EAA3484007A9026")
        XCTAssertEqual(scheme.buildAction?.buildActionEntries.first?.buildableReference.buildableName, "iOS.app")
        XCTAssertEqual(scheme.buildAction?.buildActionEntries.first?.buildableReference.blueprintName, "iOS")
        XCTAssertEqual(scheme.buildAction?.buildActionEntries.first?.buildableReference.referencedContainer, "container:Project.xcodeproj")
        // Test action
        XCTAssertEqual(scheme.testAction?.buildConfiguration, "Debug")
        XCTAssertEqual(scheme.testAction?.selectedDebuggerIdentifier, "Xcode.DebuggerFoundation.Debugger.LLDB")
        XCTAssertEqual(scheme.testAction?.selectedDebuggerIdentifier, "Xcode.DebuggerFoundation.Debugger.LLDB")
        XCTAssertEqual(scheme.testAction?.shouldUseLaunchSchemeArgsEnv, true)
        XCTAssertEqual(scheme.testAction?.codeCoverageEnabled, false)
        XCTAssertEqual(scheme.testAction?.testables.first?.skipped, false)
        XCTAssertEqual(scheme.testAction?.testables.first?.buildableReference.buildableIdentifier, "primary")
        XCTAssertEqual(scheme.testAction?.testables.first?.buildableReference.blueprintIdentifier, "23766C251EAA3484007A9026")
        XCTAssertEqual(scheme.testAction?.testables.first?.buildableReference.buildableName, "iOSTests.xctest")
        XCTAssertEqual(scheme.testAction?.testables.first?.buildableReference.blueprintName, "iOSTests")
        XCTAssertEqual(scheme.testAction?.testables.first?.buildableReference.referencedContainer, "container:Project.xcodeproj")
        XCTAssertEqual(scheme.testAction?.testables.first?.buildableReference.referencedContainer, "container:Project.xcodeproj")
        XCTAssertEqual(scheme.testAction?.macroExpansion.blueprintIdentifier, "23766C111EAA3484007A9026")
        XCTAssertEqual(scheme.testAction?.macroExpansion.buildableName, "iOS.app")
        XCTAssertEqual(scheme.testAction?.macroExpansion.blueprintName, "iOS")
        XCTAssertEqual(scheme.testAction?.macroExpansion.referencedContainer, "container:Project.xcodeproj")
        XCTAssertEqual(scheme.testAction?.macroExpansion.referencedContainer, "container:Project.xcodeproj")
        XCTAssertNotNil(scheme.testAction?.commandlineArguments)
        if let testCLIArgs = scheme.testAction?.commandlineArguments {
            XCTAssertTrue(testCLIArgs.arguments.count > 0)
            XCTAssertEqual(testCLIArgs.arguments[0].name, "MyTestArgument")
            XCTAssertTrue(testCLIArgs.arguments[0].enabled)
        }

        // Archive action
        XCTAssertEqual(scheme.archiveAction?.buildConfiguration, "Release")
        XCTAssertEqual(scheme.archiveAction?.revealArchiveInOrganizer, true)
        XCTAssertEqual(scheme.archiveAction?.customArchiveName, "TestName")

        // Analyze action
        XCTAssertEqual(scheme.analyzeAction?.buildConfiguration, "Debug")

        // Profile action
        XCTAssertEqual(scheme.profileAction?.buildConfiguration, "Release")
        XCTAssertEqual(scheme.profileAction?.shouldUseLaunchSchemeArgsEnv, true)
        XCTAssertEqual(scheme.profileAction?.savedToolIdentifier, "")
        XCTAssertEqual(scheme.profileAction?.useCustomWorkingDirectory, false)
        XCTAssertEqual(scheme.profileAction?.debugDocumentVersioning, true)
        XCTAssertEqual(scheme.profileAction?.buildableProductRunnable.runnableDebuggingMode, "0")
        XCTAssertEqual(scheme.profileAction?.buildableProductRunnable.buildableReference.buildableIdentifier, "primary")
        XCTAssertEqual(scheme.profileAction?.buildableProductRunnable.buildableReference.blueprintIdentifier, "23766C111EAA3484007A9026")
        XCTAssertEqual(scheme.profileAction?.buildableProductRunnable.buildableReference.buildableName, "iOS.app")
        XCTAssertEqual(scheme.profileAction?.buildableProductRunnable.buildableReference.blueprintName, "iOS")
        XCTAssertEqual(scheme.profileAction?.buildableProductRunnable.buildableReference.referencedContainer, "container:Project.xcodeproj")
        XCTAssertNotNil(scheme.profileAction?.commandlineArguments)
        if let profileCLIArgs = scheme.profileAction?.commandlineArguments {
            XCTAssertTrue(profileCLIArgs.arguments.count > 0)
            XCTAssertEqual(profileCLIArgs.arguments[0].name, "MyProfileArgument")
            XCTAssertFalse(profileCLIArgs.arguments[0].enabled)
        }

        // Launch action
        XCTAssertEqual(scheme.launchAction?.buildConfiguration, "Debug")
        XCTAssertEqual(scheme.launchAction?.selectedDebuggerIdentifier, "Xcode.DebuggerFoundation.Debugger.LLDB")
        XCTAssertEqual(scheme.launchAction?.selectedLauncherIdentifier, "Xcode.DebuggerFoundation.Launcher.LLDB")
        XCTAssertEqual(scheme.launchAction?.launchStyle, .auto)
        XCTAssertEqual(scheme.launchAction?.useCustomWorkingDirectory, false)
        XCTAssertEqual(scheme.launchAction?.ignoresPersistentStateOnLaunch, false)
        XCTAssertEqual(scheme.launchAction?.debugDocumentVersioning, true)
        XCTAssertEqual(scheme.launchAction?.debugServiceExtension, "internal")
        XCTAssertEqual(scheme.launchAction?.allowLocationSimulation, true)
        XCTAssertEqual(scheme.launchAction?.buildableProductRunnable.runnableDebuggingMode, "0")
        XCTAssertEqual(scheme.launchAction?.buildableProductRunnable.buildableReference.buildableIdentifier, "primary")
        XCTAssertEqual(scheme.launchAction?.buildableProductRunnable.buildableReference.blueprintIdentifier, "23766C111EAA3484007A9026")
        XCTAssertEqual(scheme.launchAction?.buildableProductRunnable.buildableReference.buildableName, "iOS.app")
        XCTAssertEqual(scheme.launchAction?.buildableProductRunnable.buildableReference.blueprintName, "iOS")
        XCTAssertEqual(scheme.launchAction?.buildableProductRunnable.buildableReference.referencedContainer, "container:Project.xcodeproj")
        XCTAssertEqual(scheme.launchAction?.locationScenarioReference?.identifier, "com.apple.dt.IDEFoundation.CurrentLocationScenarioIdentifier")
        XCTAssertEqual(scheme.launchAction?.locationScenarioReference?.referenceType, "1")

        XCTAssertNotNil(scheme.launchAction?.commandlineArguments)
        if let launchCLIArgs = scheme.launchAction?.commandlineArguments {
            XCTAssertTrue(launchCLIArgs.arguments.count > 0)
            XCTAssertEqual(launchCLIArgs.arguments[0].name, "MyLaunchArgument")
            XCTAssertTrue(launchCLIArgs.arguments[0].enabled)
        }
    }

    private func fixturePath() -> Path {
        return fixturesPath() + Path("iOS/Project.xcodeproj/xcshareddata/xcschemes/iOS.xcscheme")
    }

}
