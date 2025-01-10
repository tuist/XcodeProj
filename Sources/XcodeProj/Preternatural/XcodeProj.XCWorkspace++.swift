//
// Copyright (c) Vatsal Manot
//

import Foundation
import PathKit

extension XCWorkspace {
    public func referencedPackages(at baseURL: URL) -> [URL] {
        var allProjectURLs: [URL] = []
        for child in data.children {
            let fileURLs = child.referencedFiles(at: baseURL.deletingLastPathComponent())
            let projectURLs = fileURLs.filter { $0.isPackageURL }
            allProjectURLs.append(contentsOf: projectURLs)
        }
        return allProjectURLs
    }

    public func referencedProjects(at baseURL: URL) -> [URL] {
        var allProjectURLs: [URL] = []
        for child in data.children {
            let fileURLs = child.referencedFiles(at: baseURL.deletingLastPathComponent())
            let projectURLs = fileURLs.filter { $0.pathExtension == "xcodeproj" }
            allProjectURLs.append(contentsOf: projectURLs)
        }
        return allProjectURLs
    }
    
    public func write(pathString: String, override: Bool) throws {
        try write(path: Path(pathString), override: override)
    }
}
