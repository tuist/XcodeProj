import AEXML
import Foundation
import PathKit

public extension XCScheme {
    class PathRunnable: Runnable {
        // MARK: - Attributes

        public var filePath: String

        // MARK: - Init

        public init(filePath: String,
                    runnableDebuggingMode: String = "0") {
            self.filePath = filePath
            super.init(buildableReference: nil,
                       runnableDebuggingMode: runnableDebuggingMode)
        }

        override init(element: AEXMLElement) throws {
            filePath = element.attributes["FilePath"] ?? ""
            try super.init(element: element)
        }

        // MARK: - XML

        override func xmlElement() -> AEXMLElement {
            let element = super.xmlElement()
            element.name = "PathRunnable"
            element.attributes["FilePath"] = filePath
            return element
        }

        // MARK: - Equatable

        override func isEqual(other: XCScheme.Runnable) -> Bool {
            guard let other = other as? PathRunnable else {
                return false
            }

            return super.isEqual(other: other) &&
                filePath == other.filePath
        }

        public static func == (lhs: PathRunnable, rhs: PathRunnable) -> Bool {
            lhs.isEqual(other: rhs) && rhs.isEqual(other: lhs)
        }
    }
}
