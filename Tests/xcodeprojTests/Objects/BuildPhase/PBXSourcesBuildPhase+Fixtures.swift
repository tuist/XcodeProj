import Foundation

@testable import xcodeproj

extension PBXSourcesBuildPhase {
    static func fixture(files: [PBXBuildFile] = []) -> PBXSourcesBuildPhase {
        return PBXSourcesBuildPhase(files: files,
                                    inputFileListPaths: nil,
                                    outputFileListPaths: nil,
                                    buildActionMask: PBXBuildPhase.defaultBuildActionMask,
                                    runOnlyForDeploymentPostprocessing: false)
    }
}
