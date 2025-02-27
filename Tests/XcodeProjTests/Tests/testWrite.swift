import Foundation
import PathKit
import XCTest
@testable import XcodeProj

func testWrite<T: Writable & Equatable>(file _: StaticString = #file,
                                        line _: UInt = #line,
                                        from path: Path,
                                        initModel: (Path) -> T?,
                                        modify: (T) -> T)
{
    testWrite(from: path, initModel: initModel, modify: modify, assertion: { XCTAssertEqual($0, $1) })
}

func testWrite<T: Writable>(file: StaticString = #filePath,
                            line: UInt = #line,
                            from path: Path,
                            initModel: (Path) -> T?,
                            modify: (T) -> T,
                            assertion: (_ before: T, _ after: T) -> Void)
{
    let copyPath = path.parent() + "copy.\(path.extension!)"
    try? copyPath.delete()
    try? path.copy(copyPath)
    let got = initModel(copyPath)
    XCTAssertNotNil(got, file: file, line: line)
    if let got {
        let modified = modify(got)
        do {
            try modified.write(path: copyPath, override: true)
            let gotAfterWriting = initModel(copyPath)
            XCTAssertNotNil(gotAfterWriting, file: file, line: line)
            if let gotAfterWriting {
                assertion(got, gotAfterWriting)
            }
        } catch {
            XCTFail("It shouldn't throw an error writing the project: \(error.localizedDescription)", file: file, line: line)
        }
    }
    try? copyPath.delete()
}

func testReadWriteProducesNoDiff(file _: StaticString = #file,
                                 line _: UInt = #line,
                                 from path: Path,
                                 initModel: (Path) throws -> some Writable) throws
{
    let tmpDir = try Path.uniqueTemporary()
    defer {
        try? tmpDir.delete()
    }

    let fileName = path.lastComponent
    let tmpPath = tmpDir + fileName
    try path.copy(tmpPath)

    try tmpDir.chdir {
        // Create a commit
        try checkedOutput("git", ["init"])
        try checkedOutput("git", ["add", "."])
        try checkedOutput("git", [
            "-c", "user.email=test@example.com", "-c", "user.name=Test User",
            "commit", "-m", "test",
        ])

        let object = try initModel(tmpPath)
        try object.write(path: tmpPath, override: true)

        let diff = try XCTUnwrap(checkedOutput("git", ["diff"]))
        XCTAssertEqual(diff, "")
    }
}
