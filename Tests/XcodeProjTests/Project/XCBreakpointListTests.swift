import Foundation
import PathKit
import XcodeProj
import XCTest

final class XCBreakpointListIntegrationTests: XCTestCase {
    var subject: XCBreakpointList?

    override func setUp() {
        subject = try? XCBreakpointList(path: fixturePath())
    }

    func test_init_initializesTheBreakpointListCorrectly() {
        XCTAssertNotNil(subject)
        if let subject = subject {
            assert(breakpointList: subject)
        }
    }

    func test_write() {
        testWrite(from: fixturePath(),
                  initModel: { try? XCBreakpointList(path: $0) },
                  modify: { $0 },
                  assertion: { assert(breakpointList: $1) })
    }

    // MARK: - Private

    private func assert(breakpointList: XCBreakpointList) {
        XCTAssertEqual(breakpointList.version, "2.0")
        XCTAssertEqual(breakpointList.type, "4")

        // Swift error
        let swiftError = breakpointList.breakpoints[0]
        XCTAssertEqual(swiftError.breakpointExtensionID, .swiftError)
        let swiftErrorContent = swiftError.breakpointContent
        XCTAssertEqual(swiftErrorContent.enabled, true)
        XCTAssertEqual(swiftErrorContent.ignoreCount, "0")
        XCTAssertEqual(swiftErrorContent.continueAfterRunningActions, false)
        let swiftErrorSoundAction = swiftErrorContent.actions[0]
        XCTAssertEqual(swiftErrorSoundAction.actionExtensionID, .sound)
        let swiftErrorSoundActionContent = swiftErrorSoundAction.actionContent
        XCTAssertEqual(swiftErrorSoundActionContent.soundName, "Morse")

        // Exception
        let exception = breakpointList.breakpoints[1]
        XCTAssertEqual(exception.breakpointExtensionID, .exception)
        let exceptionContent = exception.breakpointContent
        XCTAssertEqual(exceptionContent.enabled, false)
        XCTAssertEqual(exceptionContent.ignoreCount, "1")
        XCTAssertEqual(exceptionContent.continueAfterRunningActions, true)
        let exceptionContentLogAction = exceptionContent.actions[0]
        XCTAssertEqual(exceptionContentLogAction.actionExtensionID, .log)
        let exceptionLogActionContent = exceptionContentLogAction.actionContent
        XCTAssertEqual(exceptionLogActionContent.message, "Log")
        XCTAssertEqual(exceptionLogActionContent.conveyanceType, "0")

        // Symbolic
        let symbolic = breakpointList.breakpoints[2]
        XCTAssertEqual(symbolic.breakpointExtensionID, .symbolic)
        let symbolicContent = symbolic.breakpointContent
        XCTAssertEqual(symbolicContent.enabled, true)
        XCTAssertEqual(symbolicContent.ignoreCount, "2")
        XCTAssertEqual(symbolicContent.continueAfterRunningActions, false)
        let symbolicShellCommandAction = symbolicContent.actions[0]
        XCTAssertEqual(symbolicShellCommandAction.actionExtensionID, .shellCommand)
        let symbolicShellCommandActionContent = symbolicShellCommandAction.actionContent
        XCTAssertEqual(symbolicShellCommandActionContent.waitUntilDone, true)

        // OpenGL error
        let openGLError = breakpointList.breakpoints[3]
        XCTAssertEqual(openGLError.breakpointExtensionID, .openGLError)
        let openGLErrorContent = openGLError.breakpointContent
        XCTAssertEqual(openGLErrorContent.enabled, false)
        XCTAssertEqual(openGLErrorContent.ignoreCount, "3")
        XCTAssertEqual(openGLErrorContent.continueAfterRunningActions, false)
        let openGLErrorDebuggerCommandAction = openGLErrorContent.actions[0]
        XCTAssertEqual(openGLErrorDebuggerCommandAction.actionExtensionID, .debuggerCommand)
        let openGLErrorDebuggerCommandActionContent = openGLErrorDebuggerCommandAction.actionContent
        XCTAssertEqual(openGLErrorDebuggerCommandActionContent.consoleCommand, "po nil")
        let openGLErrorAction = openGLErrorContent.actions[1]
        XCTAssertEqual(openGLErrorAction.actionExtensionID, .openGLError)
        XCTAssertNotNil(openGLErrorAction.actionContent)

        // IDE constraint error
        let ideConstraintError = breakpointList.breakpoints[4]
        XCTAssertEqual(ideConstraintError.breakpointExtensionID, .ideConstraintError)
        let ideConstraintErrorContent = ideConstraintError.breakpointContent
        XCTAssertEqual(ideConstraintErrorContent.enabled, true)
        XCTAssertEqual(ideConstraintErrorContent.ignoreCount, "4")
        XCTAssertEqual(ideConstraintErrorContent.continueAfterRunningActions, true)
        XCTAssertEqual(ideConstraintErrorContent.breakpointStackSelectionBehavior, "1")
        let ideConstraintErrorGraphicsTraceAction = ideConstraintErrorContent.actions[0]
        XCTAssertEqual(ideConstraintErrorGraphicsTraceAction.actionExtensionID, .graphicsTrace)
        XCTAssertNotNil(ideConstraintErrorGraphicsTraceAction.actionContent)

        // IDE test failure
        let ideTestFailure = breakpointList.breakpoints[5]
        XCTAssertEqual(ideTestFailure.breakpointExtensionID, .ideTestFailure)
        let ideTestFailureContent = ideTestFailure.breakpointContent
        XCTAssertEqual(ideTestFailureContent.enabled, true)
        XCTAssertEqual(ideTestFailureContent.ignoreCount, "0")
        XCTAssertEqual(ideTestFailureContent.continueAfterRunningActions, false)
        let ideTestFailureAppleScriptAction = ideTestFailureContent.actions[0]
        XCTAssertEqual(ideTestFailureAppleScriptAction.actionExtensionID, .appleScript)
        XCTAssertNotNil(ideTestFailureAppleScriptAction.actionContent)
    }

    private func fixturePath() -> Path {
        fixturesPath() + "iOS/Project.xcodeproj/xcshareddata/xcdebugger/Breakpoints_v2.xcbkptlist"
    }
}
