import Foundation
import XCTest
import PathKit
import xcproj

final class XcodeProjIntegrationSpec: XCTestCase {

    func test_init_throwsIfThePathIsWrong() {
        do {
            _ = try XcodeProj(path: Path("test"))
            XCTAssertTrue(false, "Expected to throw an error but it didn't")
        } catch {}
    }

    func test_init_hasTheASharedData() {
        let got = project()
        XCTAssertNotNil(got?.sharedData)
    }

    func test_write() {
        testWrite(from: fixturePath(),
                  initModel: { try? XcodeProj(path: $0) },
                  modify: { $0 })
    }

    private func fixturePath() -> Path {
        return fixturesPath() + "iOS/Project.xcodeproj"
    }

    // MARK: - Private

    private func project() -> XcodeProj? {
        do {
            return try XcodeProj(path: fixturePath())
        } catch{
            print("ERROR: \(error)")
            return nil
        }
    }
}
