import Foundation
import xcproj
import PathKit

extension String: Error {}

let arguments = CommandLine.arguments

if arguments.count != 2 {
    throw "Project path not passed (e.g. MyProject.xcodeproj)"
}

let projectPath = arguments[1]
let beforeRead: Date = Date()
print("> Reading project: \(projectPath)")
let project = try XcodeProj.init(path: Path(projectPath))
let afterRead: Date = Date()
print("> Project read in \(afterRead.timeIntervalSince(beforeRead)) seconds")
print("> Writing project")
let beforeWrite: Date = Date()
try project.write(path: Path(projectPath))
let afterWrite: Date = Date()
print("> Project written in \(afterWrite.timeIntervalSince(beforeWrite)) seconds")
