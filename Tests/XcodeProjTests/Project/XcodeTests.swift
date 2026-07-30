import XCTest

@testable import XcodeProj

final class XcodeTests: XCTestCase {
    func test_filetype_whenIconComposerBundle() {
        XCTAssertEqual(Xcode.filetype(extension: "icon"), "folder.iconcomposer.icon")
    }
}
