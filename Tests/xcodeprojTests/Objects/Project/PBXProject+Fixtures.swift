import Foundation
@testable import xcodeproj

extension PBXProject {
    static func fixture(name: String = "test",
                        buildConfigurationList: XCConfigurationList = XCConfigurationList.fixture(),
                        compatibilityVersion: String = Xcode.Default.compatibilityVersion,
                        mainGroup: PBXGroup = PBXGroup.fixture()) -> PBXProject {
        return PBXProject(name: name,
                          buildConfigurationList: buildConfigurationList,
                          compatibilityVersion: compatibilityVersion,
                          mainGroup: mainGroup)
    }
}
