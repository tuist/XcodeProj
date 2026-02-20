import XcodeProj

extension PBXFileSystemSynchronizedBuildFileExceptionSet {
    static func fixture(target: PBXTarget = .fixture(),
                        membershipExceptions: [String]? = [],
                        publicHeaders: [String]? = [],
                        privateHeaders: [String]? = [],
                        additionalCompilerFlagsByRelativePath: [String: String]? = nil,
                        attributesByRelativePath: [String: [String]]? = nil,
                        platformFiltersByRelativePath: [String: [String]]? = nil) -> PBXFileSystemSynchronizedBuildFileExceptionSet {
        PBXFileSystemSynchronizedBuildFileExceptionSet(target: target,
                                                       membershipExceptions: membershipExceptions,
                                                       publicHeaders: publicHeaders,
                                                       privateHeaders: privateHeaders,
                                                       additionalCompilerFlagsByRelativePath: additionalCompilerFlagsByRelativePath,
                                                       attributesByRelativePath: attributesByRelativePath,
                                                       platformFiltersByRelativePath: platformFiltersByRelativePath)
    }
}
