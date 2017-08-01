import Foundation
import xcodeproj
import XCTest

final class ReferenceGeneratorSpec: XCTestCase {

    func test_generates_references() {
        let generator = ReferenceGenerator()
        let reference = generator.generateReference(PBXBuildFile.self, "file.swift")

        XCTAssert(reference.characters.count == 20)
        XCTAssertTrue(reference.hasPrefix("BF"))
        XCTAssertTrue(reference.hasSuffix("01"))
    }

    func test_generates_handles_duplicate_ids() {
        let generator = ReferenceGenerator()
        let reference1 = generator.generateReference(PBXBuildFile.self, "file.swift")
        let reference2 = generator.generateReference(PBXBuildFile.self, "file.swift")

        XCTAssert(reference1 != reference2)
        XCTAssertTrue(reference2.hasSuffix("02"))
    }

    func test_generates_resets_uniqueness() {
        let generator = ReferenceGenerator()
        let reference1 = generator.generateReference(PBXBuildFile.self, "file.swift")
        generator.reset()
        let reference2 = generator.generateReference(PBXBuildFile.self, "file.swift")

        XCTAssert(reference1 == reference2)
    }

    func test_generates_unique_ids() {
        let generator = ReferenceGenerator()
        let reference1 = generator.generateReference(PBXBuildFile.self, "file1.swift")
        let reference2 = generator.generateReference(PBXBuildFile.self, "file2.swift")
        let reference3 = generator.generateReference(PBXFileReference.self, "file1.swift")

        XCTAssert(reference1 != reference2)
        XCTAssert(reference1 != reference3)
        XCTAssert(reference2 != reference3)
    }

}
