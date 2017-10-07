import Foundation
import XCTest
import xcproj

final class PBXContainerItemProxySpec: XCTestCase {

    var subject: PBXContainerItemProxy!

    override func setUp() {
        super.setUp()
        subject = PBXContainerItemProxy(reference: "reference", containerPortal: "container", remoteGlobalIDString: "remote", remoteInfo: "remote_info")
    }

    func test_itHasTheCorrectIsa() {
        XCTAssertEqual(PBXContainerItemProxy.isa, "PBXContainerItemProxy")
    }

    func test_init_shouldReturnTheCorrectEntity_ifAllTheParametersAreCorrect() {
        XCTAssertEqual(subject.reference, "reference")
        XCTAssertEqual(subject.containerPortal, "container")
        XCTAssertEqual(subject.remoteGlobalIDString, "remote")
        XCTAssertEqual(subject.remoteInfo, "remote_info")
    }

    func test_init_setsTheCorrectDefaultValue_whenContainerPortalIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "containerPortal")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXContainerItemProxy.self, from: data)
        XCTAssertEqual(subject.containerPortal, "")
    }
    
    func test_init_setsTheCorrectDefaultValue_whenRemoteGlobalIDStringIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "remoteGlobalIDString")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXContainerItemProxy.self, from: data)
        XCTAssertEqual(subject.remoteGlobalIDString, "")
    }
    
    func test_init_setsTheCorrectDefaultValue_whenRemoteInfoIsMissing() throws {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "remoteInfo")
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        let decoder = JSONDecoder()
        let subject = try decoder.decode(PBXContainerItemProxy.self, from: data)
        XCTAssertNil(subject.remoteInfo)
    }

    func test_equal_shouldReturnTheCorrectValue() {
        let one = PBXContainerItemProxy(reference: "reference", containerPortal: "portal", remoteGlobalIDString: "globalid", remoteInfo: "info")
        let another = PBXContainerItemProxy(reference: "reference", containerPortal: "portal", remoteGlobalIDString: "globalid", remoteInfo: "info")
        XCTAssertEqual(one, another)
    }

    func test_hash_returnsTheRightValue() {
        XCTAssertEqual(subject.hashValue, subject.reference.hashValue)
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
