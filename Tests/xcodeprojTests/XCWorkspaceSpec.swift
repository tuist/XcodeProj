import Foundation
import XCTest
import PathKit

import xcodeproj

final class XCWorkspaceSpec: XCTestCase {
    
    func test_integration_initTheWorkspaceWithTheRightPropeties() {
        let fixtures = Path(#file).parent().parent().parent() + Path("Fixtures")
        let path = fixtures + Path("iOS/Project.xcodeproj/project.xcworkspace")
        let got = try? XCWorkspace(path: path)
        XCTAssertNotNil(got)
    }
    
    func test_integration_initFailsIfThePathIsWrong() {
        do {
            _ = try XCWorkspace(path: Path("test"))
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
    
}
