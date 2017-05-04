import Foundation
import XCTest

@testable import xcodeproj

final class PBXContainerItemProxySpec: XCTestCase {
 
    var subject: PBXContainerItemProxy!
    
    override func setUp() {
        super.setUp()
        subject = PBXContainerItemProxy(reference: "reference", containerPortal: "container", remoteGlobalIDString: "remote", remoteInfo: "remote_info")
    }
    
    func test_itHasTheCorrectIsa() {
        XCTAssertEqual(subject.isa, "PBXContainerItemProxy")
    }
    
    func test_init_shouldReturnTheCorrectEntity_ifAllTheParametersAreCorrect() {
        XCTAssertEqual(subject.reference, "reference")
        XCTAssertEqual(subject.containerPortal, "container")
        XCTAssertEqual(subject.remoteGlobalIDString, "remote")
        XCTAssertEqual(subject.remoteInfo, "remote_info")
    }
    
    func test_init_shouldFail_ifContainerPortalIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "containerPortal")
        do {
            _ = try PBXContainerItemProxy(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected init to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_shouldFail_ifRemoteGlobalIDStringIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "remoteGlobalIDString")
        do {
            _ = try PBXContainerItemProxy(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected init to throw an error but it didn't")
        } catch {}
    }
    
    func test_init_shouldFail_ifRemoteInfoIsMissing() {
        var dictionary = testDictionary()
        dictionary.removeValue(forKey: "remoteInfo")
        do {
            _ = try PBXContainerItemProxy(reference: "reference", dictionary: dictionary)
            XCTAssertTrue(false, "Expected init to throw an error but it didn't")
        } catch {}
    }
    
    private func testDictionary() -> [String: Any] {
        return [
            "containerPortal": "containerPortal",
            "remoteGlobalIDString": "remoteGlobalIDString",
            "remoteInfo": "remoteInfo"
        ]
    }
    
}
