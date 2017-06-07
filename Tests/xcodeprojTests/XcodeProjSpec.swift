import Foundation
import XCTest
import PathKit

import xcodeproj

final class XcodeProjSpec: XCTestCase {
    
    // MARK: - Integration
    
    func test_integration_init_throwsIfThePathIsWrong() {
        do {
            _ = try XcodeProj(path: Path("test"))
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
    func test_integration_init_hasTheASharedData() {
        let got = project()
        XCTAssertNotNil(got?.sharedData)
    }
    
    // MARK: - Private
    
    private func project() -> XcodeProj? {
        let fixtures = Path(#file).parent().parent().parent() + Path("Fixtures")
        let path = fixtures + Path("iOS/Project.xcodeproj")
        return try? XcodeProj(path: path)
    }
}
