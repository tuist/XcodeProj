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

    func test_reference_generation_includesAcronym() {
        let file = PBXFileReference()
        let config = XCBuildConfiguration(name: "g")
        referenceGenerator.fixReference(for: file, identifiers: ["a"])
        referenceGenerator.fixReference(for: config, identifiers: ["a"])
        XCTAssertTrue(file.reference.value.hasPrefix("FR_"))
        XCTAssertTrue(config.reference.value.hasPrefix("BC_"))
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
        object.identifier = "1"
        let object2 = PBXFileReference()
        object2.identifier = "2"
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
        XCTAssertTrue(object2.reference.value.hasSuffix("_2"))
    }
}
