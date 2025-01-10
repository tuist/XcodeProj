//
// Copyright (c) Vatsal Manot
//

import Foundation

extension XCWorkspaceDataElement {
    internal func referencedFiles(at baseURL: URL) -> [URL] {
        return referencedFiles(at: baseURL, currentGroupURL: baseURL)
    }
    
    private func referencedFiles(at baseURL: URL, currentGroupURL: URL) -> [URL] {
        var allFilePaths: [URL] = []
        switch self {
        case .file(let fileRef):
            allFilePaths.append(fileRef.location.url(for: baseURL, currentGroupURL: currentGroupURL))
        case .group(let groupRef):
            for child in groupRef.children {
                let updatedBaseURL = groupRef.location.updatedBaseURL(for: baseURL)
                allFilePaths.append(contentsOf: child.referencedFiles(at: baseURL, currentGroupURL: updatedBaseURL))
            }
        }
        return allFilePaths
    }
}
