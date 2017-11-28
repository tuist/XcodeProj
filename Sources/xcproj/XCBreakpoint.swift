import Foundation
import PathKit
import PathKit
import AEXML

// swiftlint:disable:next type_body_length
final public class XCBreakpoint {

    // MARK: - BreakpointLocationProxy

    final public class BreakpointLocationProxy {
        public var runnableDebuggingMode: String
        public init(runnableDebuggingMode: String = "0") {
            self.runnableDebuggingMode = runnableDebuggingMode
        }
        init(element: AEXMLElement) throws {
            self.runnableDebuggingMode = element.attributes["runnableDebuggingMode"] ?? "0"
        }
        fileprivate func xmlElement() -> AEXMLElement {
            let element = AEXMLElement(name: "BuildableProductRunnable",
                                       value: nil,
                                       attributes: ["runnableDebuggingMode": runnableDebuggingMode])
            return element
        }
    }

    // MARK: - BreakpointActionProxy

    final public class BreakpointActionProxy {
        public struct CommandLineArgument {
            public let name: String
            public let enabled: Bool

            public init(name: String, enabled: Bool) {
                self.name = name
                self.enabled = enabled
            }

            fileprivate func xmlElement() -> AEXMLElement {
                return AEXMLElement(name: "CommandLineArgument",
                                    value: nil,
                                    attributes: ["argument": name, "isEnabled": enabled ? "YES" : "NO" ])
            }
        }
        public let arguments: [CommandLineArgument]

        public init(arguments args:[CommandLineArgument]) {
            self.arguments = args
        }

        init(element: AEXMLElement) throws {
            self.arguments = try element.children.map { elt in
                guard let argName = elt.attributes["argument"] else {
                    throw XCBreakpointError.missing(property: "argument")
                }
                guard let argEnabledRaw = elt.attributes["isEnabled"] else {
                    throw XCBreakpointError.missing(property: "isEnabled")
                }
                return CommandLineArgument(name: argName, enabled: argEnabledRaw == "YES")
            }
        }

        fileprivate func xmlElement() -> AEXMLElement {
            let element = AEXMLElement(name: "CommandLineArguments",
                                       value: nil)
            arguments.forEach { arg in
                element.addChild(arg.xmlElement())
            }
            return element
        }
    }

    // MARK: - BreakpointProxy

    final public class BreakpointProxy {

        final public class BreakpointContent {

            public var buildFor: [String]

            public init(buildFor: [String]) {
                self.buildFor = buildFor
            }

            init(element: AEXMLElement) throws {
                var buildFor: [String] = []
                if element.attributes["buildForTesting"] == "YES" {
                    buildFor.append(".testing")
                }
                if element.attributes["buildForRunning"] == "YES" {
                    buildFor.append(".testing")
                }
                if element.attributes["buildForProfiling"] == "YES" {
                    buildFor.append(".testing")
                }
                if element.attributes["buildForArchiving"] == "YES" {
                    buildFor.append(".testing")
                }
                if element.attributes["buildForAnalyzing"] == "YES" {
                    buildFor.append(".testing")
                }
                self.buildFor = buildFor
            }
            fileprivate func xmlElement() -> AEXMLElement {
                var attributes: [String: String] = [:]
                attributes["buildForTesting"] = buildFor.contains(".testing") ? "YES" : "NO"
                attributes["buildForRunning"] = buildFor.contains(".testing") ? "YES" : "NO"
                attributes["buildForProfiling"] = buildFor.contains(".testing") ? "YES" : "NO"
                attributes["buildForArchiving"] = buildFor.contains(".testing") ? "YES" : "NO"
                attributes["buildForAnalyzing"] = buildFor.contains(".testing") ? "YES" : "NO"
                let element = AEXMLElement(name: "BuildActionEntry",
                                           value: nil,
                                           attributes: attributes)
                return element
            }
        }

        // MARK: - BreakpointExtensionID

        public enum BreakpointExtensionID: String {
            case file = "Xcode.Breakpoint.FileBreakpoint"
            case exception = "Xcode.Breakpoint.ExceptionBreakpoint"
            case swiftError = "Xcode.Breakpoint.SwiftErrorBreakpoint"
            case openGLError = "Xcode.Breakpoint.OpenGLErrorBreakpoint"
            case symbolic = "Xcode.Breakpoint.SymbolicBreakpoint"
            case ideConstraintError = "Xcode.Breakpoint.IDEConstraintErrorBreakpoint"
            case ideTestFailure = "Xcode.Breakpoint.IDETestFailureBreakpoint"
        }

        public var breakpointExtensionID: BreakpointExtensionID
        public var breakpointContent: BreakpointContent

        public init(breakpointExtensionID: BreakpointExtensionID,
                    breakpointContent: BreakpointContent) {
            self.breakpointExtensionID = breakpointExtensionID
            self.breakpointContent = breakpointContent
        }

        init(element: AEXMLElement) throws {
            guard let breakpointExtensionIDString = element.attributes["BreakpointExtensionID"], let breakpointExtensionID = BreakpointExtensionID(rawValue: breakpointExtensionIDString) else {
                throw XCBreakpointError.missing(property: "BreakpointExtensionID")
            }
            self.breakpointExtensionID = breakpointExtensionID
            breakpointContent = try BreakpointContent(element: element["BreakpointContent"])
        }

        fileprivate func xmlElement() -> AEXMLElement {
            let element = AEXMLElement(name: "BreakpointProxy",
                                       value: nil,
                                       attributes: ["BreakpointExtensionID": breakpointExtensionID.rawValue])
            element.addChild(breakpointContent.xmlElement())
            return element
        }
    }

    // MARK: - Properties

    public var breakpoints: [BreakpointProxy]
    public var type: String?
    public var version: String?

    // MARK: - Init

    /// Initializes the breakpoints reading the content from the disk.
    ///
    /// - Parameters:
    ///   - path: breakpoints path.
    public init(path: Path) throws {
        if !path.exists {
            throw XCBreakpointError.notFound(path: path)
        }
        let document = try AEXMLDocument(xml: try path.read())
        let bucket = document["Bucket"]
        type = bucket.attributes["type"]
        version = bucket.attributes["version"]
        breakpoints = try bucket["Breakpoints"]["BreakpointProxy"]
            .all?
            .map(BreakpointProxy.init) ?? []
    }

    public init(type: String? = nil,
                version: String? = nil,
                breakpoints: [BreakpointProxy] = []) {
        self.type = type
        self.version = version
        self.breakpoints = breakpoints
    }

    public func add(breakpointProxy: BreakpointProxy) -> XCBreakpoint {
        var breakpoints = self.breakpoints
        breakpoints.append(breakpointProxy)
        return XCBreakpoint(type: type, version: version, breakpoints: breakpoints)
    }

}

// MARK: - XCBreakpoint Extension (Writable)

extension XCBreakpoint: Writable {

    public func write(path: Path, override: Bool) throws {
        let document = AEXMLDocument()
        var schemeAttributes: [String: String] = [:]
        schemeAttributes["type"] = type
        schemeAttributes["version"] = version
        let bucket = document.addChild(name: "Bucket", value: nil, attributes: schemeAttributes)
        let breakpoints = AEXMLElement(name: "Breakpoints", value: nil, attributes: [:])
        self.breakpoints.map({ $0.xmlElement() }).forEach({ breakpoints.addChild($0) })
        bucket.addChild(breakpoints)
        if override && path.exists {
            try path.delete()
        }
        try path.write(document.xml)
    }

}

// MARK: - XCBreakpoint Errors.

/// XCBreakpoint Errors.
///
/// - notFound: returned when the Breakpoints_v2.xcbkptlist cannot be found.
/// - missing: returned when there's a property missing in the Breakpoints_v2.xcbkptlist.
public enum XCBreakpointError: Error, CustomStringConvertible {
    case notFound(path: Path)
    case missing(property: String)

    public var description: String {
        switch self {
        case .notFound(let path):
            return "Breakpoints_v2.xcbkptlist couldn't be found at path \(path)"
        case .missing(let property):
            return "Property \(property) missing"
        }
    }
}
