//
// Copyright (c) Vatsal Manot
//

import PathKit

extension XcodeProj {
    public func writePBXProj(path: String, override: Bool, outputSettings: PBXOutputSettings) throws {
        try self.writePBXProj(path: Path(path), override: override, outputSettings: outputSettings)
    }
  
    public var remotePackageURLs: Set<String> {
        var remotePackageURLs = Set<String>()
        if let root = pbxproj.rootObject {
            for package in root.remotePackages {
                if let repositoryURL = package.repositoryURL {
                    remotePackageURLs.append(repositoryURL)
                }
            }
        }
        return remotePackageURLs
    }
}
