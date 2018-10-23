import Foundation
@testable import xcodeproj
import XCTest

class ObjectReferenceTests: XCTestCase {

    let referenceGenerator = ReferenceGenerator()

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
        referenceGenerator.fixReference(for: file, identifiers: ["a"])
        referenceGenerator.fixReference(for: buildFile, identifiers: ["a"])
        XCTAssertNotEqual(file.reference.value, buildFile.reference.value)
    }

    func test_reference_generation_isDeterministic() {
        let object = PBXFileReference()
        let object2 = PBXFileReference()
        referenceGenerator.fixReference(for: object, identifiers: ["a"])
        referenceGenerator.references.removeAll()
        referenceGenerator.fixReference(for: object2, identifiers: ["a"])
        XCTAssertEqual(object.reference.value, object2.reference.value)
    }

    func test_reference_generation_usesIdentifier() {
        let object = PBXFileReference()
        object.context = "1"
        let object2 = PBXFileReference()
        object2.context = "2"
        referenceGenerator.fixReference(for: object, identifiers: ["a"])
        referenceGenerator.fixReference(for: object2, identifiers: ["a"])
        XCTAssertNotEqual(object.reference.value, object2.reference.value)
    }

    func test_reference_generation_doesntChangeFixed() {
        let object = PBXFileReference()
        referenceGenerator.fixReference(for: object, identifiers: ["a"])
        let value = object.reference.value
        referenceGenerator.fixReference(for: object, identifiers: ["b"])
        XCTAssertEqual(value, object.reference.value)
    }

    func test_reference_generation_handleDuplicates() {
        let object = PBXFileReference()
        let object2 = PBXFileReference()
        referenceGenerator.fixReference(for: object, identifiers: ["a"])
        referenceGenerator.fixReference(for: object2, identifiers: ["a"])
        XCTAssertNotEqual(object.reference.value, object2.reference.value)
    }

    func test_reference_generation_handleMultipleDuplicates() {
        let object = PBXFileReference()
        let object2 = PBXFileReference()
        let object3 = PBXFileReference()
        referenceGenerator.fixReference(for: object, identifiers: ["a"])
        referenceGenerator.fixReference(for: object2, identifiers: ["a"])
        referenceGenerator.fixReference(for: object3, identifiers: ["a"])
        XCTAssertNotEqual(object.reference.value, object2.reference.value)
        XCTAssertNotEqual(object2.reference.value, object3.reference.value)
        XCTAssertNotEqual(object3.reference.value, object.reference.value)
    }

    func test_reference_nonTempHasOnlyAlphaNumerics() {
        let reference = PBXObjectReference()
        XCTAssertTrue(reference.value.hasPrefix("TEMP_"))
        reference.fix("a")
        XCTAssertTrue(reference.value.unicodeScalars.filter { CharacterSet.alphanumerics.inverted.contains($0) }.count == 0)
        reference.invalidate()
        XCTAssertTrue(reference.value.hasPrefix("TEMP_"))
    }

    func test_reference_generation_nonTempHas32Characters() {
        let object = PBXFileReference()
        referenceGenerator.fixReference(for: object, identifiers: ["a"])
        XCTAssertTrue(object.reference.value.count == 32)
    }


    func test_reference_generation_duplicatesHasOnlyAlphaNumerics() {
        let object = PBXFileReference()
        let object2 = PBXFileReference()
        referenceGenerator.fixReference(for: object, identifiers: ["a"])
        referenceGenerator.fixReference(for: object2, identifiers: ["a"])
        XCTAssertTrue(object.reference.value.unicodeScalars.filter { CharacterSet.alphanumerics.inverted.contains($0) }.count == 0)
        XCTAssertTrue(object2.reference.value.unicodeScalars.filter { CharacterSet.alphanumerics.inverted.contains($0) }.count == 0)
    }

}
