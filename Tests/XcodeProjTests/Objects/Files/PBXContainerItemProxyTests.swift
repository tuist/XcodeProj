import Foundation
import XCTest
@testable import XcodeProj

final class PBXContainerItemProxyTests: XCTestCase {
    func test_itHasTheCorrectIsa() {
        XCTAssertEqual(PBXContainerItemProxy.isa, "PBXContainerItemProxy")
    }

    func test_init_shouldFail_ifContainerPortalIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "containerPortal")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = XcodeprojJSONDecoder()
        do {
            _ = try decoder.decode(PBXContainerItemProxy.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_maintains_remoteID() {
        let target = PBXNativeTarget(name: "")
        let project = PBXProject(name: "", buildConfigurationList: XCConfigurationList(), compatibilityVersion: "", mainGroup: PBXGroup())
        let containerProxy = PBXContainerItemProxy(containerPortal: .project(project), remoteGlobalID: .object(target))

        XCTAssertEqual(target.uuid, containerProxy.remoteGlobalID?.uuid)
    }

    private func testDictionary() -> [String: Any] {
        [
            "containerPortal": "containerPortal",
            "remoteGlobalIDString": "remoteGlobalIDString",
            "remoteInfo": "remoteInfo",
            "reference": "reference",
        ]
    }
}
