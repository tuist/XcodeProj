import Foundation

@testable import xcodeproj

extension PBXFileReference {
    static func fixture(sourceTree _: PBXSourceTree = .group,
                        name: String? = "Test") -> PBXFileReference {
        return PBXFileReference(sourceTree: .group, name: name)
    }
}
