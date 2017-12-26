import Foundation
import SakefileDescription
import SakefileUtils

enum Task: String, CustomStringConvertible {
    case continuousIntegration = "ci"
    case deployToIntegration = "deploy_to_integration"
    case generateCarthageProject = "generate_carthage_project"
    case generateDocs = "generate_docs"
    case buildCarthage = "build_carthage"
    case testUnit = "test_unit"
    case testIntegration = "test_integration"
    case testAll = "test_all"
    case release = "release"
    var description: String {
        switch self {
        case .continuousIntegration:
            return "Runs all the tasks that need to be run on CI"
        case .deployToIntegration:
            return "Branches off from master to integration and pushes it to remote"
        case .buildCarthage:
            return "Builds the Carthage project"
        case .testUnit:
            return "Runs the unit tests"
        case .testIntegration:
            return "Runs the integration tests"
        case .testAll:
            return "Runs all the tests"
        case .generateCarthageProject:
            return "Generates the Carthage project"
        case .generateDocs:
            return "Generates the Jazzy documentation"
        case .release:
            return "It releases a new minor version of xcproj"
        }
    }
}

struct Constants {
    static let destination: String = "platform=iOS Simulator,name=iPhone 6,OS=11.1"
    static let xcodeGenVersion: String = "1.3.0"
}

enum TestSuite {
    case integration
    case unit
    case ruby
    case all
}

func generateDocs(utils: Utils) throws {
    try utils.shell.runAndPrint(bash: "swift package generate-xcodeproj")
    try utils.shell.runAndPrint(bash: "jazzy --clean --sdk macosx --xcodebuild-arguments -project,xcproj.xcodeproj,-scheme,xcproj-Package --skip-undocumented")
}

func commandExists(_ command: String, utils: Utils) throws -> Bool {
    return try !utils.shell.run(bash: "which \(command)").isEmpty
}

func build(utils: Utils) throws  {
    try utils.shell.runAndPrint(bash: "swift build")
}

func test(suite: TestSuite, utils: Utils) throws {
    switch suite {
    case .integration, .unit:
        var command: String = "swift test"
        let filter = suite == .integration ? "xcprojIntegrationTests": "xcprojTests"
        command = "swift test --filter \(filter)"
        try utils.shell.runAndPrint(bash: command)
    case .ruby:
        try utils.shell.runAndPrint(bash: "bundle exec rspec")
    case .all:
        try test(suite: .unit, utils: utils)
        try test(suite: .integration, utils: utils)
        try test(suite: .ruby, utils: utils)
    }
}

func bumpVersion(from: String, to: String) throws {
    // TODO
}

func podLint(utils: Utils) throws {
    try utils.shell.runAndPrint(bash: "bundle exec pod install --project-directory=CocoaPods/")
    try utils.shell.runAndPrint(bash: "xcodebuild -workspace CocoaPods/CocoaPods.xcworkspace -scheme macOS -config Debug clean build")
    try utils.shell.runAndPrint(bash: "xcodebuild -workspace CocoaPods/CocoaPods.xcworkspace -scheme iOS -config Debug -destination '\(Constants.destination)' clean build")
}

func buildCarthageProject(utils: Utils) throws {
    try utils.shell.runAndPrint(bash: "xcodebuild -project Carthage.xcodeproj -scheme xcproj_macOS -config Debug clean build")
    try utils.shell.runAndPrint(bash: "xcodebuild -project Carthage.xcodeproj -scheme xcproj_iOS -config Debug -destination '\(Constants.destination)' clean build")
}

func generateCarthageProject(utils: Utils) throws {
    let mintInstalled = try commandExists("mint", utils: utils)
    if !mintInstalled { throw "Mint needs to be installed in the system. https://github.com/yonaskolb/mint" }
    try utils.shell.runAndPrint(bash: "mint run yonaskolb/xcodegen@\(Constants.xcodeGenVersion) 'xcodegen --spec carthage-project.yml'")
}

func deployToIntegration(utils: Utils) throws {
    let environment = ProcessInfo.processInfo.environment
    if try utils.git.branch() !=  "master" && environment["TRAVIS_BRANCH"] != "master" { return }
    guard let githubToken = environment["GITHUB_TOKEN"] else { throw "GITHUB_TOKEN environment is missing. Make sure it's setup on Travis-CI"}
    try utils.git.addRemote("origin-travis", url: "https://\(githubToken)@github.com/xcodeswift/xcproj.git")
    try utils.git.push(remote: "origin-travis", branch: "master:integration")
}

func release(utils: Utils) throws {
    try build(utils: utils)
    try generateCarthageProject(utils: utils)
    try buildCarthageProject(utils: utils)
    try generateDocs(utils: utils)
    let version = try Version(utils.git.lastTag())
    let nextVersion = version.bumpingMinor()
    try bumpVersion(from: version.string, to: nextVersion.string)
    try utils.git.commitAll(message: "[release/\(nextVersion.string)] Bump version to \(nextVersion.string)")
    try utils.git.tag(nextVersion.string)
    try utils.git.push(remote: "origin", branch: "release/\(nextVersion)", tags: true)
    try utils.shell.runAndPrint(bash: "bundle exec pod trunk push --verbose --allow-warnings")
}

func continuousIntegration(utils: Utils) throws {
    try utils.shell.runAndPrint(bash: "swiftlint")
    try buildCarthageProject(utils: utils)
    try build(utils: utils)
    try test(suite: .unit, utils: utils)
    try test(suite: .ruby, utils: utils)
    let environment = ProcessInfo.processInfo.environment
    if try utils.git.branch() == "integration" || environment["TRAVIS_BRANCH"] == "integration" {
        try test(suite: .integration, utils: utils)
    }
}

Sake<Task> {
    $0.task(.testUnit, action: { try test(suite: .unit, utils: $0) })
    $0.task(.testIntegration, action: { try test(suite: .integration, utils: $0) })
    $0.task(.testAll, action: { try test(suite: .all, utils: $0) })
    $0.task(.generateCarthageProject, action: generateCarthageProject)
    $0.task(.buildCarthage, action: buildCarthageProject)
    $0.task(.deployToIntegration, action: deployToIntegration)
    $0.task(.generateDocs, action: generateDocs)
    $0.task(.continuousIntegration, action: continuousIntegration)
    $0.task(.release, action: release)
}.run()
