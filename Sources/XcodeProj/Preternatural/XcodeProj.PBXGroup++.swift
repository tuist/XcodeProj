//
// Copyright (c) Vatsal Manot
//

import PathKit

extension PBXGroup {
    public func addFile(at path: String, sourceRoot: String) throws -> PBXFileReference {
        try self.addFile(at: Path(path), sourceRoot: Path(sourceRoot))
    }
}

