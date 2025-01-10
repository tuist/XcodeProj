//
// Copyright (c) Vatsal Manot
//

import FoundationX

extension URL {
    public var isPackageURL: Bool {
        return self.pathExtension == "" && self.appendingPathComponent("Package.swift")._isValidFileURLCheckingIfExistsIfNecessary()
    }
}
