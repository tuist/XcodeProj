import AEXML
import Foundation

extension XCScheme {
    public final class RemoteRunnable: Runnable {
        // MARK: - Attributes

        public var bundleIdentifier: String
        public var remotePath: String?

        // MARK: - Init

        public init(buildableReference: BuildableReference,
                    bundleIdentifier: String,
                    runnableDebuggingMode: String = "0",
                    remotePath: String? = nil) {
            self.bundleIdentifier = bundleIdentifier
            self.remotePath = remotePath
            super.init(buildableReference: buildableReference,
                       runnableDebuggingMode: runnableDebuggingMode)
        }

        override init(element: AEXMLElement) throws {
            bundleIdentifier = element.attributes["BundleIdentifier"] ?? ""
            remotePath = element.attributes["RemotePath"]
            try super.init(element: element)
        }

        // MARK: - XML

        override func xmlElement() -> AEXMLElement {
            let element = super.xmlElement()
            element.name = "RemoteRunnable"
            element.attributes["BundleIdentifier"] = bundleIdentifier
            element.attributes["RemotePath"] = remotePath
            return element
        }

        // MARK: - Equatable

        override func isEqual(to rhs: Any?) -> Bool {
            guard let rhs = rhs as? RemoteRunnable else {
                return false
            }
            return isEqual(to: rhs)
        }
    }
}
