import XcodeProj

extension PBXFileSystemSynchronizedBuildFileExceptionSet {
    static func fixture(target: PBXTarget = .fixture(),
                        membershipExceptions: [String]? = [],
                        publicHeaders: [String]? = [],
                        privateHeaders: [String]? = []) -> PBXFileSystemSynchronizedBuildFileExceptionSet {
        PBXFileSystemSynchronizedBuildFileExceptionSet(target: target,
                                                       membershipExceptions: membershipExceptions,
                                                       publicHeaders: publicHeaders,
                                                       privateHeaders: privateHeaders)
    }
}
