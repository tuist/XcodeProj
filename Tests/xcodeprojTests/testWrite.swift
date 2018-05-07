import Foundation
import Basic
import XCTest

@testable import xcodeproj

func testWrite<T: Writable & Equatable>(from path: AbsolutePath,
               initModel: (AbsolutePath) -> T?,
               modify: (T) -> (T)) {
    testWrite(from: path, initModel: initModel, modify: modify, assertion: { XCTAssertEqual($0, $1) })
}

func testWrite<T: Writable>(from path: AbsolutePath,
                       initModel: (AbsolutePath) -> T?,
                       modify: (T) -> (T),
                       assertion: (_ before: T, _ after: T) -> ()) {
    let copyPath = path.parentDirectory.appending(component: "copy.\(path.extension!)")
    try? copyPath.delete()
    try? path.copy(copyPath)
    let got = initModel(copyPath)
    XCTAssertNotNil(got)
    if let got = got {
        let modified = modify(got)
        do {
            try modified.write(path: copyPath, override: true)
            let gotAfterWriting = initModel(copyPath)
            XCTAssertNotNil(gotAfterWriting)
            if let gotAfterWriting = gotAfterWriting {
                assertion(got, gotAfterWriting)
            }
        } catch {
            XCTFail("It shouldn't throw an error writing the project: \(error.localizedDescription)")
        }
    }
    try? copyPath.delete()
}
