import Foundation
import PathKit
import SwiftShell
import XCTest
@testable import xcodeproj

class PBXBatchUpdaterTests: XCTestCase {
    func test_addFile_addAllFiles() {
        let sourceRoot = Path.temporary
        let proj = PBXProj.fixture()
        let fileref = PBXFileReference(sourceTree: .group,
                                       fileEncoding: 1,
                                       explicitFileType: "sourcecode.swift",
                                       lastKnownFileType: nil,
                                       path: "path")
        proj.add(object: fileref)
        let group = PBXGroup(children: [fileref],
                             sourceTree: .group,
                             name: "group")
        proj.add(object: group)

        try! proj.batchUpdate(sourceRoot: sourceRoot) { updater in
            let fileName = "file.swift"
            let filePath = "\(sourceRoot.string)/\(fileName)"
            Files.createFile(atPath: filePath, contents: nil, attributes: nil)
            try updater.addFile(to: group, fileName: fileName)
        }

        XCTAssertEqual(proj.fileReferences.count, 2)
    }
}
