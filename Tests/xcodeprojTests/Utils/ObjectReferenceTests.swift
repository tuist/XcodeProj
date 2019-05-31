import Foundation
import XCTest
@testable import XcodeProj

class ObjectReferenceTests: XCTestCase {
    let xcodeReferenceGenerator = ReferenceGenerator(outputSettings: PBXOutputSettings(projReferenceFormat: .xcode))
    let prefixedReferenceGenerator = ReferenceGenerator(outputSettings: PBXOutputSettings(projReferenceFormat: .withPrefixAndSuffix))

    func test_reference_cachesObject() {
        let reference = PBXObjectReference()
        let object = PBXFileReference()
        XCTAssertNil(reference.getObject())
        reference.setObject(object)
        XCTAssertEqual(object, reference.getObject())
    }

    func test_reference_fetches() {
        let object = PBXFileReference()
        object.reference.fix("a")
        let objects = PBXObjects(objects: [object])
        let reference = PBXObjectReference("a", objects: objects)
        XCTAssertEqual(object, reference.getObject())
    }

    func test_reference_handleReferenceChange() {
        let object = PBXFileReference()
        let objects = PBXObjects(objects: [object])

        XCTAssertTrue(object === objects.get(reference: object.reference))
        object.reference.fix("a")
        XCTAssertTrue(object === objects.get(reference: object.reference))
        object.reference.invalidate()
        XCTAssertTrue(object === objects.get(reference: object.reference))
    }

    func test_reference_fixesValue() {
        let reference = PBXObjectReference()
        XCTAssertTrue(reference.temporary)
        reference.fix("a")
        XCTAssertEqual(reference.value, "a")
        XCTAssertFalse(reference.temporary)
    }

    func test_reference_tempHasPrefix() {
        let reference = PBXObjectReference()
        XCTAssertTrue(reference.value.hasPrefix("TEMP_"))
        reference.fix("a")
        XCTAssertFalse(reference.value.hasPrefix("TEMP_"))
        reference.invalidate()
        XCTAssertTrue(reference.value.hasPrefix("TEMP_"))
    }

    func test_reference_changesTemporary() {
        let reference = PBXObjectReference()
        XCTAssertTrue(reference.temporary)
        reference.fix("a")
        XCTAssertFalse(reference.temporary)
        reference.invalidate()
        XCTAssertTrue(reference.temporary)
    }

    func test_reference_generation_changesPerObject() {
        let file = PBXFileReference()
        let buildFile = PBXBuildFile(file: file)
        xcodeReferenceGenerator.fixReference(for: file, identifiers: ["a"])
        xcodeReferenceGenerator.fixReference(for: buildFile, identifiers: ["a"])
        XCTAssertNotEqual(file.reference.value, buildFile.reference.value)
    }

    func test_reference_generation_usesIdentifier() {
        let object = PBXFileReference()
        object.context = "1"
        let object2 = PBXFileReference()
        object2.context = "2"
        xcodeReferenceGenerator.fixReference(for: object, identifiers: ["a"])
        xcodeReferenceGenerator.fixReference(for: object2, identifiers: ["a"])
        XCTAssertNotEqual(object.reference.value, object2.reference.value)
    }

    func test_reference_generation_doesntChangeFixed() {
        let object = PBXFileReference()
        xcodeReferenceGenerator.fixReference(for: object, identifiers: ["a"])
        let value = object.reference.value
        xcodeReferenceGenerator.fixReference(for: object, identifiers: ["b"])
        XCTAssertEqual(value, object.reference.value)
    }

    func test_reference_generation_handlesMultipleDuplicates() {
        let object = PBXFileReference()
        let object2 = PBXFileReference()
        let object3 = PBXFileReference()
        xcodeReferenceGenerator.fixReference(for: object, identifiers: ["a"])
        xcodeReferenceGenerator.fixReference(for: object2, identifiers: ["a"])
        xcodeReferenceGenerator.fixReference(for: object3, identifiers: ["a"])
        XCTAssertNotEqual(object.reference.value, object2.reference.value)
        XCTAssertNotEqual(object2.reference.value, object3.reference.value)
        XCTAssertNotEqual(object3.reference.value, object.reference.value)
    }

    func test_reference_nonTempHasOnlyAlphaNumerics() {
        let reference = PBXObjectReference()
        XCTAssertTrue(reference.value.hasPrefix("TEMP_"))
        reference.fix("a")
        XCTAssertTrue(reference.value.unicodeScalars.filter { CharacterSet.alphanumerics.inverted.contains($0) }.isEmpty)
        reference.invalidate()
        XCTAssertTrue(reference.value.hasPrefix("TEMP_"))
    }

    // MARK: - XCode style generation

    func test_reference_generation_xcode_isDeterministic() {
        let object = PBXFileReference()
        let object2 = PBXFileReference()
        xcodeReferenceGenerator.fixReference(for: object, identifiers: ["a"])
        xcodeReferenceGenerator.references.removeAll()
        xcodeReferenceGenerator.fixReference(for: object2, identifiers: ["a"])
        XCTAssertEqual(object.reference.value, object2.reference.value)
    }

    func test_reference_generation_xcode_nonTempHas24Characters() {
        let object = PBXFileReference()
        xcodeReferenceGenerator.fixReference(for: object, identifiers: ["a"])
        XCTAssertTrue(object.reference.value.count == 24)
    }

    func test_reference_generation_xcode_duplicatesHave24Characters() {
        let object = PBXFileReference()
        let object2 = PBXFileReference()
        xcodeReferenceGenerator.fixReference(for: object, identifiers: ["a"])
        xcodeReferenceGenerator.fixReference(for: object2, identifiers: ["a"])
        XCTAssertTrue(object.reference.value.count == 24)
        XCTAssertTrue(object2.reference.value.count == 24)
    }

    func test_reference_generation_xcode_duplicatesHaveOnlyAlphaNumerics() {
        let object = PBXFileReference()
        let object2 = PBXFileReference()
        xcodeReferenceGenerator.fixReference(for: object, identifiers: ["a"])
        xcodeReferenceGenerator.fixReference(for: object2, identifiers: ["a"])
        XCTAssertTrue(object.reference.value.unicodeScalars.filter { CharacterSet.alphanumerics.inverted.contains($0) }.isEmpty)
        XCTAssertTrue(object2.reference.value.unicodeScalars.filter { CharacterSet.alphanumerics.inverted.contains($0) }.isEmpty)
    }

    // MARK: - Prefix format generation

    func test_reference_generation_prefixed_isDeterministic() {
        let object = PBXFileReference()
        let object2 = PBXFileReference()
        prefixedReferenceGenerator.fixReference(for: object, identifiers: ["a"])
        prefixedReferenceGenerator.references.removeAll()
        prefixedReferenceGenerator.fixReference(for: object2, identifiers: ["a"])
        XCTAssertEqual(object.reference.value, object2.reference.value)
    }

    func test_reference_generation_prefixed_includesAcronym() {
        let file = PBXFileReference()
        let config = XCBuildConfiguration(name: "g")
        prefixedReferenceGenerator.fixReference(for: file, identifiers: ["a"])
        prefixedReferenceGenerator.fixReference(for: config, identifiers: ["a"])
        XCTAssertTrue(file.reference.value.hasPrefix("FR_"))
        XCTAssertTrue(config.reference.value.hasPrefix("BC_"))
    }

    func test_reference_generation_prefixed_duplicateHasSuffix() {
        let object = PBXFileReference()
        let object2 = PBXFileReference()
        prefixedReferenceGenerator.fixReference(for: object, identifiers: ["a"])
        prefixedReferenceGenerator.fixReference(for: object2, identifiers: ["a"])
        XCTAssertNotEqual(object.reference.value, object2.reference.value)
        XCTAssertTrue(object2.reference.value.hasSuffix("_2"))
    }
}
