import Foundation
import os.signpost

extension OSLog {
    @available(OSX 10.12, *)
    /// Returns an instance of OSLog with the default xcodeproj subsystem.
    ///
    /// - Parameter category: Category the OSLog should be initialized with.
    /// - Returns: Initialized OSLog.
    static func xcodeproj(category: String) -> OSLog {
        return OSLog(subsystem: "io.tuist.xcodeproj", category: category)
    }
}
