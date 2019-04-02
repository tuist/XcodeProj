import Foundation

@testable import XcodeProj

extension PBXSourcesBuildPhase {
    static func fixture(files: [PBXBuildFile] = []) -> PBXSourcesBuildPhase {
        return PBXSourcesBuildPhase(files: files,
                                    inputFileListPaths: nil,
                                    outputFileListPaths: nil,
                                    buildActionMask: PBXBuildPhase.defaultBuildActionMask,
                                    runOnlyForDeploymentPostprocessing: false)
    }
}
