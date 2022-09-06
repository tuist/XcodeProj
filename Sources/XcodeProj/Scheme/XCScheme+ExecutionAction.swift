import AEXML
import Foundation

extension XCScheme {
    public final class ExecutionAction: Equatable {
        private static let ActionType = "Xcode.IDEStandardExecutionActionsCore.ExecutionActionType.ShellScriptAction"

        // MARK: - Attributes

        public var title: String
        public var scriptText: String
        public var shellToInvoke: String?
        public var environmentBuildable: BuildableReference?

        // MARK: - Init

        public init(
            scriptText: String,
            title: String = "Run Script",
            shellToInvoke: String? = nil,
            environmentBuildable: BuildableReference? = nil
        ) {
            self.scriptText = scriptText
            self.title = title
            self.shellToInvoke = shellToInvoke
            self.environmentBuildable = environmentBuildable
        }

        init(element: AEXMLElement) throws {
            scriptText = element["ActionContent"].attributes["scriptText"] ?? ""
            title = element["ActionContent"].attributes["title"] ?? "Run Script"
            if let shellToInvoke = element["ActionContent"].attributes["shellToInvoke"] {
                self.shellToInvoke = shellToInvoke
            }
            environmentBuildable = try? BuildableReference(element: element["ActionContent"]["EnvironmentBuildable"]["BuildableReference"])
        }

        // MARK: - XML

        func xmlElement() -> AEXMLElement {
            let element = AEXMLElement(name: "ExecutionAction",
                                       value: nil,
                                       attributes: ["ActionType": ExecutionAction.ActionType])
            var attributes = [
                "title": title,
                "scriptText": scriptText,
            ]
            if let shellToInvoke = shellToInvoke {
                attributes["shellToInvoke"] = shellToInvoke
            }
            let content = AEXMLElement(name: "ActionContent",
                                       value: nil,
                                       attributes: attributes)
            element.addChild(content)
            if let environmentBuildable = environmentBuildable {
                let environment = content.addChild(name: "EnvironmentBuildable")
                environment.addChild(environmentBuildable.xmlElement())
            }
            return element
        }

        // MARK: - Equatable

        public static func == (lhs: ExecutionAction, rhs: ExecutionAction) -> Bool {
            lhs.title == rhs.title &&
                lhs.scriptText == rhs.scriptText &&
                lhs.environmentBuildable == rhs.environmentBuildable
        }
    }
}
