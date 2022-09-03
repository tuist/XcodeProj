import AEXML
import Foundation
import PathKit

extension XCScheme {
    public final class ProfileAction: SerialAction {
        // MARK: - Static

        private static let defaultBuildConfiguration = "Release"

        // MARK: - Attributes

        public var runnable: Runnable?
        public var buildableProductRunnable: BuildableProductRunnable? {
            // For backwards compatibility - can be removed in the next major version
            runnable as? BuildableProductRunnable
        }
        public var buildConfiguration: String
        public var shouldUseLaunchSchemeArgsEnv: Bool
        public var savedToolIdentifier: String
        public var ignoresPersistentStateOnLaunch: Bool
        public var customWorkingDirectory: String?
        public var useCustomWorkingDirectory: Bool
        public var debugDocumentVersioning: Bool
        public var askForAppToLaunch: Bool?
        public var commandlineArguments: CommandLineArguments?
        public var environmentVariables: [EnvironmentVariable]?
        public var macroExpansion: BuildableReference?
        public var enableTestabilityWhenProfilingTests: Bool
        public var launchAutomaticallySubstyle: String?

        // MARK: - Init

        public init(runnable: Runnable?,
                    buildConfiguration: String,
                    preActions: [ExecutionAction] = [],
                    postActions: [ExecutionAction] = [],
                    macroExpansion: BuildableReference? = nil,
                    shouldUseLaunchSchemeArgsEnv: Bool = true,
                    savedToolIdentifier: String = "",
                    ignoresPersistentStateOnLaunch: Bool = false,
                    customWorkingDirectory: String? = nil,
                    useCustomWorkingDirectory: Bool = false,
                    debugDocumentVersioning: Bool = true,
                    askForAppToLaunch: Bool? = nil,
                    commandlineArguments: CommandLineArguments? = nil,
                    environmentVariables: [EnvironmentVariable]? = nil,
                    enableTestabilityWhenProfilingTests: Bool = true,
                    launchAutomaticallySubstyle: String? = nil) {
            self.runnable = runnable
            self.buildConfiguration = buildConfiguration
            self.macroExpansion = macroExpansion
            self.shouldUseLaunchSchemeArgsEnv = shouldUseLaunchSchemeArgsEnv
            self.savedToolIdentifier = savedToolIdentifier
            self.customWorkingDirectory = customWorkingDirectory
            self.useCustomWorkingDirectory = useCustomWorkingDirectory
            self.debugDocumentVersioning = debugDocumentVersioning
            self.askForAppToLaunch = askForAppToLaunch
            self.commandlineArguments = commandlineArguments
            self.environmentVariables = environmentVariables
            self.ignoresPersistentStateOnLaunch = ignoresPersistentStateOnLaunch
            self.enableTestabilityWhenProfilingTests = enableTestabilityWhenProfilingTests
            self.launchAutomaticallySubstyle = launchAutomaticallySubstyle
            super.init(preActions, postActions)
        }

        public convenience init(
            buildableProductRunnable: Runnable?,
            buildConfiguration: String,
            preActions: [ExecutionAction] = [],
            postActions: [ExecutionAction] = [],
            macroExpansion: BuildableReference? = nil,
            shouldUseLaunchSchemeArgsEnv: Bool = true,
            savedToolIdentifier: String = "",
            ignoresPersistentStateOnLaunch: Bool = false,
            customWorkingDirectory: String? = nil,
            useCustomWorkingDirectory: Bool = false,
            debugDocumentVersioning: Bool = true,
            askForAppToLaunch: Bool? = nil,
            commandlineArguments: CommandLineArguments? = nil,
            environmentVariables: [EnvironmentVariable]? = nil,
            enableTestabilityWhenProfilingTests: Bool = true,
            launchAutomaticallySubstyle: String? = nil)
        {
            self.init(
                runnable: buildableProductRunnable,
                buildConfiguration: buildConfiguration,
                preActions: preActions,
                postActions: postActions,
                macroExpansion: macroExpansion,
                shouldUseLaunchSchemeArgsEnv: shouldUseLaunchSchemeArgsEnv,
                savedToolIdentifier: savedToolIdentifier,
                ignoresPersistentStateOnLaunch: ignoresPersistentStateOnLaunch,
                customWorkingDirectory: customWorkingDirectory,
                useCustomWorkingDirectory: useCustomWorkingDirectory,
                debugDocumentVersioning: debugDocumentVersioning,
                askForAppToLaunch: askForAppToLaunch,
                commandlineArguments: commandlineArguments,
                environmentVariables: environmentVariables,
                enableTestabilityWhenProfilingTests: enableTestabilityWhenProfilingTests,
                launchAutomaticallySubstyle: launchAutomaticallySubstyle)
        }

        override init(element: AEXMLElement) throws {
            buildConfiguration = element.attributes["buildConfiguration"] ?? ProfileAction.defaultBuildConfiguration
            shouldUseLaunchSchemeArgsEnv = element.attributes["shouldUseLaunchSchemeArgsEnv"].map { $0 == "YES" } ?? true
            savedToolIdentifier = element.attributes["savedToolIdentifier"] ?? ""
            useCustomWorkingDirectory = element.attributes["useCustomWorkingDirectory"] == "YES"
            debugDocumentVersioning = element.attributes["debugDocumentVersioning"].map { $0 == "YES" } ?? true
            askForAppToLaunch = element.attributes["askForAppToLaunch"].map { $0 == "YES" || $0 == "Yes" }
            ignoresPersistentStateOnLaunch = element.attributes["ignoresPersistentStateOnLaunch"].map { $0 == "YES" } ?? false

            // Runnable
            let buildableProductRunnableElement = element["BuildableProductRunnable"]
            let remoteRunnableElement = element["RemoteRunnable"]
            if buildableProductRunnableElement.error == nil {
                runnable = try BuildableProductRunnable(element: buildableProductRunnableElement)
            } else if remoteRunnableElement.error == nil {
                runnable = try RemoteRunnable(element: remoteRunnableElement)
            }

            let buildableReferenceElement = element["MacroExpansion"]["BuildableReference"]
            if buildableReferenceElement.error == nil {
                macroExpansion = try BuildableReference(element: buildableReferenceElement)
            }
            let commandlineOptions = element["CommandLineArguments"]
            if commandlineOptions.error == nil {
                commandlineArguments = try CommandLineArguments(element: commandlineOptions)
            }
            let environmentVariables = element["EnvironmentVariables"]
            if environmentVariables.error == nil {
                self.environmentVariables = try EnvironmentVariable.parseVariables(from: environmentVariables)
            }
            enableTestabilityWhenProfilingTests = element.attributes["enableTestabilityWhenProfilingTests"].map { $0 != "No" } ?? true
            launchAutomaticallySubstyle = element.attributes["launchAutomaticallySubstyle"]
            if let elementCustomWorkingDirectory: String = element.attributes["customWorkingDirectory"] {
                customWorkingDirectory = elementCustomWorkingDirectory
            }
            try super.init(element: element)
        }

        // MARK: - XML

        func xmlElement() -> AEXMLElement {
            let element = AEXMLElement(name: "ProfileAction",
                                       value: nil,
                                       attributes: [
                                           "buildConfiguration": buildConfiguration,
                                           "shouldUseLaunchSchemeArgsEnv": shouldUseLaunchSchemeArgsEnv.xmlString,
                                           "savedToolIdentifier": savedToolIdentifier,
                                           "useCustomWorkingDirectory": useCustomWorkingDirectory.xmlString,
                                           "debugDocumentVersioning": debugDocumentVersioning.xmlString,
                                       ])
            super.writeXML(parent: element)
            if let runnable = runnable {
                element.addChild(runnable.xmlElement())
            }
            if let askForAppToLaunch = askForAppToLaunch {
                element.attributes["askForAppToLaunch"] = askForAppToLaunch.xmlString
            }
            if ignoresPersistentStateOnLaunch {
                element.attributes["ignoresPersistentStateOnLaunch"] = ignoresPersistentStateOnLaunch.xmlString
            }
            if !enableTestabilityWhenProfilingTests {
                element.attributes["enableTestabilityWhenProfilingTests"] = "No"
            }
            if let commandlineArguments = commandlineArguments {
                element.addChild(commandlineArguments.xmlElement())
            }
            if let environmentVariables = environmentVariables {
                element.addChild(EnvironmentVariable.xmlElement(from: environmentVariables))
            }
            if let launchAutomaticallySubstyle = launchAutomaticallySubstyle {
                element.attributes["launchAutomaticallySubstyle"] = launchAutomaticallySubstyle
            }
            if let customWorkingDirectory = customWorkingDirectory {
                element.attributes["customWorkingDirectory"] = customWorkingDirectory
            }

            if let macroExpansion = macroExpansion {
                let macro = element.addChild(name: "MacroExpansion")
                macro.addChild(macroExpansion.xmlElement())
            }

            return element
        }

        // MARK: - Equatable

        override func isEqual(to: Any?) -> Bool {
            guard let rhs = to as? ProfileAction else { return false }
            return super.isEqual(to: to) &&
                runnable == rhs.runnable &&
                buildConfiguration == rhs.buildConfiguration &&
                shouldUseLaunchSchemeArgsEnv == rhs.shouldUseLaunchSchemeArgsEnv &&
                savedToolIdentifier == rhs.savedToolIdentifier &&
                ignoresPersistentStateOnLaunch == rhs.ignoresPersistentStateOnLaunch &&
                customWorkingDirectory == rhs.customWorkingDirectory &&
                useCustomWorkingDirectory == rhs.useCustomWorkingDirectory &&
                debugDocumentVersioning == rhs.debugDocumentVersioning &&
                askForAppToLaunch == rhs.askForAppToLaunch &&
                commandlineArguments == rhs.commandlineArguments &&
                environmentVariables == rhs.environmentVariables &&
                macroExpansion == rhs.macroExpansion &&
                enableTestabilityWhenProfilingTests == rhs.enableTestabilityWhenProfilingTests &&
                launchAutomaticallySubstyle == rhs.launchAutomaticallySubstyle
        }
    }
}
