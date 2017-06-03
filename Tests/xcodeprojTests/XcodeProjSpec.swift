import Foundation
import XCTest
import PathKit

@testable import xcodeproj

final class XcodeProjSpec: XCTestCase {
    
    func test_integration_init_returnsTheModelInitializedProperly() {
        let fixtures = Path(#file).parent().parent().parent() + Path("Fixtures")
        let path = fixtures + Path("iOS/Project.xcodeproj")
        let project = try? XcodeProj(path: path)
        XCTAssertEqual(project?.path, path)
        XCTAssertNotNil(project)
    }
    
    func test_integration_init_throwsIfThePathIsWrong() {
        do {
            _ = try XcodeProj(path: Path("test"))
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }
}
