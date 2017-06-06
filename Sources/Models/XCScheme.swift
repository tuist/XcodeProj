import Foundation
import PathKit
import PathKit
import AEXML

public struct XCScheme {
    
    // MARK: - BuildableReference
    
    public struct BuildableReference {
        public let referencedContainer: String
        public let blueprintIdentifier: String
        public let buildableName: String
        public let buildableIdentifier: String
        public let blueprintName: String
        init(referencedContainer: String,
             blueprintIdentifier: String,
             buildableName: String,
             buildableIdentifier: String,
             blueprintName: String) {
            self.referencedContainer = referencedContainer
            self.blueprintIdentifier = blueprintIdentifier
            self.buildableName = buildableName
            self.buildableIdentifier = buildableIdentifier
            self.blueprintName = blueprintName
        }
        init(element: AEXMLElement) {
            self.buildableIdentifier = element.attributes["BuildableIdentifier"]!
            self.blueprintIdentifier = element.attributes["BlueprintIdentifier"]!
            self.buildableName = element.attributes["BuildableName"]!
            self.blueprintName = element.attributes["BlueprintName"]!
            self.referencedContainer = element.attributes["ReferencedContainer"]!
        }
    }
    
    public struct TestableReference {
        public let skipped: Bool
        public let buildableReference: BuildableReference
        public init(skipped: Bool,
                    buildableReference: BuildableReference) {
            self.skipped = skipped
            self.buildableReference = buildableReference
        }
        public init(element: AEXMLElement) {
            self.skipped = element.attributes["skipped"] == "YES"
            self.buildableReference = BuildableReference(element: element["BuildableReference"])
        }
    }
    
    public struct LocationScenarioReference {
        public let identifier: String
        public let referenceType: String
        public init(identifier: String, referenceType: String) {
            self.identifier = identifier
            self.referenceType = referenceType
        }
        public init(element: AEXMLElement) {
            self.identifier = element.attributes["identifier"]!
            self.referenceType = element.attributes["referenceType"]!
        }
    }
    
    public struct BuildableProductRunnable {
        public let runnableDebuggingMode: String
        public let buildableReference: BuildableReference
        public init(runnableDebuggingMode: String,
                    buildableReference: BuildableReference) {
            self.runnableDebuggingMode = runnableDebuggingMode
            self.buildableReference = buildableReference
        }
        public init(element: AEXMLElement) {
            self.runnableDebuggingMode = element.attributes["runnableDebuggingMode"]!
            self.buildableReference = BuildableReference(element:  element["BuildableReference"])
        }
    }
    
    // MARK: - Build Action
    
    public struct BuildAction {
        
        public struct Entry {
            
            public enum BuildFor {
                case running, testing, profiling, archiving, analyzing
                static var `default`: [BuildFor] = [.running, .testing, .archiving, .analyzing]
                static var indexing: [BuildFor] = [.testing, .analyzing, .archiving]
                static var testOnly: [BuildFor] = [.testing, .analyzing]
            }
            
            public let buildableReference: BuildableReference
            public let buildFor: [BuildFor]

            public init(buildableReference: BuildableReference,
                        buildFor: [BuildFor]) {
                self.buildableReference = buildableReference
                self.buildFor = buildFor
            }
            public init(element: AEXMLElement) {
                var buildFor: [BuildFor] = []
                if element.attributes["buildForTesting"] == "YES" {
                    buildFor.append(.testing)
                }
                if element.attributes["buildForRunning"] == "YES" {
                    buildFor.append(.running)
                }
                if element.attributes["buildForProfiling"] == "YES" {
                    buildFor.append(.profiling)
                }
                if element.attributes["buildForArchiving"] == "YES" {
                    buildFor.append(.archiving)
                }
                if element.attributes["buildForAnalyzing"] == "YES" {
                    buildFor.append(.analyzing)
                }
                self.buildFor = buildFor
                self.buildableReference = BuildableReference(element: element["BuildableReference"])
            }
        }

        public let buildActionEntries: [Entry]
        public let parallelizeBuild: Bool
        public let buildImplicitDependencies: Bool
    
        public init(buildActionEntries: [Entry] = [],
                    parallelizeBuild: Bool = false,
                    buildImplicitDependencies: Bool = false) {
            self.buildActionEntries = buildActionEntries
            self.parallelizeBuild = parallelizeBuild
            self.buildImplicitDependencies = buildImplicitDependencies
        }
        
        public init(element: AEXMLElement) {
            parallelizeBuild = element.attributes["parallelizeBuildables"]! == "YES"
            buildImplicitDependencies = element.attributes["buildImplicitDependencies"]! == "YES"
            self.buildActionEntries = element["BuildActionEntries"]["BuildActionEntry"]
                .all?
                .map(Entry.init) ?? []
        }
    
        public func add(buildActionEntry: Entry) -> BuildAction {
            var buildActionEntries = self.buildActionEntries
            buildActionEntries.append(buildActionEntry)
            return BuildAction(buildActionEntries: buildActionEntries,
                               parallelizeBuild: parallelizeBuild)
        }
    }
    
    public struct LaunchAction {
        
        public enum Style: String {
            case auto = "0"
            case wait = "1"
        }

        public let buildableProductRunnable: BuildableProductRunnable
        public let selectedDebuggerIdentifier: String
        public let selectedLauncherIdentifier: String
        public let buildConfiguration: String
        public let launchStyle: Style
        public let useCustomWorkingDirectory: Bool
        public let ignoresPersistentStateOnLaunch: Bool
        public let debugDocumentVersioning: Bool
        public let debugServiceExtension: String
        public let allowLocationSimulation: Bool
        public let locationScenarioReference: LocationScenarioReference?
        
        public init(buildableProductRunnable: BuildableProductRunnable,
                    selectedDebuggerIdentifier: String,
                    selectedLauncherIdentifier: String,
                    buildConfiguration: String,
                    launchStyle: Style,
                    useCustomWorkingDirectory: Bool,
                    ignoresPersistentStateOnLaunch: Bool,
                    debugDocumentVersioning: Bool,
                    debugServiceExtension: String,
                    allowLocationSimulation: Bool,
                    locationScenarioReference: LocationScenarioReference? = nil) {
            self.buildableProductRunnable = buildableProductRunnable
            self.buildConfiguration = buildConfiguration
            self.launchStyle = launchStyle
            self.selectedDebuggerIdentifier = selectedDebuggerIdentifier
            self.selectedLauncherIdentifier = selectedLauncherIdentifier
            self.useCustomWorkingDirectory = useCustomWorkingDirectory
            self.ignoresPersistentStateOnLaunch = ignoresPersistentStateOnLaunch
            self.debugDocumentVersioning = debugDocumentVersioning
            self.debugServiceExtension = debugServiceExtension
            self.allowLocationSimulation = allowLocationSimulation
            self.locationScenarioReference = locationScenarioReference
        }
        
        public init(element: AEXMLElement) {
            self.buildConfiguration = element.attributes["buildConfiguration"]!
            self.selectedDebuggerIdentifier = element.attributes["selectedDebuggerIdentifier"]!
            self.selectedLauncherIdentifier = element.attributes["selectedLauncherIdentifier"]!
            self.launchStyle = Style(rawValue: element.attributes["launchStyle"]!) ?? .auto
            self.useCustomWorkingDirectory = element.attributes["useCustomWorkingDirectory"] == "YES"
            self.ignoresPersistentStateOnLaunch = element.attributes["ignoresPersistentStateOnLaunch"] == "YES"
            self.debugDocumentVersioning = element.attributes["debugDocumentVersioning"] == "YES"
            self.debugServiceExtension = element.attributes["debugServiceExtension"]!
            self.allowLocationSimulation = element.attributes["allowLocationSimulation"] == "YES"
            self.buildableProductRunnable = BuildableProductRunnable(element:  element["BuildableProductRunnable"])
            if let _ = element["LocationScenarioReference"].all?.first {
                self.locationScenarioReference = LocationScenarioReference(element: element["LocationScenarioReference"])
            } else {
                self.locationScenarioReference = nil
            }
        }
    }
    
    public struct ProfileAction {
        public let buildableProductRunnable: BuildableProductRunnable
        public let buildconfiguration: String
        public let shouldUseLaunchSchemeArgsEnv: Bool
        public let savedToolIdentifier: String
        public let useCustomWorkingDirectory: Bool
        public let debugDocumentVersioning: Bool
        public init(buildableProductRunnable: BuildableProductRunnable,
                    buildConfiguration: String,
                    shouldUseLaunchSchemeArgsEnv: Bool,
                    savedToolIdentifier: String,
                    useCustomWorkingDirectory: Bool,
                    debugDocumentVersioning: Bool) {
            self.buildableProductRunnable = buildableProductRunnable
            self.buildconfiguration = buildConfiguration
            self.shouldUseLaunchSchemeArgsEnv = shouldUseLaunchSchemeArgsEnv
            self.savedToolIdentifier = savedToolIdentifier
            self.useCustomWorkingDirectory = useCustomWorkingDirectory
            self.debugDocumentVersioning = debugDocumentVersioning
        }
        
        public init(element: AEXMLElement) {
            self.buildconfiguration = element.attributes["buildConfiguration"]!
            self.shouldUseLaunchSchemeArgsEnv = element.attributes["shouldUseLaunchSchemeArgsEnv"] == "YES"
            self.savedToolIdentifier = element.attributes["savedToolIdentifier"]!
            self.useCustomWorkingDirectory = element.attributes["useCustomWorkingDirectory"] == "YES"
            self.debugDocumentVersioning = element.attributes["debugDocumentVersioning"] == "YES"
            self.buildableProductRunnable = BuildableProductRunnable(element: element["BuildableProductRunnable"])
        }
    }
    
    public struct TestAction {
        public let testables: [TestableReference]
        public let buildConfiguration: String
        public let selectedDebuggerIdentifier: String
        public let shouldUseLaunchSchemeArgsEnv: Bool
        public let macroExpansion: BuildableReference
        public init(buildConfiguration: String,
                    selectedDebuggerIdentifier: String,
                    shouldUseLaunchSchemeArgsEnv: Bool,
                    macroExpansion: BuildableReference,
                    testables: [TestableReference] = []) {
            self.buildConfiguration = buildConfiguration
            self.selectedDebuggerIdentifier = selectedDebuggerIdentifier
            self.shouldUseLaunchSchemeArgsEnv = shouldUseLaunchSchemeArgsEnv
            self.testables = testables
            self.macroExpansion = macroExpansion
        }
        
        public init(element: AEXMLElement) {
            self.buildConfiguration = element.attributes["buildConfiguration"]!
            self.selectedDebuggerIdentifier = element.attributes["selectedDebuggerIdentifier"]!
            self.shouldUseLaunchSchemeArgsEnv = element.attributes["shouldUseLaunchSchemeArgsEnv"] == "YES"
            self.testables = element["Testables"]["TestableReference"]
                .all?
                .map(TestableReference.init) ?? []
            self.macroExpansion = BuildableReference(element: element["MacroExpansion"]["BuildableReference"])
        }

    }
    
    public struct AnalyzeAction {
        public let buildConfiguration: String
        public init(buildConfiguration: String) {
            self.buildConfiguration = buildConfiguration
        }
        public init(element: AEXMLElement) {
            self.buildConfiguration = element.attributes["buildConfiguration"]!
        }
    }
    
    public struct ArchiveAction {
        public let buildConfiguration: String
        public let revealArchiveInOrganizer: Bool
        public let customArchiveName: String?
        public init(buildConfiguration: String,
                    revealArchiveInOrganizer: Bool,
                    customArchiveName: String? = nil) {
            self.buildConfiguration = buildConfiguration
            self.revealArchiveInOrganizer = revealArchiveInOrganizer
            self.customArchiveName = customArchiveName
        }
        public init(element: AEXMLElement) {
            self.buildConfiguration = element.attributes["buildConfiguration"]!
            self.revealArchiveInOrganizer = element.attributes["revealArchiveInOrganizer"] == "YES"
            self.customArchiveName = element.attributes["customArchiveName"]!
        }
    }
    
    // MARK: - Properties
    
    public let buildAction: BuildAction?
    public let testAction: TestAction?
    public let launchAction: LaunchAction?
    public let profileAction: ProfileAction?
    public let analyzeAction: AnalyzeAction?
    public let archiveAction: ArchiveAction?
    public let lastUpgradeVersion: String?
    public let version: String?
    public let path: Path
    
    // MARK: - Init
    
    /// Initializes the scheme reading the content from the disk.
    ///
    /// - Parameters:
    ///   - path: scheme path.
    public init(path: Path, fileManager: FileManager = .default) throws {
        if !fileManager.fileExists(atPath: path.string) {
            throw XCSchemeError.notFound(path: path)
        }
        self.path = path
        let data = try Data(contentsOf: path.url)
        let document = try AEXMLDocument(xml: data)
        let scheme = document["Scheme"]
        lastUpgradeVersion = scheme.attributes["LastUpgradeVersion"]
        version = scheme.attributes["version"]
        buildAction = BuildAction(element: scheme["BuildAction"])
        testAction = TestAction(element: scheme["TestAction"])
        launchAction = LaunchAction(element: scheme["LaunchAction"])
        analyzeAction = AnalyzeAction(element: scheme["AnalyzeAction"])
        archiveAction = ArchiveAction(element: scheme["ArchiveAction"])
        profileAction = ProfileAction(element: scheme["ProfileAction"])
    }
    
    public init(path: Path,
                lastUpgradeVersion: String?,
                version: String?,
                buildAction: BuildAction? = nil,
                testAction: TestAction? = nil,
                launchAction: LaunchAction? = nil,
                profileAction: ProfileAction? = nil,
                analyzeAction: AnalyzeAction? = nil,
                archiveAction: ArchiveAction? = nil) {
        self.path = path
        self.lastUpgradeVersion = lastUpgradeVersion
        self.version = version
        self.buildAction = buildAction
        self.testAction = testAction
        self.launchAction = launchAction
        self.profileAction = profileAction
        self.analyzeAction = analyzeAction
        self.archiveAction = archiveAction
    }
    
}

public enum XCSchemeError: Error, CustomStringConvertible {
    case notFound(path: Path)
    
    public var description: String {
        switch self {
        case .notFound(let path):
            return ".xcscheme couldn't be found at path \(path)"
        }
    }
}
