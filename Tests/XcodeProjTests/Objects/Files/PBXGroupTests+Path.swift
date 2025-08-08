#if os(macOS) || (os(Linux) && compiler(>=6.1))

    import Foundation
    import PathKit
    import XcodeProj
    import XCTest

    extension PBXGroupTests {
        func test_takingGroupWithSpecificPath() throws {
            let proj = try PBXProj(data: iosProjectWithExtensionsData())
            let mainGroup = proj.rootObject?.mainGroup
            XCTAssertNotNil(mainGroup)

            let mainAppGroup = mainGroup?.group(with: "AppWithExtensions")
            XCTAssertNotNil(mainAppGroup)

            let nilGroup = mainGroup?.group(with: "Not_Existing")
            XCTAssertNil(nilGroup)
        }

        func test_takingCreatedGroupWithSpecificPath() throws {
            let proj = try PBXProj(data: iosProjectData())
            let mainGroup = proj.rootObject?.mainGroup
            XCTAssertNil(mainGroup?.group(with: "group"))

            try mainGroup?.addGroup(named: "group")
            XCTAssertNotNil(mainGroup?.group(with: "group"))
        }
    }
#endif
