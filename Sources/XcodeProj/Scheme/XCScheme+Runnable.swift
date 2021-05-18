// sourcery:file: skipEquality
import AEXML
import Foundation

extension XCScheme {
    public class Runnable: Equatable, AutoEquatable {
        // MARK: - Attributes

        public var runnableDebuggingMode: String
        public var buildableReference: BuildableReference

        // MARK: - Init

        public init(buildableReference: BuildableReference,
                    runnableDebuggingMode: String = "0") {
            self.buildableReference = buildableReference
            self.runnableDebuggingMode = runnableDebuggingMode
        }

        init(element: AEXMLElement) throws {
            runnableDebuggingMode = element.attributes["runnableDebuggingMode"] ?? "0"
            buildableReference = try BuildableReference(element: element["BuildableReference"])
        }

        // MARK: - XML

        func xmlElement() -> AEXMLElement {
            let element = AEXMLElement(name: "Runnable",
                                       value: nil,
                                       attributes: ["runnableDebuggingMode": runnableDebuggingMode])
            element.addChild(buildableReference.xmlElement())
            return element
        }

        // MARK: - Equatable

        func isEqual(to rhs: Any?) -> Bool {
            guard let rhs = rhs as? Runnable else { return false }
            return runnableDebuggingMode == rhs.runnableDebuggingMode &&
                buildableReference == rhs.buildableReference
        }

        public static func == (lhs: Runnable, rhs: Runnable) -> Bool {
            lhs.isEqual(to: rhs) && rhs.isEqual(to: lhs)
        }
    }
}
