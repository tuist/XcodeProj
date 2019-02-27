import Foundation
@testable import xcodeproj
import SwiftShell
import PathKit
import XCTest

class PBXBatchUpdaterTests: XCTestCase {

    func test_addFile_addAllFiles() {
        let sourceRoot = Path("/")
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
            let filePath = "\(Path.temporary.string)/file"
            Files.createFile(atPath: filePath, contents: nil, attributes: nil)
            try updater.addFile(to: group, at: Path(filePath))
        }
        
        XCTAssertEqual(proj.fileReferences.count, 2)
    }
    
}
