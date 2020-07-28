import Foundation
@testable import XcodeProj

extension PBXGroup {
    static func fixture(children _: [PBXFileElement] = [],
                        sourceTree: PBXSourceTree = .group,
                        name: String = "test") -> PBXGroup {
        PBXGroup(children: [],
                 sourceTree: sourceTree,
                 name: name)
    }
}
