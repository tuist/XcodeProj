import Foundation
@testable import XcodeProj

extension PBXProj {
    static func fixture(rootObject: PBXProject? = PBXProject.fixture(),
                        objectVersion: UInt = Xcode.LastKnown.objectVersion,
                        archiveVersion: UInt = Xcode.LastKnown.archiveVersion,
                        classes: [String: Any] = [:],
                        objects: [PBXObject] = []) -> PBXProj {
        PBXProj(rootObject: rootObject,
                objectVersion: objectVersion,
                archiveVersion: archiveVersion,
                classes: classes,
                objects: objects)
    }
}
