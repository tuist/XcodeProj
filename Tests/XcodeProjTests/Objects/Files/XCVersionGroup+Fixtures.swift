import Foundation
@testable import XcodeProj

extension XCVersionGroup {
    static func fixture(objects: PBXObjects,
                        currentVersion: PBXFileReference? = PBXFileReference(name: "currentVersion"),
                        path: String = "path",
                        name: String? = "name",
                        sourceTree: PBXSourceTree = .group,
                        versionGroupType: String = "versionGroupType",
                        children: [PBXFileReference] = [PBXFileReference(name: "currentVersion")]) -> XCVersionGroup {
        let group = XCVersionGroup(currentVersion: currentVersion,
                                   path: path,
                                   name: name,
                                   sourceTree: sourceTree,
                                   versionGroupType: versionGroupType,
                                   children: children)
        if let currentVersion = currentVersion {
            objects.add(object: currentVersion)
        }
        children.forEach { objects.add(object: $0) }
        objects.add(object: group)
        return group
    }
}
