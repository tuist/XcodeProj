import Foundation
import XCTest

@testable import XcodeProj

final class PBXTargetTests: XCTestCase {
    var subject: PBXTarget!

    override func setUp() {
        super.setUp()
        subject = PBXTarget.fixture()
    }

    func test_productNameWithExtension() {
        let expected = "\(subject.productName!).\(subject.productType!.fileExtension!)"
        XCTAssertEqual(subject.productNameWithExtension(), expected)
    }

    func test_embedFrameworks_returnsEmpty() {
        XCTAssertTrue(subject.embedFrameworksBuildPhases().isEmpty)
    }

    func test_embedFrameworks_returnsEmptyIfNoCopyFilesFrameworks() {
        let buildPhase1 = PBXFrameworksBuildPhase(
            files: [],
            inputFileListPaths: nil,
            outputFileListPaths: nil, buildActionMask: PBXBuildPhase.defaultBuildActionMask,
            runOnlyForDeploymentPostprocessing: true
        )
        let buildPhase2 = PBXCopyFilesBuildPhase(
            dstPath: nil,
            dstSubfolderSpec: .resources,
            name: "Embed Frameworks",
            buildActionMask: PBXBuildPhase.defaultBuildActionMask,
            files: [],
            runOnlyForDeploymentPostprocessing: true
        )

        subject.buildPhases.append(buildPhase1)
        subject.buildPhases.append(buildPhase2)

        XCTAssertTrue(subject.embedFrameworksBuildPhases().isEmpty)
    }

    func test_embedFrameworks_returnsUniqueEmbedFrameworksBuildPhase() {
        let embedFrameworkBuildPhase = PBXCopyFilesBuildPhase(
            dstPath: nil,
            dstSubfolderSpec: .frameworks,
            name: "Embed Frameworks",
            buildActionMask: PBXBuildPhase.defaultBuildActionMask,
            files: [],
            runOnlyForDeploymentPostprocessing: true
        )
        subject.buildPhases.append(embedFrameworkBuildPhase)

        let embedFrameworkBuildPhases = subject.embedFrameworksBuildPhases()

        XCTAssertTrue(embedFrameworkBuildPhases.count == 1)
        XCTAssertEqual(embedFrameworkBuildPhases.first, embedFrameworkBuildPhase)
    }

    func test_embedFrameworks_returnsTwoBuildPhasesIfCorresponds() {
        let embedFrameworkBuildPhase1 = PBXCopyFilesBuildPhase(
            dstPath: nil,
            dstSubfolderSpec: .frameworks,
            name: "Embed Frameworks",
            buildActionMask: PBXBuildPhase.defaultBuildActionMask,
            files: [],
            runOnlyForDeploymentPostprocessing: true
        )
        let embedFrameworkBuildPhase2 = PBXCopyFilesBuildPhase(
            dstPath: nil,
            dstSubfolderSpec: .frameworks,
            name: "Others Embed Frameworks",
            buildActionMask: PBXBuildPhase.defaultBuildActionMask,
            files: [],
            runOnlyForDeploymentPostprocessing: true
        )
        subject.buildPhases.append(embedFrameworkBuildPhase1)
        subject.buildPhases.append(embedFrameworkBuildPhase2)

        let embedFrameworkBuildPhases = subject.embedFrameworksBuildPhases()

        XCTAssertTrue(embedFrameworkBuildPhases.count == 2)
        XCTAssertTrue(embedFrameworkBuildPhases.contains(embedFrameworkBuildPhase1))
        XCTAssertTrue(embedFrameworkBuildPhases.contains(embedFrameworkBuildPhase2))
    }
}
