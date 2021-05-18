import AEXML
import Foundation

extension XCScheme {
    public final class BuildableProductRunnable: Runnable {
        // MARK: - XML

        override func xmlElement() -> AEXMLElement {
            let element = super.xmlElement()
            element.name = "BuildableProductRunnable"
            return element
        }

        override func isEqual(to rhs: Any?) -> Bool {
            guard let rhs = rhs as? BuildableProductRunnable else {
                return false
            }
            return isEqual(to: rhs)
        }
    }
}
