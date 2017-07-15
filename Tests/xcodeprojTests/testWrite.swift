import Foundation
import PathKit
import XCTest
import xcodeproj
import xcodeprojprotocols

func testWrite<T: Writable & Equatable>(from path: Path,
               initModel: (Path) -> T?,
               modify: (T) -> (T)) {
    testWrite(from: path, initModel: initModel, modify: modify, assertion: { XCTAssertEqual($0, $1) })
}

func testWrite<T: Writable>(from path: Path,
                       initModel: (Path) -> T?,
                       modify: (T) -> (T),
                       assertion: (_ before: T, _ after: T) -> ()) {
    let fm = FileManager.default
    let copyPath = path.parent() + Path("copy.\(path.extension!)")
    try? fm.removeItem(at: copyPath.url)
    try? fm.copyItem(at: path.url, to: copyPath.url)
    let got = initModel(copyPath)
    XCTAssertNotNil(got)
    if let got = got {
        let modified = modify(got)
        do {
            try modified.write(override: true)
            let gotAfterWriting = initModel(copyPath)
            XCTAssertNotNil(gotAfterWriting)
            if let gotAfterWriting = gotAfterWriting {
                assertion(got, gotAfterWriting)
            }
        } catch {
            XCTAssertTrue(false, "It shouldn't throw an error writing the project")
        }
    }
//    try? fm.removeItem(at: copyPath.url)
}
