import AEXML
import Foundation
import PathKit

extension XCScheme {
    public final class ArchiveAction: SerialAction {
        // MARK: - Static

        private static let defaultBuildConfiguration = "Release"

        // MARK: - Attributes

        public var buildConfiguration: String
        public var revealArchiveInOrganizer: Bool
        public var customArchiveName: String?

        // MARK: - Init

        public init(buildConfiguration: String,
                    revealArchiveInOrganizer: Bool,
                    customArchiveName: String? = nil,
                    preActions: [ExecutionAction] = [],
                    postActions: [ExecutionAction] = []) {
            self.buildConfiguration = buildConfiguration
            self.revealArchiveInOrganizer = revealArchiveInOrganizer
            self.customArchiveName = customArchiveName
            super.init(preActions, postActions)
        }

        override init(element: AEXMLElement) throws {
            buildConfiguration = element.attributes["buildConfiguration"] ?? ArchiveAction.defaultBuildConfiguration
            revealArchiveInOrganizer = element.attributes["revealArchiveInOrganizer"].map { $0 == "YES" } ?? true
            customArchiveName = element.attributes["customArchiveName"]
            try super.init(element: element)
        }

        // MARK: - XML

        func xmlElement() -> AEXMLElement {
            var attributes: [String: String] = [:]
            attributes["buildConfiguration"] = buildConfiguration
            attributes["customArchiveName"] = customArchiveName
            attributes["revealArchiveInOrganizer"] = revealArchiveInOrganizer.xmlString
            let element = AEXMLElement(name: "ArchiveAction", value: nil, attributes: attributes)
            super.writeXML(parent: element)
            return element
        }

        // MARK: - Equatable


        static func == (lhs: ArchiveAction, rhs: ArchiveAction) -> Bool {
            return
                lhs.preActions == rhs.preActions &&
                rhs.postActions == rhs.postActions &&
                lhs.buildConfiguration == rhs.buildConfiguration &&
                lhs.revealArchiveInOrganizer == rhs.revealArchiveInOrganizer &&
                lhs.customArchiveName == rhs.customArchiveName
        }
    }
}
