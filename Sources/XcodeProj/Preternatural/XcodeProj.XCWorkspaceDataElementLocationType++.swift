//
// Copyright (c) Vatsal Manot
//

import Foundation

extension XCWorkspaceDataElementLocationType {
    internal func url(for baseURL: URL, currentGroupURL: URL) -> URL {
        switch self {
        case .absolute(let path):
            return URL(filePath: path)
        case .group(let path):
            return currentGroupURL.appending(path: path)
        case .container(let path),
             .developer(let path),
             .current(let path),
             .other(_, let path):
            return baseURL.appending(path: path)
        }
    }

    internal func updatedBaseURL(for originalBaseURL: URL) -> URL {
        switch self {
        case .absolute,
             .container,
             .developer,
             .current,
             .other:
            return originalBaseURL
        case .group(let path):
            return originalBaseURL.appending(path: path)
        }
    }
}
