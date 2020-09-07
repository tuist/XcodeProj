
import Foundation
import XCTest
@testable import XcodeProj

class PBXProjEncoderTests: XCTestCase {
    var proj: PBXProj!

    override func setUp() {
        super.setUp()
        let dic = iosProjectDictionary()
        do {
            proj = try PBXProj(jsonDictionary: dic.1)
        } catch {
            XCTFail("Failed to load project from file \(error)")
        }
    }

    // MARK: - Header

    func test_writeHeaders() throws {
        let lines = self.lines(fromFile: encodeProject())
        XCTAssertEqual(583, lines.count)
        XCTAssertEqual("// !$*UTF8*$!", lines[0])
    }

    // MARK: - Internal file lists

    func test_buildFiles_in_default_uuid_order() {
        let lines = self.lines(fromFile: encodeProject())
        var line = lines.validate(line: "/* Begin PBXBuildFile section */")
        line = lines.validate(lineContaining: "04D5C09F1F153824008A2F98 /* CoreData.framework in Frameworks */", onLineAfter: line)
        line = lines.validate(lineContaining: "04D5C0A31F153924008A2F98 /* Public.h in Headers */", onLineAfter: line)
        line = lines.validate(lineContaining: "04D5C0A41F153924008A2F98 /* Protected.h in Headers */", onLineAfter: line)
        line = lines.validate(lineContaining: "04D5C0A51F153924008A2F98 /* Private.h in Headers */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C161EAA3484007A9026 /* AppDelegate.swift in Sources */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C181EAA3484007A9026 /* ViewController.swift in Sources */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C1B1EAA3484007A9026 /* Main.storyboard in Resources */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C1D1EAA3484007A9026 /* Assets.xcassets in Resources */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C201EAA3484007A9026 /* LaunchScreen.storyboard in Resources */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C2B1EAA3484007A9026 /* iOSTests.swift in Sources */", onLineAfter: line)
        line = lines.validate(lineContaining: "3CD1EADD205763E400DAEECB /* Model.xcdatamodeld in Sources */", onLineAfter: line)
        line = lines.validate(lineContaining: "42AA1A1A22AAF48100428760 /* MyLocalPackage in Frameworks */", onLineAfter: line)
        line = lines.validate(lineContaining: "42AA1A1C22AAF48100428760 /* RxSwift in Frameworks */", onLineAfter: line)
        lines.validate(line: "/* End PBXBuildFile section */", onLineAfter: line)
    }

    func test_buildFiles_in_filename_order() {
        let settings = PBXOutputSettings(projFileListOrder: .byFilename)
        let lines = self.lines(fromFile: encodeProject(settings: settings))
        var line = lines.validate(line: "/* Begin PBXBuildFile section */")
        line = lines.validate(lineContaining: "23766C161EAA3484007A9026 /* AppDelegate.swift in Sources */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C1D1EAA3484007A9026 /* Assets.xcassets in Resources */", onLineAfter: line)
        line = lines.validate(lineContaining: "04D5C09F1F153824008A2F98 /* CoreData.framework in Frameworks */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C201EAA3484007A9026 /* LaunchScreen.storyboard in Resources */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C1B1EAA3484007A9026 /* Main.storyboard in Resources */", onLineAfter: line)
        line = lines.validate(lineContaining: "3CD1EADD205763E400DAEECB /* Model.xcdatamodeld in Sources */", onLineAfter: line)
        line = lines.validate(lineContaining: "04D5C0A51F153924008A2F98 /* Private.h in Headers */", onLineAfter: line)
        line = lines.validate(lineContaining: "04D5C0A41F153924008A2F98 /* Protected.h in Headers */", onLineAfter: line)
        line = lines.validate(lineContaining: "04D5C0A31F153924008A2F98 /* Public.h in Headers */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C181EAA3484007A9026 /* ViewController.swift in Sources */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C2B1EAA3484007A9026 /* iOSTests.swift in Sources */", onLineAfter: line)
        line = lines.validate(lineContaining: "42AA1A1A22AAF48100428760 /* MyLocalPackage in Frameworks */", onLineAfter: line)
        line = lines.validate(lineContaining: "42AA1A1C22AAF48100428760 /* RxSwift in Frameworks */", onLineAfter: line)
        lines.validate(line: "/* End PBXBuildFile section */", onLineAfter: line)
    }

    func test_file_references_in_default_uuid_order() {
        let lines = self.lines(fromFile: encodeProject())
        var line = lines.validate(line: "/* Begin PBXFileReference section */")
        line = lines.validate(lineContaining: "04D5C09E1F153824008A2F98 /* CoreData.framework */", onLineAfter: line)
        line = lines.validate(lineContaining: "04D5C0A01F153915008A2F98 /* Public.h */", onLineAfter: line)
        line = lines.validate(lineContaining: "04D5C0A11F15391B008A2F98 /* Protected.h */", onLineAfter: line)
        line = lines.validate(lineContaining: "04D5C0A21F153921008A2F98 /* Private.h */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C121EAA3484007A9026 /* iOS.app */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C151EAA3484007A9026 /* AppDelegate.swift */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C171EAA3484007A9026 /* ViewController.swift */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C1A1EAA3484007A9026 /* Base */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C1C1EAA3484007A9026 /* Assets.xcassets */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C1F1EAA3484007A9026 /* Base */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C211EAA3484007A9026 /* Info.plist */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C261EAA3484007A9026 /* iOSTests.xctest */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C2A1EAA3484007A9026 /* iOSTests.swift */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C2C1EAA3484007A9026 /* Info.plist */", onLineAfter: line)
        line = lines.validate(lineContaining: "23C1E0AF23657FB500B8D1EF /* iOS.xctestplan */", onLineAfter: line)
        line = lines.validate(lineContaining: "3CD1EADC205763E400DAEECB /* Model.xcdatamodel */", onLineAfter: line)
        line = lines.validate(lineContaining: "42AA1A1822AAF41000428760 /* MyLocalPackage */", onLineAfter: line)
        lines.validate(line: "/* End PBXFileReference section */", onLineAfter: line)
    }

    func test_file_references_in_filename_order() {
        let settings = PBXOutputSettings(projFileListOrder: .byFilename)
        let lines = self.lines(fromFile: encodeProject(settings: settings))
        var line = lines.validate(line: "/* Begin PBXFileReference section */")
        line = lines.validate(lineContaining: "23766C151EAA3484007A9026 /* AppDelegate.swift */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C1C1EAA3484007A9026 /* Assets.xcassets */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C1A1EAA3484007A9026 /* Base */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C1F1EAA3484007A9026 /* Base */", onLineAfter: line)
        line = lines.validate(lineContaining: "04D5C09E1F153824008A2F98 /* CoreData.framework */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C211EAA3484007A9026 /* Info.plist */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C2C1EAA3484007A9026 /* Info.plist */", onLineAfter: line)
        line = lines.validate(lineContaining: "3CD1EADC205763E400DAEECB /* Model.xcdatamodel */", onLineAfter: line)
        line = lines.validate(lineContaining: "42AA1A1822AAF41000428760 /* MyLocalPackage */", onLineAfter: line)
        line = lines.validate(lineContaining: "04D5C0A21F153921008A2F98 /* Private.h */", onLineAfter: line)
        line = lines.validate(lineContaining: "04D5C0A11F15391B008A2F98 /* Protected.h */", onLineAfter: line)
        line = lines.validate(lineContaining: "04D5C0A01F153915008A2F98 /* Public.h */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C171EAA3484007A9026 /* ViewController.swift */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C121EAA3484007A9026 /* iOS.app */", onLineAfter: line)
        line = lines.validate(lineContaining: "23C1E0AF23657FB500B8D1EF /* iOS.xctestplan */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C2A1EAA3484007A9026 /* iOSTests.swift */", onLineAfter: line)
        line = lines.validate(lineContaining: "23766C261EAA3484007A9026 /* iOSTests.xctest */", onLineAfter: line)
        lines.validate(line: "/* End PBXFileReference section */", onLineAfter: line)
    }

    // MARK: - Navigator

    func test_navigator_groups_in_default_order() {
        let lines = self.lines(fromFile: encodeProject())

        let beginGroup = lines.findLine("/* Begin PBXGroup section */")

        // Root
        let rootGroup = lines.findLine("23766C091EAA3484007A9026 = {", after: beginGroup)
        let rootChildrenStart = lines.findLine("children = (", after: rootGroup)
        let rootChildrenEnd = lines.findLine(");", after: rootChildrenStart)

        lines.validate(line: "23766C141EAA3484007A9026 /* iOS */,", betweenLine: rootChildrenStart, andLine: rootChildrenEnd)
        lines.validate(line: "23766C291EAA3484007A9026 /* iOSTests */,", betweenLine: rootChildrenStart, andLine: rootChildrenEnd)
        lines.validate(line: "23766C131EAA3484007A9026 /* Products */,", betweenLine: rootChildrenStart, andLine: rootChildrenEnd)
        lines.validate(line: "04D5C09D1F153824008A2F98 /* Frameworks */,", betweenLine: rootChildrenStart, andLine: rootChildrenEnd)

        // iOS
        let iosGroup = lines.findLine("23766C141EAA3484007A9026 /* iOS */ = {", after: beginGroup)
        let iosChildrenStart = lines.findLine("children = (", after: iosGroup)
        let iosChildrenEnd = lines.findLine(");", after: iosChildrenStart)

        lines.validate(line: "3CD1EADB205763E400DAEECB /* Model.xcdatamodeld */,", betweenLine: iosChildrenStart, andLine: iosChildrenEnd)
        lines.validate(line: "3CD1EAD92057638200DAEECB /* GroupWithoutFolder */,", betweenLine: iosChildrenStart, andLine: iosChildrenEnd)
        lines.validate(line: "23766C151EAA3484007A9026 /* AppDelegate.swift */,", betweenLine: iosChildrenStart, andLine: iosChildrenEnd)
        lines.validate(line: "23766C171EAA3484007A9026 /* ViewController.swift */,", betweenLine: iosChildrenStart, andLine: iosChildrenEnd)
        lines.validate(line: "23766C191EAA3484007A9026 /* Main.storyboard */,", betweenLine: iosChildrenStart, andLine: iosChildrenEnd)
        lines.validate(line: "23766C1C1EAA3484007A9026 /* Assets.xcassets */,", betweenLine: iosChildrenStart, andLine: iosChildrenEnd)
        lines.validate(line: "23766C1E1EAA3484007A9026 /* LaunchScreen.storyboard */,", betweenLine: iosChildrenStart, andLine: iosChildrenEnd)
        lines.validate(line: "23766C211EAA3484007A9026 /* Info.plist */,", betweenLine: iosChildrenStart, andLine: iosChildrenEnd)
        lines.validate(line: "04D5C0A01F153915008A2F98 /* Public.h */,", betweenLine: iosChildrenStart, andLine: iosChildrenEnd)
        lines.validate(line: "04D5C0A11F15391B008A2F98 /* Protected.h */,", betweenLine: iosChildrenStart, andLine: iosChildrenEnd)
        lines.validate(line: "04D5C0A21F153921008A2F98 /* Private.h */,", betweenLine: iosChildrenStart, andLine: iosChildrenEnd)

        // iOS Tests
        let iosTestsGroup = lines.findLine("23766C291EAA3484007A9026 /* iOSTests */ = {", after: beginGroup)
        let iosTestsChildrenStart = lines.findLine("children = (", after: iosTestsGroup)
        let iosTestsChildrenEnd = lines.findLine(");", after: iosTestsChildrenStart)

        lines.validate(line: "23766C2A1EAA3484007A9026 /* iOSTests.swift */,", betweenLine: iosTestsChildrenStart, andLine: iosTestsChildrenEnd)
        lines.validate(line: "23766C2C1EAA3484007A9026 /* Info.plist */,", betweenLine: iosTestsChildrenStart, andLine: iosTestsChildrenEnd)
    }

    func test_navigator_groups_in_filename_order() {
        let settings = PBXOutputSettings(projNavigatorFileOrder: .byFilename)
        let lines = self.lines(fromFile: encodeProject(settings: settings))

        let beginGroup = lines.findLine("/* Begin PBXGroup section */")

        // Root
        let rootGroup = lines.findLine("23766C091EAA3484007A9026 = {", after: beginGroup)
        var line = lines.findLine("children = (", after: rootGroup)
        line = lines.validate(line: "04D5C09D1F153824008A2F98 /* Frameworks */,", after: line)
        line = lines.validate(line: "23766C131EAA3484007A9026 /* Products */,", after: line)
        line = lines.validate(line: "23766C141EAA3484007A9026 /* iOS */,", after: line)
        line = lines.validate(line: "23766C291EAA3484007A9026 /* iOSTests */,", after: line)
        lines.validate(line: ");", after: line)

        // iOS
        let iosGroup = lines.findLine("23766C141EAA3484007A9026 /* iOS */ = {", after: beginGroup)
        line = lines.findLine("children = (", after: iosGroup)
        line = lines.validate(line: "23766C151EAA3484007A9026 /* AppDelegate.swift */,", after: line)
        line = lines.validate(line: "23766C1C1EAA3484007A9026 /* Assets.xcassets */,", after: line)
        line = lines.validate(line: "3CD1EAD92057638200DAEECB /* GroupWithoutFolder */,", after: line)
        line = lines.validate(line: "23766C211EAA3484007A9026 /* Info.plist */,", after: line)
        line = lines.validate(line: "23766C1E1EAA3484007A9026 /* LaunchScreen.storyboard */,", after: line)
        line = lines.validate(line: "23766C191EAA3484007A9026 /* Main.storyboard */,", after: line)
        line = lines.validate(line: "3CD1EADB205763E400DAEECB /* Model.xcdatamodeld */,", after: line)
        line = lines.validate(line: "04D5C0A21F153921008A2F98 /* Private.h */,", after: line)
        line = lines.validate(line: "04D5C0A11F15391B008A2F98 /* Protected.h */,", after: line)
        line = lines.validate(line: "04D5C0A01F153915008A2F98 /* Public.h */,", after: line)
        line = lines.validate(line: "23766C171EAA3484007A9026 /* ViewController.swift */,", after: line)
        lines.validate(line: ");", after: line)

        // iOS Tests
        let iosTestsGroup = lines.findLine("23766C291EAA3484007A9026 /* iOSTests */ = {", after: beginGroup)
        line = lines.findLine("children = (", after: iosTestsGroup)
        line = lines.validate(line: "23766C2C1EAA3484007A9026 /* Info.plist */,", after: line)
        line = lines.validate(line: "23766C2A1EAA3484007A9026 /* iOSTests.swift */,", after: line)
        lines.validate(line: ");", after: line)
    }

    func test_navigator_groups_in_filename_groups_first_order() {
        let settings = PBXOutputSettings(projNavigatorFileOrder: .byFilenameGroupsFirst)
        let lines = self.lines(fromFile: encodeProject(settings: settings))

        let beginGroup = lines.findLine("/* Begin PBXGroup section */")

        // Root
        let rootGroup = lines.findLine("23766C091EAA3484007A9026 = {", after: beginGroup)
        var line = lines.findLine("children = (", after: rootGroup)
        line = lines.validate(line: "04D5C09D1F153824008A2F98 /* Frameworks */,", after: line)
        line = lines.validate(line: "23766C131EAA3484007A9026 /* Products */,", after: line)
        line = lines.validate(line: "23766C141EAA3484007A9026 /* iOS */,", after: line)
        line = lines.validate(line: "23766C291EAA3484007A9026 /* iOSTests */,", after: line)
        lines.validate(line: ");", after: line)

        // iOS
        let iosGroup = lines.findLine("23766C141EAA3484007A9026 /* iOS */ = {", after: beginGroup)
        line = lines.findLine("children = (", after: iosGroup)
        line = lines.validate(line: "3CD1EAD92057638200DAEECB /* GroupWithoutFolder */,", after: line)
        line = lines.validate(line: "23766C151EAA3484007A9026 /* AppDelegate.swift */,", after: line)
        line = lines.validate(line: "23766C1C1EAA3484007A9026 /* Assets.xcassets */,", after: line)
        line = lines.validate(line: "23766C211EAA3484007A9026 /* Info.plist */,", after: line)
        line = lines.validate(line: "23766C1E1EAA3484007A9026 /* LaunchScreen.storyboard */,", after: line)
        line = lines.validate(line: "23766C191EAA3484007A9026 /* Main.storyboard */,", after: line)
        line = lines.validate(line: "3CD1EADB205763E400DAEECB /* Model.xcdatamodeld */,", after: line)
        line = lines.validate(line: "04D5C0A21F153921008A2F98 /* Private.h */,", after: line)
        line = lines.validate(line: "04D5C0A11F15391B008A2F98 /* Protected.h */,", after: line)
        line = lines.validate(line: "04D5C0A01F153915008A2F98 /* Public.h */,", after: line)
        line = lines.validate(line: "23766C171EAA3484007A9026 /* ViewController.swift */,", after: line)
        lines.validate(line: ");", after: line)

        // iOS Tests
        let iosTestsGroup = lines.findLine("23766C291EAA3484007A9026 /* iOSTests */ = {", after: beginGroup)
        line = lines.findLine("children = (", after: iosTestsGroup)
        line = lines.validate(line: "23766C2C1EAA3484007A9026 /* Info.plist */,", after: line)
        line = lines.validate(line: "23766C2A1EAA3484007A9026 /* iOSTests.swift */,", after: line)
        lines.validate(line: ");", after: line)
    }

    // MARK: - Build phases

    func test_build_phase_sources_unsorted() {
        let lines = self.lines(fromFile: encodeProject())
        let beginGroup = lines.findLine("/* Begin PBXSourcesBuildPhase section */")
        let files = lines.findLine("files = (", after: beginGroup)
        let endGroup = lines.findLine("/* End PBXSourcesBuildPhase section */")
        lines.validate(line: "23766C181EAA3484007A9026 /* ViewController.swift in Sources */,", betweenLine: files, andLine: endGroup)
        lines.validate(line: "23766C161EAA3484007A9026 /* AppDelegate.swift in Sources */,", betweenLine: files, andLine: endGroup)
        lines.validate(line: "3CD1EADD205763E400DAEECB /* Model.xcdatamodeld in Sources */,", betweenLine: files, andLine: endGroup)
    }

    func test_build_phase_sources_sorted() {
        let settings = PBXOutputSettings(projBuildPhaseFileOrder: .byFilename)
        let lines = self.lines(fromFile: encodeProject(settings: settings))
        let beginGroup = lines.findLine("/* Begin PBXSourcesBuildPhase section */")
        var line = lines.findLine("files = (", after: beginGroup)
        line = lines.validate(line: "23766C161EAA3484007A9026 /* AppDelegate.swift in Sources */,", after: line)
        line = lines.validate(line: "3CD1EADD205763E400DAEECB /* Model.xcdatamodeld in Sources */,", after: line)
        line = lines.validate(line: "23766C181EAA3484007A9026 /* ViewController.swift in Sources */,", after: line)
        line = lines.validate(line: "/* End PBXSourcesBuildPhase section */", after: line)
    }

    func test_build_phase_headers_unsorted() {
        let lines = self.lines(fromFile: encodeProject())
        let beginGroup = lines.findLine("/* Begin PBXHeadersBuildPhase section */")
        let files = lines.findLine("files = (", after: beginGroup)
        let endGroup = lines.findLine("/* End PBXHeadersBuildPhase section */")
        lines.validate(line: "04D5C0A41F153924008A2F98 /* Protected.h in Headers */,", betweenLine: files, andLine: endGroup)
        lines.validate(line: "04D5C0A51F153924008A2F98 /* Private.h in Headers */,", betweenLine: files, andLine: endGroup)
        lines.validate(line: "04D5C0A31F153924008A2F98 /* Public.h in Headers */,", betweenLine: files, andLine: endGroup)
    }

    func test_build_phase_headers_sorted() {
        let settings = PBXOutputSettings(projBuildPhaseFileOrder: .byFilename)
        let lines = self.lines(fromFile: encodeProject(settings: settings))
        let beginGroup = lines.findLine("/* Begin PBXHeadersBuildPhase section */")
        var line = lines.findLine("files = (", after: beginGroup)
        line = lines.validate(line: "04D5C0A51F153924008A2F98 /* Private.h in Headers */,", after: line)
        line = lines.validate(line: "04D5C0A41F153924008A2F98 /* Protected.h in Headers */,", after: line)
        line = lines.validate(line: "04D5C0A31F153924008A2F98 /* Public.h in Headers */,", after: line)
        line = lines.validate(line: "/* End PBXHeadersBuildPhase section */", after: line)
    }

    func test_build_phase_resources_unsorted() {
        let lines = self.lines(fromFile: encodeProject())
        let beginGroup = lines.findLine("/* Begin PBXResourcesBuildPhase section */")
        let files = lines.findLine("files = (", after: beginGroup)
        let endGroup = lines.findLine("/* End PBXResourcesBuildPhase section */")
        lines.validate(line: "23766C1D1EAA3484007A9026 /* Assets.xcassets in Resources */,", betweenLine: files, andLine: endGroup)
        lines.validate(line: "23766C1B1EAA3484007A9026 /* Main.storyboard in Resources */,", betweenLine: files, andLine: endGroup)
        lines.validate(line: "23766C201EAA3484007A9026 /* LaunchScreen.storyboard in Resources */,", betweenLine: files, andLine: endGroup)
    }

    func test_build_phase_resources_sorted() {
        let settings = PBXOutputSettings(projBuildPhaseFileOrder: .byFilename)
        let lines = self.lines(fromFile: encodeProject(settings: settings))
        let beginGroup = lines.findLine("/* Begin PBXResourcesBuildPhase section */")
        var line = lines.findLine("files = (", after: beginGroup)
        line = lines.validate(line: "23766C1D1EAA3484007A9026 /* Assets.xcassets in Resources */,", after: line)
        line = lines.validate(line: "23766C201EAA3484007A9026 /* LaunchScreen.storyboard in Resources */,", after: line)
        line = lines.validate(line: "23766C1B1EAA3484007A9026 /* Main.storyboard in Resources */,", after: line)
        line = lines.validate(line: "/* End PBXResourcesBuildPhase section */", after: line)
    }

    // MARK: - Test internals

    private func encodeProject(settings: PBXOutputSettings = PBXOutputSettings(), line: UInt = #line) -> String {
        do {
            return try PBXProjEncoder(outputSettings: settings).encode(proj: proj)
        } catch {
            XCTFail("Unexpected error encoding project: \(error)", line: line)
            return ""
        }
    }

    private func encodeProjectThrows<E>(error expectedError: E, line: UInt = #line) where E: Error {
        do {
            _ = try PBXProjEncoder(outputSettings: PBXOutputSettings()).encode(proj: proj)
            XCTFail("Expected '\(expectedError)' to be thrown", line: line)
        } catch {
            if type(of: expectedError) != type(of: error) {
                XCTFail("Expected '\(expectedError)' to be thrown, but got \(error)", line: line)
            }
        }
    }

    private func lines(fromFile file: String) -> [String] {
        file.replacingOccurrences(of: "\t", with: "").components(separatedBy: "\n")
    }
}

// MARK: - Line validations

private extension Array where Element == String {
    @discardableResult func validate(line string: String, betweenLine lineAbove: Int, andLine lineBelow: Int, line: UInt = #line) -> Int {
        validate(string, using: { $0 == $1 }, betweenLine: lineAbove, andLine: lineBelow, line: line)
    }

    @discardableResult func validate(lineContaining string: String, betweenLine lineAbove: Int, andLine lineBelow: Int, line: UInt = #line) -> Int {
        validate(string, using: { $0.contains($1) }, betweenLine: lineAbove, andLine: lineBelow, line: line)
    }

    func validate(_ string: String, using: (String, String) -> Bool, betweenLine lineAbove: Int, andLine lineBelow: Int, line: UInt) -> Int {
        let lineNumber = validate(string, using: using, after: lineAbove, line: line)
        if lineNumber >= lineBelow {
            XCTFail("Expected to find line between lines \(lineAbove) and \(lineBelow), but was found after \(lineBelow).", line: line)
        }
        return lineNumber
    }

    @discardableResult func validate(line string: String, onLineAfter: Int, line: UInt = #line) -> Int {
        validate(string, using: { $0 == $1 }, onLineAfter: onLineAfter, line: line)
    }

    @discardableResult func validate(lineContaining string: String, onLineAfter: Int, line: UInt = #line) -> Int {
        validate(string, using: { $0.contains($1) }, onLineAfter: onLineAfter, line: line)
    }

    func validate(_ string: String, using: (String, String) -> Bool, onLineAfter: Int, line: UInt) -> Int {
        let lineNumber = validate(string, using: using, after: onLineAfter, line: line)
        if lineNumber != onLineAfter + 1 {
            XCTFail("Expected to find at line \(onLineAfter + 1), but was found on line \(lineNumber).", line: line)
        }
        return lineNumber
    }

    @discardableResult func validate(line string: String, after: Int = 0, line: UInt = #line) -> Int {
        validate(string, using: { $0 == $1 }, after: after, line: line)
    }

    @discardableResult func validate(lineContaining string: String, after: Int = 0, line: UInt = #line) -> Int {
        validate(string, using: { $0.contains($1) }, after: after, line: line)
    }

    func validate(_ string: String, using: (String, String) -> Bool, after: Int, line: UInt) -> Int {
        let lineNumber = findLine(string, matcher: using, after: after)
        if lineNumber == endIndex {
            XCTFail("Line not found after line \(after)", line: line)
        }
        return lineNumber
    }

    func findLine(_ string: String, after: Int = 0) -> Int {
        findLine(string, matcher: { $0 == $1 }, after: after)
    }

    func findLine(containing string: String, after: Int = 0) -> Int {
        findLine(string, matcher: { $0.contains($1) }, after: after)
    }

    func findLine(_ string: String, matcher: (String, String) -> Bool, after: Int) -> Int {
        for i in after ..< endIndex {
            if matcher(self[i], string) {
                return i
            }
        }
        return endIndex
    }

    func log() {
        var line: Int = 0
        forEach {
            let lineStr = "\(line)"
            let lineNo = lineStr + String(repeating: " ", count: 5 - lineStr.count)
            print(lineNo, "|", $0)
            line += 1
        }
    }
}
