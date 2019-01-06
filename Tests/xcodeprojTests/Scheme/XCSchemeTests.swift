import Foundation
import PathKit
@testable import xcodeproj
import XCTest

final class XCSchemeIntegrationTests: XCTestCase {
    func test_read_iosScheme() {
        let subject = try? XCScheme(path: iosSchemePath)

        XCTAssertNotNil(subject)
        if let subject = subject {
            assert(scheme: subject)
        }
    }

    func test_write_iosScheme() {
        testWrite(from: iosSchemePath,
                  initModel: { try? XCScheme(path: $0) },
                  modify: { $0 },
                  assertion: { assert(scheme: $1) })
    }

    func test_read_minimalScheme() {
        let subject = try? XCScheme(path: minimalSchemePath)

        XCTAssertNotNil(subject)
        if let subject = subject {
            assert(minimalScheme: subject)
        }
    }

    func test_write_minimalScheme() {
        testWrite(from: minimalSchemePath,
                  initModel: { try? XCScheme(path: $0) },
                  modify: { $0 },
                  assertion: { assert(minimalScheme: $1) })
    }

    func test_write_testableReferenceDefaultAttributesValuesAreOmitted() {
        let reference = XCScheme.TestableReference(
            skipped: false,
            parallelizable: false,
            randomExecutionOrdering: false,
            buildableReference: XCScheme.BuildableReference(
                referencedContainer: "",
                blueprint: PBXObject(),
                buildableName: "",
                blueprintName: ""
            ),
            skippedTests: []
        )
        let subject = reference.xmlElement()
        XCTAssertNil(subject.attributes["parallelizable"])
        XCTAssertNil(subject.attributes["testExecutionOrdering"])
    }

    func test_write_testableReferenceAttributesValues() {
        let reference = XCScheme.TestableReference(
            skipped: false,
            parallelizable: true,
            randomExecutionOrdering: true,
            buildableReference: XCScheme.BuildableReference(
                referencedContainer: "",
                blueprint: PBXObject(),
                buildableName: "",
                blueprintName: ""
            ),
            skippedTests: []
        )
        let subject = reference.xmlElement()
        XCTAssertEqual(subject.attributes["skipped"], "NO")
        XCTAssertEqual(subject.attributes["parallelizable"], "YES")
        XCTAssertEqual(subject.attributes["testExecutionOrdering"], "random")
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
        XCTAssertEqual(scheme.buildAction?.preActions.first?.title, "Build Pre-action")
        XCTAssertEqual(scheme.buildAction?.preActions.first?.scriptText, "echo prebuild")
        XCTAssertEqual(scheme.buildAction?.postActions.first?.title, "Build Post-action")
        XCTAssertEqual(scheme.buildAction?.postActions.first?.scriptText, "echo postbuild")
        // Test action
        XCTAssertEqual(scheme.testAction?.buildConfiguration, "Debug")
        XCTAssertEqual(scheme.testAction?.selectedDebuggerIdentifier, "Xcode.DebuggerFoundation.Debugger.LLDB")
        XCTAssertEqual(scheme.testAction?.selectedDebuggerIdentifier, "Xcode.DebuggerFoundation.Debugger.LLDB")
        XCTAssertEqual(scheme.testAction?.shouldUseLaunchSchemeArgsEnv, true)
        XCTAssertEqual(scheme.testAction?.codeCoverageEnabled, false)
        XCTAssertEqual(scheme.testAction?.testables.first?.skipped, false)
        XCTAssertEqual(scheme.testAction?.testables.first?.parallelizable, false)
        XCTAssertEqual(scheme.testAction?.testables.first?.randomExecutionOrdering, false)
        XCTAssertEqual(scheme.testAction?.testables.first?.buildableReference.buildableIdentifier, "primary")
        XCTAssertEqual(scheme.testAction?.testables.first?.buildableReference.blueprintIdentifier, "23766C251EAA3484007A9026")
        XCTAssertEqual(scheme.testAction?.testables.first?.buildableReference.buildableName, "iOSTests.xctest")
        XCTAssertEqual(scheme.testAction?.testables.first?.buildableReference.blueprintName, "iOSTests")
        XCTAssertEqual(scheme.testAction?.testables.first?.buildableReference.referencedContainer, "container:Project.xcodeproj")
        XCTAssertEqual(scheme.testAction?.testables.first?.buildableReference.referencedContainer, "container:Project.xcodeproj")
        XCTAssertEqual(scheme.testAction?.preActions.first?.title, "First Pre-action")
        XCTAssertEqual(scheme.testAction?.preActions.first?.scriptText, "echo first")
        XCTAssertEqual(scheme.testAction?.preActions.last?.title, "Second Pre-action")
        XCTAssertEqual(scheme.testAction?.preActions.last?.scriptText, "echo second")
        XCTAssertEqual(scheme.testAction?.postActions.first?.title, "First Post-action")
        XCTAssertEqual(scheme.testAction?.postActions.first?.scriptText, "echo penultimate")
        XCTAssertEqual(scheme.testAction?.postActions.last?.title, "Second Post-action")
        XCTAssertEqual(scheme.testAction?.postActions.last?.scriptText, "echo last")
        XCTAssertEqual(scheme.testAction?.macroExpansion?.blueprintIdentifier, "23766C111EAA3484007A9026")
        XCTAssertEqual(scheme.testAction?.macroExpansion?.buildableName, "iOS.app")
        XCTAssertEqual(scheme.testAction?.macroExpansion?.blueprintName, "iOS")
        XCTAssertEqual(scheme.testAction?.macroExpansion?.referencedContainer, "container:Project.xcodeproj")
        XCTAssertEqual(scheme.testAction?.macroExpansion?.referencedContainer, "container:Project.xcodeproj")
        XCTAssertEqual(scheme.testAction?.enableAddressSanitizer, false)
        XCTAssertEqual(scheme.testAction?.enableASanStackUseAfterReturn, false)
        XCTAssertEqual(scheme.testAction?.enableThreadSanitizer, false)
        XCTAssertEqual(scheme.testAction?.enableUBSanitizer, false)
        XCTAssertEqual(scheme.testAction?.disableMainThreadChecker, false)
        XCTAssertEqual(scheme.testAction?.additionalOptions.isEmpty, true)

        let testEnvironmentVariables = XCTAssertNotNilAndUnwrap(scheme.testAction?.environmentVariables)
        XCTAssertEqual(testEnvironmentVariables.count, 1)
        XCTAssertEqual(testEnvironmentVariables[0].variable, "ENV_VAR")
        XCTAssertEqual(testEnvironmentVariables[0].value, "TEST")
        XCTAssertFalse(testEnvironmentVariables[0].enabled)

        let testCLIArgs = XCTAssertNotNilAndUnwrap(scheme.testAction?.commandlineArguments)
        XCTAssertTrue(testCLIArgs.arguments.count > 0)
        XCTAssertEqual(testCLIArgs.arguments[0].name, "MyTestArgument")
        XCTAssertTrue(testCLIArgs.arguments[0].enabled)

        // Archive action
        XCTAssertEqual(scheme.archiveAction?.buildConfiguration, "Release")
        XCTAssertEqual(scheme.archiveAction?.revealArchiveInOrganizer, true)
        XCTAssertEqual(scheme.archiveAction?.customArchiveName, "TestName")
        XCTAssertEqual(scheme.archiveAction?.preActions.isEmpty, true)
        XCTAssertEqual(scheme.archiveAction?.postActions.isEmpty, true)

        // Analyze action
        XCTAssertEqual(scheme.analyzeAction?.buildConfiguration, "Debug")

        // Profile action
        XCTAssertEqual(scheme.profileAction?.buildConfiguration, "Release")
        XCTAssertEqual(scheme.profileAction?.shouldUseLaunchSchemeArgsEnv, true)
        XCTAssertEqual(scheme.profileAction?.savedToolIdentifier, "")
        XCTAssertEqual(scheme.profileAction?.useCustomWorkingDirectory, false)
        XCTAssertEqual(scheme.profileAction?.debugDocumentVersioning, true)
        XCTAssertEqual(scheme.profileAction?.buildableProductRunnable?.runnableDebuggingMode, "0")
        XCTAssertEqual(scheme.profileAction?.buildableProductRunnable?.buildableReference.buildableIdentifier, "primary")
        XCTAssertEqual(scheme.profileAction?.buildableProductRunnable?.buildableReference.blueprintIdentifier, "23766C111EAA3484007A9026")
        XCTAssertEqual(scheme.profileAction?.buildableProductRunnable?.buildableReference.buildableName, "iOS.app")
        XCTAssertEqual(scheme.profileAction?.buildableProductRunnable?.buildableReference.blueprintName, "iOS")
        XCTAssertEqual(scheme.profileAction?.buildableProductRunnable?.buildableReference.referencedContainer, "container:Project.xcodeproj")
        XCTAssertEqual(scheme.profileAction?.preActions.isEmpty, true)
        XCTAssertEqual(scheme.profileAction?.postActions.first?.title, "Run Script")
        XCTAssertEqual(scheme.profileAction?.postActions.first?.scriptText, "echo analysis done")

        let profileEnvironmentVariables = XCTAssertNotNilAndUnwrap(scheme.profileAction?.environmentVariables)
        XCTAssertEqual(profileEnvironmentVariables.count, 1)
        XCTAssertEqual(profileEnvironmentVariables[0].variable, "ENV_VAR")
        XCTAssertEqual(profileEnvironmentVariables[0].value, "PROFILE")
        XCTAssertTrue(profileEnvironmentVariables[0].enabled)

        let profileCLIArgs = XCTAssertNotNilAndUnwrap(scheme.profileAction?.commandlineArguments)
        XCTAssertTrue(profileCLIArgs.arguments.count > 0)
        XCTAssertEqual(profileCLIArgs.arguments[0].name, "MyProfileArgument")
        XCTAssertFalse(profileCLIArgs.arguments[0].enabled)

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
        XCTAssertEqual(scheme.launchAction?.buildableProductRunnable?.runnableDebuggingMode, "0")
        XCTAssertEqual(scheme.launchAction?.buildableProductRunnable?.buildableReference.buildableIdentifier, "primary")
        XCTAssertEqual(scheme.launchAction?.buildableProductRunnable?.buildableReference.blueprintIdentifier, "23766C111EAA3484007A9026")
        XCTAssertEqual(scheme.launchAction?.buildableProductRunnable?.buildableReference.buildableName, "iOS.app")
        XCTAssertEqual(scheme.launchAction?.buildableProductRunnable?.buildableReference.blueprintName, "iOS")
        XCTAssertEqual(scheme.launchAction?.buildableProductRunnable?.buildableReference.referencedContainer, "container:Project.xcodeproj")
        XCTAssertEqual(scheme.launchAction?.locationScenarioReference?.identifier, "com.apple.dt.IDEFoundation.CurrentLocationScenarioIdentifier")
        XCTAssertEqual(scheme.launchAction?.locationScenarioReference?.referenceType, "1")
        XCTAssertEqual(scheme.launchAction?.preActions.first?.title, "")
        XCTAssertEqual(scheme.launchAction?.preActions.first?.scriptText, "echo prerun")
        XCTAssertEqual(scheme.launchAction?.preActions.first?.environmentBuildable?.buildableIdentifier, "primary")
        XCTAssertEqual(scheme.launchAction?.preActions.first?.environmentBuildable?.blueprintIdentifier, "23766C111EAA3484007A9026")
        XCTAssertEqual(scheme.launchAction?.preActions.first?.environmentBuildable?.buildableName, "iOS.app")
        XCTAssertEqual(scheme.launchAction?.preActions.first?.environmentBuildable?.blueprintName, "iOS")
        XCTAssertEqual(scheme.launchAction?.preActions.first?.environmentBuildable?.referencedContainer, "container:Project.xcodeproj")
        XCTAssertEqual(scheme.launchAction?.postActions.first?.title, "Nothing")
        XCTAssertEqual(scheme.launchAction?.postActions.first?.scriptText, "")
        XCTAssertEqual(scheme.launchAction?.postActions.first?.environmentBuildable?.buildableIdentifier, "primary")
        XCTAssertEqual(scheme.launchAction?.postActions.first?.environmentBuildable?.blueprintIdentifier, "23766C251EAA3484007A9026")
        XCTAssertEqual(scheme.launchAction?.postActions.first?.environmentBuildable?.buildableName, "iOSTests.xctest")
        XCTAssertEqual(scheme.launchAction?.postActions.first?.environmentBuildable?.blueprintName, "iOSTests")
        XCTAssertEqual(scheme.launchAction?.postActions.first?.environmentBuildable?.referencedContainer, "container:Project.xcodeproj")
        XCTAssertEqual(scheme.launchAction?.enableAddressSanitizer, false)
        XCTAssertEqual(scheme.launchAction?.enableASanStackUseAfterReturn, false)
        XCTAssertEqual(scheme.launchAction?.enableThreadSanitizer, false)
        XCTAssertEqual(scheme.launchAction?.stopOnEveryThreadSanitizerIssue, false)
        XCTAssertEqual(scheme.launchAction?.enableUBSanitizer, false)
        XCTAssertEqual(scheme.launchAction?.stopOnEveryUBSanitizerIssue, false)
        XCTAssertEqual(scheme.launchAction?.disableMainThreadChecker, false)
        XCTAssertEqual(scheme.launchAction?.stopOnEveryMainThreadCheckerIssue, false)
        XCTAssertEqual(scheme.launchAction?.additionalOptions.isEmpty, true)

        let launchEnvironmentVariables = XCTAssertNotNilAndUnwrap(scheme.launchAction?.environmentVariables)
        XCTAssertEqual(launchEnvironmentVariables.count, 1)
        XCTAssertEqual(launchEnvironmentVariables[0].variable, "ENV_VAR")
        XCTAssertEqual(launchEnvironmentVariables[0].value, "RUN")
        XCTAssertTrue(launchEnvironmentVariables[0].enabled)

        let launchCLIArgs = XCTAssertNotNilAndUnwrap(scheme.launchAction?.commandlineArguments)
        XCTAssertTrue(launchCLIArgs.arguments.count > 0)
        XCTAssertEqual(launchCLIArgs.arguments[0].name, "MyLaunchArgument")
        XCTAssertTrue(launchCLIArgs.arguments[0].enabled)
    }

    private func assert(minimalScheme scheme: XCScheme) {
        XCTAssertEqual(scheme.version, "1.3")
        XCTAssertNil(scheme.lastUpgradeVersion)

        // Build action
        XCTAssertTrue(scheme.buildAction?.parallelizeBuild == true)
        XCTAssertTrue(scheme.buildAction?.buildImplicitDependencies == true)
        XCTAssertTrue(scheme.buildAction?.buildActionEntries.first?.buildFor.contains(.testing) == true)
        XCTAssertTrue(scheme.buildAction?.buildActionEntries.first?.buildFor.contains(.running) == false)
        XCTAssertTrue(scheme.buildAction?.buildActionEntries.first?.buildFor.contains(.profiling) == true)
        XCTAssertTrue(scheme.buildAction?.buildActionEntries.first?.buildFor.contains(.archiving) == true)
        XCTAssertTrue(scheme.buildAction?.buildActionEntries.first?.buildFor.contains(.analyzing) == true)
        XCTAssertEqual(scheme.buildAction?.buildActionEntries.first?.buildableReference.buildableIdentifier, "primary")
        XCTAssertEqual(scheme.buildAction?.buildActionEntries.first?.buildableReference.blueprintIdentifier, "651BA89E1E459798004EAFE5")
        XCTAssertEqual(scheme.buildAction?.buildActionEntries.first?.buildableReference.buildableName, "ais.xctest")
        XCTAssertEqual(scheme.buildAction?.buildActionEntries.first?.buildableReference.blueprintName, "ais-Tests")
        XCTAssertEqual(scheme.buildAction?.buildActionEntries.first?.buildableReference.referencedContainer, "container:ais.xcodeproj")

        // Test action
        XCTAssertEqual(scheme.testAction?.buildConfiguration, "Debug")
        XCTAssertEqual(scheme.testAction?.selectedDebuggerIdentifier, "Xcode.DebuggerFoundation.Debugger.LLDB")
        XCTAssertEqual(scheme.testAction?.selectedLauncherIdentifier, "Xcode.DebuggerFoundation.Launcher.LLDB")
        XCTAssertTrue(scheme.testAction?.shouldUseLaunchSchemeArgsEnv == true)
        XCTAssertTrue(scheme.testAction?.codeCoverageEnabled == false)
        XCTAssertNil(scheme.testAction?.macroExpansion)
        XCTAssertEqual(scheme.testAction?.enableAddressSanitizer, false)
        XCTAssertEqual(scheme.testAction?.enableASanStackUseAfterReturn, false)
        XCTAssertEqual(scheme.testAction?.enableThreadSanitizer, false)
        XCTAssertEqual(scheme.testAction?.enableUBSanitizer, false)
        XCTAssertEqual(scheme.testAction?.disableMainThreadChecker, false)
        XCTAssertEqual(scheme.testAction?.additionalOptions.isEmpty, true)
        XCTAssertNil(scheme.testAction?.commandlineArguments)
        XCTAssertNil(scheme.testAction?.environmentVariables)

        // Launch action
        XCTAssertNil(scheme.launchAction?.buildableProductRunnable)
        XCTAssertEqual(scheme.launchAction?.selectedDebuggerIdentifier, XCScheme.defaultDebugger)
        XCTAssertEqual(scheme.launchAction?.selectedLauncherIdentifier, XCScheme.defaultLauncher)
        XCTAssertEqual(scheme.launchAction?.buildConfiguration, "Debug")
        XCTAssertEqual(scheme.launchAction?.launchStyle, XCScheme.LaunchAction.Style.auto)
        XCTAssertTrue(scheme.launchAction?.useCustomWorkingDirectory == false)
        XCTAssertTrue(scheme.launchAction?.ignoresPersistentStateOnLaunch == false)
        XCTAssertTrue(scheme.launchAction?.debugDocumentVersioning == true)
        XCTAssertEqual(scheme.launchAction?.debugServiceExtension, XCScheme.LaunchAction.defaultDebugServiceExtension)
        XCTAssertTrue(scheme.launchAction?.allowLocationSimulation == true)
        XCTAssertNil(scheme.launchAction?.locationScenarioReference)
        XCTAssertNil(scheme.launchAction?.commandlineArguments)
        XCTAssertEqual(scheme.launchAction?.enableAddressSanitizer, false)
        XCTAssertEqual(scheme.launchAction?.enableASanStackUseAfterReturn, false)
        XCTAssertEqual(scheme.launchAction?.enableThreadSanitizer, false)
        XCTAssertEqual(scheme.launchAction?.stopOnEveryThreadSanitizerIssue, false)
        XCTAssertEqual(scheme.launchAction?.enableUBSanitizer, false)
        XCTAssertEqual(scheme.launchAction?.stopOnEveryUBSanitizerIssue, false)
        XCTAssertEqual(scheme.launchAction?.disableMainThreadChecker, false)
        XCTAssertEqual(scheme.launchAction?.stopOnEveryMainThreadCheckerIssue, false)
        XCTAssertEqual(scheme.launchAction?.additionalOptions.isEmpty, true)

        let launchEnvironmentVariables = XCTAssertNotNilAndUnwrap(scheme.launchAction?.environmentVariables)
        XCTAssertEqual(launchEnvironmentVariables.count, 1)
        XCTAssertEqual(launchEnvironmentVariables[0].variable, "AI_TEST_MODE")
        XCTAssertEqual(launchEnvironmentVariables[0].value, "integration")
        XCTAssertTrue(launchEnvironmentVariables[0].enabled)

        // Profile action
        XCTAssertNil(scheme.profileAction?.buildableProductRunnable)
        XCTAssertEqual(scheme.profileAction?.buildConfiguration, "Release")
        XCTAssertTrue(scheme.profileAction?.shouldUseLaunchSchemeArgsEnv == true)
        XCTAssertEqual(scheme.profileAction?.savedToolIdentifier, "")
        XCTAssertTrue(scheme.profileAction?.useCustomWorkingDirectory == false)
        XCTAssertTrue(scheme.profileAction?.debugDocumentVersioning == true)
        XCTAssertNil(scheme.profileAction?.commandlineArguments)
        XCTAssertNil(scheme.profileAction?.environmentVariables)

        // Analzye action
        XCTAssertEqual(scheme.analyzeAction?.buildConfiguration, "Debug")

        // Archive action
        XCTAssertEqual(scheme.archiveAction?.buildConfiguration, "Release")
        XCTAssertTrue(scheme.archiveAction?.revealArchiveInOrganizer == true)
        XCTAssertNil(scheme.archiveAction?.customArchiveName)
    }

    private var iosSchemePath: Path {
        return fixturesPath() + "iOS/Project.xcodeproj/xcshareddata/xcschemes/iOS.xcscheme"
    }

    private var minimalSchemePath: Path {
        // Not strictly minimal in the sense that it specifies the least amount of information to be valid,
        // but minimal in the sense it doesn't have most of the standard elements and attributes.
        return fixturesPath() + "Schemes/MinimalInformation.xcscheme"
    }
}
