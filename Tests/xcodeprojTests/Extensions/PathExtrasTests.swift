import PathKit
import XCTest
@testable import XcodeProj

final class PathExtrasTests: XCTestCase {
    func testThat_GivenAbsoluteSubPath_WhenRelativeToAbsoluteSuperPath_ThenResultIsTheRemainder() {
        XCTAssertEqual(Path("/absolute/dir/file.txt").relative(to: Path("/absolute")), Path("dir/file.txt"))
    }

    func testThat_GivenAbsolutePath_WhenRelativeToNotSuperseedingAbsolutePath_ThenResultHasDoubleDot() {
        XCTAssertEqual(Path("/absolute/dir/file.txt").relative(to: Path("/absolute/anotherDir")), Path("../dir/file.txt"))
    }

    func testThat_GivenAbsoluteSubPath_WhenRelativeToIntersectingAbsolutePath_ThenResultIsTheFullPathToTheRootAndThenFullAbsolutePath() {
        XCTAssertEqual(Path("/absolute/dir/file.txt").relative(to: Path("/var")), Path("../absolute/dir/file.txt"))
    }

    func testThat_GivenSubPath_WhenRelativeToSuperPath_ThenResultIsTheRemainder() {
        XCTAssertEqual(Path("some/dir/file.txt").relative(to: Path("some")), Path("dir/file.txt"))
    }

    func testThat_GivenPath_WhenRelativeToNotSuperseedingPath_ThenResultHasDoubleDot() {
        XCTAssertEqual(Path("some/dir/file.txt").relative(to: Path("anotherDir")), Path("../some/dir/file.txt"))
    }
}
