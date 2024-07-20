import XcodeProj

extension PBXFileSystemSynchronizedBuildFileExceptionSet {
    static func fixture(target: PBXTarget = .fixture(),
                        membershipExceptions: [String]? = [],
                        publicHeaders: [String]? = [],
                        privateHeaders: [String]? = []) -> PBXFileSystemSynchronizedBuildFileExceptionSet {
        return PBXFileSystemSynchronizedBuildFileExceptionSet(target: target,
                                                              membershipExceptions: membershipExceptions,
                                                              publicHeaders: publicHeaders,
                                                              privateHeaders: privateHeaders)
    }
}
