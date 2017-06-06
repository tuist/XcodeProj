import Foundation
import PathKit
import PathKit
import SWXMLHash

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
        init(indexer: XMLIndexer) {
            self.buildableIdentifier = indexer.element!.attribute(by: "BuildableIdentifier")!.text
            self.blueprintIdentifier = indexer.element!.attribute(by: "BlueprintIdentifier")!.text
            self.buildableName = indexer.element!.attribute(by: "BuildableName")!.text
            self.blueprintName = indexer.element!.attribute(by: "BlueprintName")!.text
            self.referencedContainer = indexer.element!.attribute(by: "ReferencedContainer")!.text
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
        public init(indexer: XMLIndexer) {
            self.skipped = indexer.element!.attribute(by: "skipped")!.text == "YES"
            self.buildableReference = BuildableReference(indexer: indexer["BuildableReference"])
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
        public init(indexer: XMLIndexer) {
            self.runnableDebuggingMode = indexer.element!.attribute(by: "runnableDebuggingMode")!.text
            self.buildableReference = BuildableReference(indexer: indexer["BuildableReference"])
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
            public init(indexer: XMLIndexer) {
                var buildFor: [BuildFor] = []
                if indexer.element?.attribute(by: "buildForTesting")?.text == "YES" {
                    buildFor.append(.testing)
                }
                if indexer.element?.attribute(by: "buildForRunning")?.text == "YES" {
                    buildFor.append(.running)
                }
                if indexer.element?.attribute(by: "buildForProfiling")?.text == "YES" {
                    buildFor.append(.profiling)
                }
                if indexer.element?.attribute(by: "buildForArchiving")?.text == "YES" {
                    buildFor.append(.archiving)
                }
                if indexer.element?.attribute(by: "buildForAnalyzing")?.text == "YES" {
                    buildFor.append(.analyzing)
                }
                self.buildFor = buildFor
                self.buildableReference = BuildableReference(indexer: indexer["BuildableReference"])
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
        
        public init(indexer: XMLIndexer) {
            let element = indexer.element!
            parallelizeBuild = element.attribute(by: "parallelizeBuildables")?.text == "YES"
            buildImplicitDependencies = element.attribute(by: "buildImplicitDependencies")?.text == "YES"
            self.buildActionEntries = indexer["BuildActionEntries"]["BuildActionEntry"]
                .all
                .map(Entry.init)
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

        public init(buildableProductRunnable: BuildableProductRunnable,
                    selectedDebuggerIdentifier: String,
                    selectedLauncherIdentifier: String,
                    buildConfiguration: String,
                    launchStyle: Style,
                    useCustomWorkingDirectory: Bool,
                    ignoresPersistentStateOnLaunch: Bool,
                    debugDocumentVersioning: Bool,
                    debugServiceExtension: String,
                    allowLocationSimulation: Bool) {
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
        }
        
        public init(indexer: XMLIndexer) {
            self.buildConfiguration = indexer.element!.attribute(by: "buildConfiguration")!.text
            self.selectedDebuggerIdentifier = indexer.element!.attribute(by: "selectedDebuggerIdentifier")!.text
            self.selectedLauncherIdentifier = indexer.element!.attribute(by: "selectedLauncherIdentifier")!.text
            self.launchStyle = Style(rawValue: indexer.element!.attribute(by: "launchStyle")!.text) ?? .auto
            self.useCustomWorkingDirectory = indexer.element!.attribute(by: "useCustomWorkingDirectory")!.text == "YES"
            self.ignoresPersistentStateOnLaunch = indexer.element!.attribute(by: "ignoresPersistentStateOnLaunch")!.text == "YES"
            self.debugDocumentVersioning = indexer.element!.attribute(by: "debugDocumentVersioning")!.text == "YES"
            self.debugServiceExtension = indexer.element!.attribute(by: "debugServiceExtension")!.text
            self.allowLocationSimulation = indexer.element!.attribute(by: "allowLocationSimulation")!.text == "YES"
            self.buildableProductRunnable = BuildableProductRunnable(indexer: indexer["BuildableProductRunnable"])
        }
    }
    
    public struct ProfileAction {
        public let buildableReference: BuildableReference
        public let buildconfiguration: String
        
        public init(buildableReference: BuildableReference,
                    buildConfiguration: String) {
            self.buildableReference = buildableReference
            self.buildconfiguration = buildConfiguration
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
        
        public init(indexer: XMLIndexer) {
            self.buildConfiguration = indexer.element!.attribute(by: "buildConfiguration")!.text
            self.selectedDebuggerIdentifier = indexer.element!.attribute(by: "selectedDebuggerIdentifier")!.text
            self.shouldUseLaunchSchemeArgsEnv = indexer.element!.attribute(by: "shouldUseLaunchSchemeArgsEnv")!.text == "YES"
            self.testables = indexer["Testables"]["TestableReference"]
                .all
                .map(TestableReference.init)
            self.macroExpansion = BuildableReference(indexer: indexer["MacroExpansion"]["BuildableReference"])
        }

    }
    
    public struct AnalyzeAction {
        public let buildConfiguration: String
        public init(buildConfiguration: String) {
            self.buildConfiguration = buildConfiguration
        }
        public init(indexer: XMLIndexer) {
            self.buildConfiguration = indexer.element!.attribute(by: "buildConfiguration")!.text
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
        public init(indexer: XMLIndexer) {
            self.buildConfiguration = indexer.element!.attribute(by: "buildConfiguration")!.text
            self.revealArchiveInOrganizer = indexer.element!.attribute(by: "revealArchiveInOrganizer")!.text == "YES"
            self.customArchiveName = indexer.element!.attribute(by: "customArchiveName")?.text
        }
    }
    
    // MARK: - Properties
    
    public let buildAction: BuildAction?
    public let testAction: TestAction?
    public let launchAction: LaunchAction?
//    public let profileAction: ProfileAction?
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
        let xml = SWXMLHash.parse(data)
        let scheme = xml["Scheme"]
        lastUpgradeVersion = scheme.element?.attribute(by: "LastUpgradeVersion")?.text
        version = scheme.element?.attribute(by: "version")?.text
        buildAction = BuildAction(indexer: scheme["BuildAction"])
        testAction = TestAction(indexer: scheme["TestAction"])
        launchAction = LaunchAction(indexer: scheme["LaunchAction"])
        analyzeAction = AnalyzeAction(indexer: scheme["AnalyzeAction"])
        archiveAction = ArchiveAction(indexer: scheme["ArchiveAction"])

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
//        self.profileAction = profileAction
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
