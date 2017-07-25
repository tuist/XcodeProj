import Foundation
import PathKit
import PathKit
import AEXML
import xcodeprojprotocols
import xcodeprojextensions

// swiftlint:disable:next type_body_length
public struct XCScheme {
    
    // MARK: - BuildableReference
    
    public struct BuildableReference {
        public let referencedContainer: String
        public let blueprintIdentifier: String
        public let buildableName: String
        public let buildableIdentifier: String
        public let blueprintName: String
             blueprintIdentifier: String,
             buildableName: String,
             buildableIdentifier: String,
             blueprintName: String) {

        public init(referencedContainer: String,
            self.referencedContainer = referencedContainer
            self.blueprintIdentifier = blueprintIdentifier
            self.buildableName = buildableName
            self.buildableIdentifier = buildableIdentifier
            self.blueprintName = blueprintName
        }

        public init(element: AEXMLElement) throws {
            guard let buildableIdentifier = element.attributes["BuildableIdentifier"] else {
                throw XCSchemeError.missing(property: "BuildableIdentifier")
            }
            guard let blueprintIdentifier = element.attributes["BlueprintIdentifier"] else {
                throw XCSchemeError.missing(property: "BlueprintIdentifier")
            }
            guard let buildableName = element.attributes["BuildableName"] else {
                throw XCSchemeError.missing(property: "BuildableName")
            }
            guard let blueprintName = element.attributes["BlueprintName"] else {
                throw XCSchemeError.missing(property: "BlueprintName")
            }
            guard let referencedContainer = element.attributes["ReferencedContainer"] else {
                throw XCSchemeError.missing(property: "ReferencedContainer")
            }
            self.buildableIdentifier = buildableIdentifier
            self.blueprintIdentifier = blueprintIdentifier
            self.buildableName = buildableName
            self.blueprintName = blueprintName
            self.referencedContainer = referencedContainer
        }

        public func xmlElement() -> AEXMLElement {
            return AEXMLElement(name: "BuildableReference",
                                value: nil,
                                attributes: ["BuildableIdentifier": buildableIdentifier,
                                             "BlueprintIdentifier": blueprintIdentifier,
                                             "BuildableName": buildableName,
                                             "BlueprintName": blueprintName,
                                             "ReferencedContainer": referencedContainer])
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
        public init(element: AEXMLElement) throws {
            self.skipped = element.attributes["skipped"] == "YES"
            self.buildableReference = try BuildableReference(element: element["BuildableReference"])
        }
        public func xmlElement() -> AEXMLElement {
            let element = AEXMLElement(name: "TestableReference",
                                       value: nil,
                                       attributes: ["skipped": skipped.xmlString])
            element.addChild(buildableReference.xmlElement())
            return element
        }
    }
    
    public struct LocationScenarioReference {
        public let identifier: String
        public let referenceType: String
        public init(identifier: String, referenceType: String) {
            self.identifier = identifier
            self.referenceType = referenceType
        }
        public init(element: AEXMLElement) throws {
            self.identifier = element.attributes["identifier"]!
            self.referenceType = element.attributes["referenceType"]!
        }
        public func xmlElement() -> AEXMLElement {
            return AEXMLElement(name: "LocationScenarioReference",
                                value: nil,
                                attributes: ["identifier": identifier,
                                             "referenceType": referenceType])
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
        public init(element: AEXMLElement) throws {
            self.runnableDebuggingMode = element.attributes["runnableDebuggingMode"]!
            self.buildableReference = try BuildableReference(element:  element["BuildableReference"])
        }
        public func xmlElement() -> AEXMLElement {
            let element = AEXMLElement(name: "BuildableProductRunnable",
                                       value: nil,
                                       attributes: ["runnableDebuggingMode": runnableDebuggingMode])
            element.addChild(buildableReference.xmlElement())
            return element
        }
    }
    
    // MARK: - Build Action
    
    public struct BuildAction {
        
        public struct Entry {
            
            public enum BuildFor {
                case running, testing, profiling, archiving, analyzing
                public static var `default`: [BuildFor] = [.running, .testing, .archiving, .analyzing]
                public static var indexing: [BuildFor] = [.testing, .analyzing, .archiving]
                public static var testOnly: [BuildFor] = [.testing, .analyzing]
            }
            
            public let buildableReference: BuildableReference
            public let buildFor: [BuildFor]

            public init(buildableReference: BuildableReference,
                        buildFor: [BuildFor]) {
                self.buildableReference = buildableReference
                self.buildFor = buildFor
            }
            public init(element: AEXMLElement) throws {
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
                self.buildableReference = try BuildableReference(element: element["BuildableReference"])
            }
            public func xmlElement() -> AEXMLElement {
                var attributes: [String: String] = [:]
                attributes["buildForTesting"] = buildFor.contains(.testing) ? "YES" : "NO"
                attributes["buildForRunning"] = buildFor.contains(.running) ? "YES" : "NO"
                attributes["buildForProfiling"] = buildFor.contains(.profiling) ? "YES" : "NO"
                attributes["buildForArchiving"] = buildFor.contains(.archiving) ? "YES" : "NO"
                attributes["buildForAnalyzing"] = buildFor.contains(.analyzing) ? "YES" : "NO"
                let element = AEXMLElement(name: "BuildActionEntry",
                                           value: nil,
                                           attributes: attributes)
                element.addChild(buildableReference.xmlElement())
                return element
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
        
        public init(element: AEXMLElement) throws {
            parallelizeBuild = element.attributes["parallelizeBuildables"]! == "YES"
            buildImplicitDependencies = element.attributes["buildImplicitDependencies"] == "YES"
            self.buildActionEntries = try element["BuildActionEntries"]["BuildActionEntry"]
                .all?
                .map(Entry.init) ?? []
        }
        
        public func xmlElement() -> AEXMLElement {
            let element = AEXMLElement(name: "BuildAction",
                                       value: nil,
                                       attributes: ["parallelizeBuildables": parallelizeBuild.xmlString,
                                                    "buildImplicitDependencies": buildImplicitDependencies.xmlString])
            let entries = element.addChild(name: "BuildActionEntries")
            buildActionEntries.forEach { (entry) in
                entries.addChild(entry.xmlElement())
            }
            return element
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
        
        public init(element: AEXMLElement) throws {
            guard let buildConfiguration = element.attributes["buildConfiguration"] else {
                throw XCSchemeError.missing(property: "buildConfiguration")
            }
            guard let selectedDebuggerIdentifier = element.attributes["selectedDebuggerIdentifier"] else {
                throw XCSchemeError.missing(property: "selectedDebuggerIdentifier")
            }
            guard let selectedLauncherIdentifier = element.attributes["selectedLauncherIdentifier"] else {
                throw XCSchemeError.missing(property: "selectedLauncherIdentifier")
            }
            guard let launchStyle = element.attributes["launchStyle"] else {
                throw XCSchemeError.missing(property: "launchStyle")
            }
            guard let debugServiceExtension = element.attributes["debugServiceExtension"] else {
                throw XCSchemeError.missing(property: "debugServiceExtension")
            }
            self.buildConfiguration = buildConfiguration
            self.selectedDebuggerIdentifier = selectedDebuggerIdentifier
            self.selectedLauncherIdentifier = selectedLauncherIdentifier
            self.launchStyle = Style(rawValue: launchStyle) ?? .auto
            self.useCustomWorkingDirectory = element.attributes["useCustomWorkingDirectory"] == "YES"
            self.ignoresPersistentStateOnLaunch = element.attributes["ignoresPersistentStateOnLaunch"] == "YES"
            self.debugDocumentVersioning = element.attributes["debugDocumentVersioning"] == "YES"
            self.debugServiceExtension = debugServiceExtension
            self.allowLocationSimulation = element.attributes["allowLocationSimulation"] == "YES"
            self.buildableProductRunnable = try BuildableProductRunnable(element:  element["BuildableProductRunnable"])
            if element["LocationScenarioReference"].all?.first != nil {
                self.locationScenarioReference = try LocationScenarioReference(element: element["LocationScenarioReference"])
            } else {
                self.locationScenarioReference = nil
            }
        }
        public func xmlElement() -> AEXMLElement {
            let element = AEXMLElement(name: "LaunchAction",
                                       value: nil,
                                       attributes: ["buildConfiguration": buildConfiguration,
                                                    "selectedDebuggerIdentifier": selectedDebuggerIdentifier,
                                                    "selectedLauncherIdentifier": selectedLauncherIdentifier,
                                                    "launchStyle": launchStyle.rawValue,
                                                    "useCustomWorkingDirectory": useCustomWorkingDirectory.xmlString,
                                                    "ignoresPersistentStateOnLaunch": ignoresPersistentStateOnLaunch.xmlString,
                                                    "debugDocumentVersioning": debugDocumentVersioning.xmlString,
                                                    "debugServiceExtension": debugServiceExtension,
                                                    "allowLocationSimulation": allowLocationSimulation.xmlString])
            element.addChild(buildableProductRunnable.xmlElement())
            if let locationScenarioReference = locationScenarioReference {
                element.addChild(locationScenarioReference.xmlElement())
            }
            return element
        }
    }
    
    public struct ProfileAction {
        public let buildableProductRunnable: BuildableProductRunnable
        public let buildConfiguration: String
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
            self.buildConfiguration = buildConfiguration
            self.shouldUseLaunchSchemeArgsEnv = shouldUseLaunchSchemeArgsEnv
            self.savedToolIdentifier = savedToolIdentifier
            self.useCustomWorkingDirectory = useCustomWorkingDirectory
            self.debugDocumentVersioning = debugDocumentVersioning
        }
        public init(element: AEXMLElement) throws {
            guard let buildConfiguration = element.attributes["buildConfiguration"] else {
                throw XCSchemeError.missing(property: "buildConfiguration")
            }
            guard let savedToolIdentifier = element.attributes["savedToolIdentifier"] else {
                throw XCSchemeError.missing(property: "savedToolIdentifier")
            }
            self.buildConfiguration = buildConfiguration
            self.shouldUseLaunchSchemeArgsEnv = element.attributes["shouldUseLaunchSchemeArgsEnv"] == "YES"
            self.savedToolIdentifier = savedToolIdentifier
            self.useCustomWorkingDirectory = element.attributes["useCustomWorkingDirectory"] == "YES"
            self.debugDocumentVersioning = element.attributes["debugDocumentVersioning"] == "YES"
            self.buildableProductRunnable = try BuildableProductRunnable(element: element["BuildableProductRunnable"])
        }
        public func xmlElement() -> AEXMLElement {
            let element = AEXMLElement(name: "ProfileAction",
                                       value: nil,
                                       attributes: ["buildConfiguration": buildConfiguration,
                                                    "shouldUseLaunchSchemeArgsEnv": shouldUseLaunchSchemeArgsEnv.xmlString,
                                                    "savedToolIdentifier": savedToolIdentifier,
                                                    "useCustomWorkingDirectory": useCustomWorkingDirectory.xmlString,
                                                    "debugDocumentVersioning": debugDocumentVersioning.xmlString])
            element.addChild(buildableProductRunnable.xmlElement())
            return element
        }
    }
    
    public struct TestAction {
        public let testables: [TestableReference]
        public let buildConfiguration: String
        public let selectedDebuggerIdentifier: String
        public let selectedLauncherIdentifier: String
        public let shouldUseLaunchSchemeArgsEnv: Bool
        public let macroExpansion: BuildableReference
        public init(buildConfiguration: String,
                    selectedDebuggerIdentifier: String,
                    selectedLauncherIdentifier: String,
                    shouldUseLaunchSchemeArgsEnv: Bool,
                    macroExpansion: BuildableReference,
                    testables: [TestableReference] = []) {
            self.buildConfiguration = buildConfiguration
            self.selectedDebuggerIdentifier = selectedDebuggerIdentifier
            self.selectedLauncherIdentifier = selectedLauncherIdentifier
            self.shouldUseLaunchSchemeArgsEnv = shouldUseLaunchSchemeArgsEnv
            self.testables = testables
            self.macroExpansion = macroExpansion
        }
        public init(element: AEXMLElement) throws {
            guard let buildConfiguration = element.attributes["buildConfiguration"] else {
                throw XCSchemeError.missing(property: "buildConfiguration")
            }
            guard let selectedDebuggerIdentifier = element.attributes["selectedDebuggerIdentifier"] else {
                throw XCSchemeError.missing(property: "selectedDebuggerIdentifier")
            }
            guard let selectedLauncherIdentifier = element.attributes["selectedLauncherIdentifier"] else {
                throw XCSchemeError.missing(property: "selectedLauncherIdentifier")
            }
            self.buildConfiguration = buildConfiguration
            self.selectedDebuggerIdentifier = selectedDebuggerIdentifier
            self.selectedLauncherIdentifier = selectedLauncherIdentifier
            self.shouldUseLaunchSchemeArgsEnv = element.attributes["shouldUseLaunchSchemeArgsEnv"] == "YES"
            self.testables = try element["Testables"]["TestableReference"]
                .all?
                .map(TestableReference.init) ?? []
            self.macroExpansion = try BuildableReference(element: element["MacroExpansion"]["BuildableReference"])
        }
        public func xmlElement() -> AEXMLElement {
            var attributes: [String: String] = [:]
            attributes["buildConfiguration"] = buildConfiguration
            attributes["selectedDebuggerIdentifier"] = selectedDebuggerIdentifier
            attributes["selectedLauncherIdentifier"] = selectedLauncherIdentifier
            attributes["shouldUseLaunchSchemeArgsEnv"] = shouldUseLaunchSchemeArgsEnv.xmlString
            let element = AEXMLElement(name: "TestAction", value: nil, attributes: attributes)
            let testablesElement = element.addChild(name: "Testables")
            testables.forEach { (testable) in
                testablesElement.addChild(testable.xmlElement())
            }
            let macro = element.addChild(name: "MacroExpansion")
            macro.addChild(macroExpansion.xmlElement())
            return element
        }
    }
    
    public struct AnalyzeAction {
        public let buildConfiguration: String
        public init(buildConfiguration: String) {
            self.buildConfiguration = buildConfiguration
        }
        public init(element: AEXMLElement) throws {
            guard let buildConfiguration = element.attributes["buildConfiguration"] else {
                throw XCSchemeError.missing(property: "buildConfiguration")
            }
            self.buildConfiguration = buildConfiguration
        }
        public func xmlElement() -> AEXMLElement {
            var attributes: [String: String] = [:]
            attributes["buildConfiguration"] = buildConfiguration
            return AEXMLElement(name: "AnalyzeAction", value: nil, attributes: attributes)
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
        public init(element: AEXMLElement) throws {
            guard let buildConfiguration = element.attributes["buildConfiguration"] else {
                throw XCSchemeError.missing(property: "buildConfiguration")
            }
            guard let customArchiveName = element.attributes["customArchiveName"] else {
                throw XCSchemeError.missing(property: "customArchiveName")
            }
            self.buildConfiguration = buildConfiguration
            self.revealArchiveInOrganizer = element.attributes["revealArchiveInOrganizer"] == "YES"
            self.customArchiveName = customArchiveName
        }
        public func xmlElement() -> AEXMLElement {
            var attributes: [String: String] = [:]
            attributes["buildConfiguration"] = buildConfiguration
            attributes["customArchiveName"] = customArchiveName
            attributes["revealArchiveInOrganizer"] = revealArchiveInOrganizer.xmlString
            return AEXMLElement(name: "ArchiveAction", value: nil, attributes: attributes)
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
    public let name: String
    
    // MARK: - Init
    
    /// Initializes the scheme reading the content from the disk.
    ///
    /// - Parameters:
    ///   - path: scheme path.
    public init(path: Path) throws {
        if !path.exists {
            throw XCSchemeError.notFound(path: path)
        }
        name = path.lastComponent
        let document = try AEXMLDocument(xml: try path.read())
        let scheme = document["Scheme"]
        lastUpgradeVersion = scheme.attributes["LastUpgradeVersion"]
        version = scheme.attributes["version"]
        buildAction = try BuildAction(element: scheme["BuildAction"])
        testAction = try TestAction(element: scheme["TestAction"])
        launchAction = try LaunchAction(element: scheme["LaunchAction"])
        analyzeAction = try AnalyzeAction(element: scheme["AnalyzeAction"])
        archiveAction = try ArchiveAction(element: scheme["ArchiveAction"])
        profileAction = try ProfileAction(element: scheme["ProfileAction"])
    }
    
    public init(name: String,
                lastUpgradeVersion: String?,
                version: String?,
                buildAction: BuildAction? = nil,
                testAction: TestAction? = nil,
                launchAction: LaunchAction? = nil,
                profileAction: ProfileAction? = nil,
                analyzeAction: AnalyzeAction? = nil,
                archiveAction: ArchiveAction? = nil) {
        self.name = name
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

// MARK: - XCScheme Extension (Writable)

extension XCScheme: Writable {
    
    public func write(path: Path, override: Bool) throws {
        let document = AEXMLDocument()
        var schemeAttributes: [String: String] = [:]
        schemeAttributes["LastUpgradeVersion"] = lastUpgradeVersion
        schemeAttributes["version"] = version
        let scheme = document.addChild(name: "Scheme", value: nil, attributes: schemeAttributes)
        if let analyzeAction = analyzeAction {
            scheme.addChild(analyzeAction.xmlElement())
        }
        if let archiveAction = archiveAction {
            scheme.addChild(archiveAction.xmlElement())
        }
        if let testAction = testAction {
            scheme.addChild(testAction.xmlElement())
        }
        if let profileAction = profileAction {
            scheme.addChild(profileAction.xmlElement())
        }
        if let buildAction = buildAction {
            scheme.addChild(buildAction.xmlElement())
        }
        if let launchAction = launchAction {
            scheme.addChild(launchAction.xmlElement())
        }
        if override && path.exists {
            try path.delete()
        }
        try path.write(document.xml)
    }
    
}

// MARK: - XCScheme Errors.

/// XCScheme Errors.
///
/// - notFound: returned when the .xcscheme cannot be found.
/// - missing: returned when there's a property missing in the .xcscheme.
public enum XCSchemeError: Error, CustomStringConvertible {
    case notFound(path: Path)
    case missing(property: String)
    
    public var description: String {
        switch self {
        case .notFound(let path):
            return ".xcscheme couldn't be found at path \(path)"
        case .missing(let property):
            return "Property \(property) missing"
        }
    }
}
