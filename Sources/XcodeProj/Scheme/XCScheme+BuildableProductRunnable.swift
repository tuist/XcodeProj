import AEXML
import Foundation

public extension XCScheme {
    final class BuildableProductRunnable: Runnable {
        // MARK: - XML

        override func xmlElement() -> AEXMLElement {
            let element = super.xmlElement()
            element.name = "BuildableProductRunnable"
            return element
        }
    }
}
