import Foundation
import os.signpost

/// OSLog wrapper that runs logging functions if logging is enabled through
/// environment variables and the feature is available in the system where
/// the user is using the project.
class OSLogger {
    /// Shared instance of OSLogger
    static var instance: OSLogger = OSLogger()

    /// Logs when the given closure starts and ends.
    ///
    /// - Parameters:
    ///   - category: Category of the code being logged. For example, if it's a function in PBXObjectReference, that can be the category.
    ///   - name: Name for the code being logged. If we are logging the time it takes to write a project, the name can be "Project Writing"
    ///   - arguments: Arguments to be passed to the function.
    ///   - closure: Piece of code that will be logged.
    /// - Throws: An error if the given closure throws.
    func log(category: String = #file, name: StaticString, _ arguments: CVarArg..., closure: () throws -> Void) throws {
        if !shouldLog {
            try closure()
            return
        }

        if #available(OSX 10.14, *) {
            let log: OSLog = OSLog.xcodeproj(category: category)
            let signpostID = OSSignpostID(log: log)
            os_signpost(.begin,
                        log: log,
                        name: name,
                        signpostID: signpostID,
                        "%{public}s",
                        arguments)
        }

        try closure()

        if #available(OSX 10.14, *) {
            let log: OSLog = OSLog.xcodeproj(category: category)
            let signpostID = OSSignpostID(log: log)
            os_signpost(.end,
                        log: log,
                        name: name,
                        signpostID: signpostID,
                        "%{public}s",
                        arguments)
        }
    }

    /// Logs when the given closure starts and ends.
    ///
    /// - Parameters:
    ///   - category: Category of the code being logged. For example, if it's a function in PBXObjectReference, that can be the category.
    ///   - name: Name for the code being logged. If we are logging the time it takes to write a project, the name can be "Project Writing"
    ///   - arguments: Arguments to be passed to the function.
    ///   - closure: Piece of code that will be logged.
    /// - Returns: The value returned by the closure.
    /// - Throws: An error if the given closure throws.
    func log<T>(category: String = #file, name: StaticString, _ arguments: CVarArg..., closure: () throws -> T) throws -> T {
        if !shouldLog {
            return try closure()
        }

        if #available(OSX 10.14, *) {
            let log: OSLog = OSLog.xcodeproj(category: category)
            let signpostID = OSSignpostID(log: log)
            os_signpost(.begin,
                        log: log,
                        name: name,
                        signpostID: signpostID,
                        "%{public}s",
                        arguments)
        }

        let result = try closure()

        if #available(OSX 10.14, *) {
            let log: OSLog = OSLog.xcodeproj(category: category)
            let signpostID = OSSignpostID(log: log)
            os_signpost(.end,
                        log: log,
                        name: name,
                        signpostID: signpostID,
                        "%{public}s",
                        arguments)
        }

        return result
    }

    /// Returns true if the XCODEPROJ_OSLOG environment variable is defined in the environment.
    lazy var shouldLog: Bool = {
        ProcessInfo.processInfo.environment["XCODEPROJ_OSLOG"] != nil
    }()
}
