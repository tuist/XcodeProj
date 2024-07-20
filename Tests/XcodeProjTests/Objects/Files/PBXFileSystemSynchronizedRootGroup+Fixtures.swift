import XcodeProj

extension PBXFileSystemSynchronizedRootGroup {
    static func fixture(sourceTree: PBXSourceTree? = nil,
                            path: String? = nil,
                            name: String? = nil,
                            includeInIndex: Bool? = nil,
                            usesTabs: Bool? = nil,
                            indentWidth: UInt? = nil,
                            tabWidth: UInt? = nil,
                            wrapsLines: Bool? = nil,
                            explicitFileTypes: [String: String] = [:],
                            exceptions: [PBXFileSystemSynchronizedBuildFileExceptionSet] = [],
                        explicitFolders: [String] = []) -> PBXFileSystemSynchronizedRootGroup {
        return PBXFileSystemSynchronizedRootGroup(sourceTree: sourceTree,
                                                  path: path,
                                                  name: name,
                                                  includeInIndex: includeInIndex,
                                                  usesTabs: usesTabs,
                                                  indentWidth: indentWidth,
                                                  tabWidth: tabWidth,
                                                  wrapsLines: wrapsLines,
                                                  explicitFileTypes: explicitFileTypes,
                                                  exceptions: exceptions, 
                                                  explicitFolders: explicitFolders)
    }
}
