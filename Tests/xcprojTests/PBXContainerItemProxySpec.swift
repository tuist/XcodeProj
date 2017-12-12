import Foundation
import XCTest
import xcproj

final class PBXContainerItemProxySpec: XCTestCase {

    var subject: PBXContainerItemProxy!

    override func setUp() {
        super.setUp()
        subject = PBXContainerItemProxy(containerPortal: "container", remoteGlobalIDString: "remote", remoteInfo: "remote_info")
    }

    func test_itHasTheCorrectIsa() {
        XCTAssertEqual(PBXContainerItemProxy.isa, "PBXContainerItemProxy")
    }

    func test_init_shouldReturnTheCorrectEntity_ifAllTheParametersAreCorrect() {
        XCTAssertEqual(subject.containerPortal, "container")
        XCTAssertEqual(subject.remoteGlobalIDString, "remote")
        XCTAssertEqual(subject.remoteInfo, "remote_info")
    }

    func test_init_shouldFail_ifContainerPortalIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "containerPortal")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(PBXContainerItemProxy.self, from: data)
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_equal_shouldReturnTheCorrectValue() {
        let one = PBXContainerItemProxy(containerPortal: "portal", remoteGlobalIDString: "globalid", remoteInfo: "info")
        let another = PBXContainerItemProxy(containerPortal: "portal", remoteGlobalIDString: "globalid", remoteInfo: "info")
        XCTAssertEqual(one, another)
    }

    private func testDictionary() -> [String: Any] {
        return [
            "containerPortal": "containerPortal",
            "remoteGlobalIDString": "remoteGlobalIDString",
            "remoteInfo": "remoteInfo",
            "reference": "reference"
        ]
    }

}
