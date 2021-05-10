import AEXML
import Foundation

extension XCScheme {
    public final class BuildableReference: Equatable {
        // MARK: - Attributes

        public var referencedContainer: String

        private enum Blueprint: Equatable {
            case reference(PBXObjectReference)
            case string(String)

            var string: String {
                switch self {
                case let .reference(object): return object.value
                case let .string(string): return string
                }
            }
        }

        public func setBlueprint(_ object: PBXObject) {
            blueprint = .reference(object.reference)
        }

        private var blueprint: Blueprint?
        public var blueprintIdentifier: String? {
            blueprint?.string
        }

        public var buildableName: String
        public var buildableIdentifier: String
        public var blueprintName: String

        // MARK: - Init

        public init(referencedContainer: String,
                    blueprint: PBXObject?,
                    buildableName: String,
                    blueprintName: String,
                    buildableIdentifier: String = "primary") {
            self.referencedContainer = referencedContainer
            self.blueprint = blueprint.map { Blueprint.reference($0.reference) }
            self.buildableName = buildableName
            self.buildableIdentifier = buildableIdentifier
            self.blueprintName = blueprintName
        }

        public init(referencedContainer: String,
                    blueprintIdentifier: String?,
                    buildableName: String,
                    blueprintName: String,
                    buildableIdentifier: String = "primary") {
            self.referencedContainer = referencedContainer
            self.blueprint = blueprintIdentifier.map(Blueprint.string)
            self.buildableName = buildableName
            self.buildableIdentifier = buildableIdentifier
            self.blueprintName = blueprintName
        }

        // MARK: - XML

        init(element: AEXMLElement) throws {
            guard let buildableIdentifier = element.attributes["BuildableIdentifier"] else {
                throw XCSchemeError.missing(property: "BuildableIdentifier")
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
            let blueprintIdentifier = element.attributes["BlueprintIdentifier"]
            self.blueprint = blueprintIdentifier.map(Blueprint.string)
            self.buildableName = buildableName
            self.blueprintName = blueprintName
            self.referencedContainer = referencedContainer
        }

        func xmlElement() -> AEXMLElement {
            var attributes: [String: String] = [
                "BuildableIdentifier": buildableIdentifier,
                "BuildableName": buildableName,
                "BlueprintName": blueprintName,
                "ReferencedContainer": referencedContainer,
            ]
            if let blueprintIdentifier = blueprint?.string {
                attributes["BlueprintIdentifier"] = blueprintIdentifier
            }
            return AEXMLElement(name: "BuildableReference",
                                value: nil,
                                attributes: attributes)
        }

        // MARK: - Equatable

        public static func == (lhs: BuildableReference, rhs: BuildableReference) -> Bool {
            lhs.referencedContainer == rhs.referencedContainer &&
                lhs.blueprintIdentifier == rhs.blueprintIdentifier &&
                lhs.buildableName == rhs.buildableName &&
                lhs.blueprint == rhs.blueprint &&
                lhs.blueprintName == rhs.blueprintName
        }
    }
}
