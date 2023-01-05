import AEXML
import Foundation
import PathKit

enum XCDebugger {
    /// Returns  debugger folder path relative to the given path.
    ///
    /// - Parameter path: parent folder of debugger folder (xcshareddata or xcuserdata)
    /// - Returns: debugger folder path relative to the given path.
    public static func path(_ path: Path) -> Path {
        path + "xcdebugger"
    }
}
